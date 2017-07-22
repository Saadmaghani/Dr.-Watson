#hard coded all cards for now
Weapons.new("candlestick"); Weapons.new("revolver"); Weapons.new("rope"); Weapons.new("wrench"); Weapons.new("pipe"); Weapons.new("knife")
Suspects.new("white"); Suspects.new("peacock"); Suspects.new("scarlet"); Suspects.new("mustard"); Suspects.new("green"); Suspects.new("plum")
Rooms.new("study"); Rooms.new("library"); Rooms.new("conservatory"); Rooms.new("hall"); Rooms.new("kitchen"); Rooms.new("ballroom"); Rooms.new("dining"); Rooms.new("lounge");Rooms.new("billiard")
#not sure if all_cards needed but why not
$all_cards = [$all_suspects, $all_weapons, $all_rooms].reduce &:merge
puts $all_cards

count = 0
puts "Enter player information in the following format(seperated by space): name order number of cards given"
while count <18
	info = gets.chomp.split
	name = info[0].to_sym
	cards = info[2].to_i
	count += cards
	Players.new(name, cards, info[1].to_i)
	$possible_cards[name] = Set.new
	$impossible_cards[name] = Set.new
end
include ParserHelper

puts "Which player are you?"
user = gets.chomp
error_handler([[$all_players, user]], user, &ParserHelper.findnset)

puts "Enter your cards seperated by space"
cards = gets.chomp.split

for i in (0...cards.length)
	card = ""
	error_handler([[$all_cards, card]], cards[i], &ParserHelper.findnset)
	$all_cards[card.to_sym].owned_by = user
end

include AlgoHelper
unowned_cards = $all_cards.select(&AlgoHelper.get_unownd_cards).keys.map &:to_s
$impossible_cards[user.to_sym].merge(unowned_cards)

puts $all_cards
puts "Enter your suggests:"
