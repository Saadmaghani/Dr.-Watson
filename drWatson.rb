require './classes'

#hard coded all cards for now
Weapons.new("candlestick")
Suspects.new("white"); Suspects.new("peacock")
Rooms.new("study"); Rooms.new("library")
#not sure if all_cards needed but why not
$all_cards = [$all_suspects, $all_weapons, $all_rooms].reduce &:merge
puts $all_cards

module ParserHelper
	#going to handle errors from the input
	def error_handler(md_array=nil, card=nil)
		err = true
		while err==true
			err = yield(md_array, card)
		end
		return err
	end
	def finder
		finder = lambda {|md_array, card|
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
	end
end

#parsing a suggest to form Suggestion. suggest should be a string of form "suggest_by w/r/s w/r/s w/r/s disproved_by card_shown". ie. weapon, room or suspect can be placed anywhere in 2->4 position
def parse_suggest(suggest)
	include ParserHelper
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
	error_handler([[$all_players, new_suggest.suggest_by]], suggest[0], &ParserHelper.finder)

	for i in 1..3
		error_handler([[$all_weapons, new_suggest.weapon],[$all_rooms, new_suggest.room],[$all_suspects, new_suggest.suspect]], suggest[i], &ParserHelper.finder)
	end
	
	error_handler([[$all_players, new_suggest.disproved_by]], suggest[4], &ParserHelper.finder) if len>=5

	error_handler([[$all_cards, new_suggest.card_shown]], suggest[5], &ParserHelper.finder) if len==6

	puts $all_suggestions
end

module AlgoHelper
	def croc
		croc = lambda{|symbol, obj|
			obj.owned_by ==0
		}
	end
end
#algorithm 1: simplest one. in which you find out all the cards people have and the cards which arent there are in the envelope
def algo1
	include AlgoHelper
	last_suggest = $all_suggestions[$all_suggestions.length]
	card_shown = last_suggest.card_shown
	if card_shown !=""
		disproved_by = last_suggest.disproved_by
		$all_cards[card_shown.to_sym].owned_by = disproved_by
	end
	checker = $all_cards.select(&AlgoHelper.croc)
	return (checker.length ==3) ? checker : 0 
end

Players.new("sg", 4, 4)
Players.new("meeks", 5, 2)
Players.new("aly", 5, 1)
Players.new("ali", 4, 3)

#main body:
found=0
until found!=0
	parse_suggest(gets.chomp)
	break if (found = algo1) !=0
end

found.each{|key|
	puts key.to_s
}