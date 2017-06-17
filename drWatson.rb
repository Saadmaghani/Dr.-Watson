class Weapons
	$all_weapons = {}
	@@count =0
	attr_reader :name, :owned_by
	
	def initialize(name, owned_by=0)
		@name = name
		@owned_by = owned_by
		@@count +=1
		$all_weapons[name.to_sym]=self
	end

	def self.count
		return @@count
	end
end

class Suspects
	$all_suspects = {}
	@@count =0
	attr_reader :name, :owned_by
	
	def initialize(name, owned_by=0)
		@name = name
		@owned_by = owned_by
		@@count +=1
		$all_suspects[name.to_sym]=self
	end

	def self.count
		return @@count
	end
end

class Rooms
	$all_rooms = {}
	@@count =0
	attr_reader :name, :owned_by
	
	def initialize(name, owned_by=0) #name is basically the identifier
		@name = name
		@owned_by = owned_by
		@@count+=1
		$all_rooms[name.to_sym]=self
	end

	def self.count
		return @@count
	end
end

class Players
	$all_players = {}
	attr_reader :name,:total_cards,:order
	def initialize(name, total_cards, order) 
		@name = name
		@total_cards = total_cards
		@order = order
		$all_players[name.to_sym] = self
	end
end

class Suggestions
	$all_suggestions={}
	@@suggestID=0
	attr_accessor :suggest_by, :suspect, :weapon, :room, :disproved_by, :card_shown
	
	def initialize()
		@suggest_by = ""
		@suspect = ""
		@weapon = ""
		@room = ""
		@disproved_by = ""
		@card_shown = ""
		@@suggestID+=1
		$all_suggestions[@@suggestID]=self
	end
end

#hard coded all cards for now
Weapons.new("candlestick"); Weapons.new("revolver"); Weapons.new("rope"); Weapons.new("wrench"); Weapons.new("pipe"); Weapons.new("knife")
Suspects.new("white"); Suspects.new("peacock"); Suspects.new("scarlet"); Suspects.new("mustard"); Suspects.new("green"); Suspects.new("plum")
Rooms.new("study"); Rooms.new("library"); Rooms.new("conservatory"); Rooms.new("hall"); Rooms.new("kitchen"); Rooms.new("ballroom"); Rooms.new("dining"); Rooms.new("lounge");Rooms.new("billiard")
#not sure if all_cards needed but why not
$all_cards = [$all_suspects, $all_weapons, $all_rooms].reduce &:merge
puts $all_cards

#going to handle errors from the input
def error_handler(md_array=nil, card=nil)
	err = true
	while err==true
		err = yield(md_array, card)
	end
	return err
end

$finder = lambda {|md_array, card|
	found = false
	md_array.each{|part|
		if part[0].has_key?(card.to_sym)
			part[1].replace card
			found = true
			return false
		end
	}
	if !found
		puts "#{card} not found. re enter:"
		card.replace gets.chomp
		return true
	end
}

#parsing a suggest to form Suggestion. suggest should be a string of form "suggest_by w/r/s w/r/s w/r/s disproved_by card_shown". ie. weapon, room or suspect can be placed anywhere in 2->4 position
def parse_suggest(suggest)
	suggest = suggest.split
	len = suggest.length
	
	error_handler{
		if len < 4 or len >6
			puts "re-enter suggest. not of valid format"
			suggest = gets.chomp.split
			len = suggest.length
			true
		end
	}

	new_suggest = Suggestions.new()
	error_handler([[$all_players, new_suggest.suggest_by]], suggest[0], &$finder)

	for i in 1..3
		error_handler([[$all_weapons, new_suggest.weapon],[$all_rooms, new_suggest.room],[$all_suspects, new_suggest.suspect]], suggest[i], &$finder)
	end
	
	error_handler([[$all_players, new_suggest.disproved_by]], suggest[4], &$finder) if len>=5

	error_handler([[$all_cards, new_suggest.card_shown]], suggest[i], &$finder) if len==6

	puts $all_suggestions
end

#algorithm 1: simplest one. in which you find out all the cards people have and the cards which arent there are in the envelope
def algo1
	
end

Players.new("sg", 4, 4)
Players.new("meeks", 5, 2)
Players.new("aly", 5, 1)
Players.new("ali", 4, 3)

#main body:
found=false
until found
	parse_suggest(gets.chomp)
end
