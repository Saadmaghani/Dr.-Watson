require './classes'
require 'set'

module ParserHelper
	#going to handle errors from the input
	#md_array=[[hash to check in, string object to put in],[],[]]
	def error_handler(md_array=nil, card=nil)
		err = true
		while err==true
			err = yield(md_array, card)
		end
		return err
	end
	def findnset
		findnset = lambda {|md_array, card|
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
	error_handler([[$all_players, new_suggest.suggest_by]], suggest[0], &ParserHelper.findnset)

	for i in 1..3
		error_handler([[$all_weapons, new_suggest.weapon],[$all_rooms, new_suggest.room],[$all_suspects, new_suggest.suspect]], suggest[i], &ParserHelper.findnset)
	end
	
	error_handler([[$all_players, new_suggest.disproved_by]], suggest[4], &ParserHelper.findnset) if len>=5

	error_handler([[$all_cards, new_suggest.card_shown]], suggest[5], &ParserHelper.findnset) if len==6

	puts $all_suggestions
end

module AlgoHelper
	def get_unowned_cards
		get_unowned_cards = lambda{|symbol, obj|
			obj.owned_by == ""
		}
	end

	def add_if_unowned(cards,hash,add_to)
		cards.each{|card|
			add_to.add(card) if hash.has_key?(card.to_sym)
		}
	end
	def delete_possible_if_owned(card)
		$possible_cards.each{|key, set|
			set.delete(card)
		}
	end
end

#
def update_lists
	include AlgoHelper
	ls = $all_suggestions[$all_suggestions.length]
	
	#updates owned cards
	card_shown = ls.card_shown
	if card_shown !=""
		disproved_by = ls.disproved_by
		$all_cards[card_shown.to_sym].owned_by = disproved_by
		delete_possible_if_owned(card_shown)
	end

	#updates possible cards
	disproved = ls.disproved_by
	if disproved !=""
		unowned_cards = $all_cards.select(&AlgoHelper.get_unowned_cards)
		add_if_unowned([ls.weapon,ls.room,ls.suspect], unowned_cards, $possible_cards[disproved.to_sym])		
	end
	puts $possible_cards
end

def abc
	#algorithm 1: simplest one. in which you find out all the cards people have and the cards which arent there are in the envelope	
	unowned_cards = $all_cards.select(&AlgoHelper.get_unowned_cards)
	return unowned_cards if unowned_cards.length ==3 

	#algorithm 2: guess which cards people have. so this makes use of disproved_by and creates a list of possible cards players have. 
	#and works with that possible list
	

	return 0
end

$possible_cards = Hash.new


require './setup'
#main body:
found=0
until found!=0
	parse_suggest(gets.chomp)
	update_lists
	break if (found = abc) !=0
end

found.each{|key|
	puts key.to_s
}