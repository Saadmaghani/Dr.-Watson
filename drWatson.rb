require 'set'
require './classes'

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
	def get_unownd_cards
		get_unownd_cards = lambda{|symbol, obj|
			obj.owned_by == ""
		}
	end
	def get_ownd_cards
		get_ownd_cards = lambda{|symbol,obj|
			obj.owned_by!=""
		}
	end
	def add_if_unownd(cards,hash,add_to)
		cards.each{|card|
			add_to.add(card) if hash.has_key?(card.to_sym)
		}
	end
	def del_poss_if_ownd

		owned_cards = $all_cards.select(&get_ownd_cards)
		owned_cards.each{|sym, card_obj|
			$possible_cards.each{|key, set|
				set.delete(sym.to_s)
			}
		}	
	end
	def get_player_by_order(order)
		p = $all_players.select{|key,player|
			player.order == order
		}
		return p.keys[0]
	end
	def del_poss_if_im(im_array, player) #player given in sym
		im_array.each{|card|
			$possible_cards[player].delete(card)
		}
	end
end

#
def update_lists
	include AlgoHelper
	ls = $all_suggestions[$all_suggestions.length]
	unowned_cards = $all_cards.select(&get_unownd_cards)

	weapon = ls.weapon
	suspect = ls.suspect
	room = ls.room
	disproved = ls.disproved_by

	#updates owned cards
	card_shown = ls.card_shown
	if card_shown !=""
		disproved_by = ls.disproved_by
		$all_cards[card_shown.to_sym].owned_by = disproved_by
		
	end

	#updates owned cards based on all the previous suggestions: 
	#if 2 cards owned by someone other than the person disproving, then 3rd card owned by disproving dude
	$all_suggestions.each{|key, sug|
		dis_by = sug.disproved_by
		count = 0
		poss_card = ""
		[sug.weapon,sug.room,sug.suspect].each{|card|
			owned_by = $all_cards[card.to_sym].owned_by
			if owned_by != dis_by
				owned_by !="" ? count+=1 : poss_card=card
			end
		}
		if count == 2 && poss_card !=""
			puts poss_card
			$all_cards[poss_card.to_sym].owned_by = dis_by
		end
	}

	#updates impossible list
	pos_asked = $all_players[ls.suggest_by.to_sym].order
	pos_ans = disproved == "" ? pos_asked : $all_players[disproved.to_sym].order
	pos_ans+=4 if pos_ans <= pos_asked
	for i in ((pos_asked+1)...pos_ans)
		order = (i-1)%4 + 1
		player_sym = get_player_by_order(order)
		add_if_unownd([weapon,room,suspect], unowned_cards, $impossible_cards[player_sym])
		del_poss_if_im([weapon,room,suspect],player_sym)
	end

	#updates possible cards	
	add_if_unownd([weapon,room,suspect], unowned_cards, $possible_cards[disproved.to_sym]) if disproved !=""
	del_poss_if_ownd

	puts $all_cards
	puts $possible_cards
	puts $impossible_cards
	
end

def solve_cluedo
	#algorithm 1: simplest one. in which you find out all the cards people have and the cards which arent there are in the envelope	
	unowned_cards = $all_cards.select(&AlgoHelper.get_unownd_cards)
	return unowned_cards if unowned_cards.length == 3 

	#algorithm 2: gets the cards which are impossible to all players
	solution = Array.new
	keys = $impossible_cards.keys
	solution = $impossible_cards[keys[0]].to_a

	solution.delete_if{|acard|
		result = for i in (1...keys.length)
			val = $impossible_cards[keys[i]].to_a
			found = false
			val.each{|bcard|
				found = true if acard == bcard
			}			
			break(true) if !found
		end
		(result==true) ? true : false
	}
	return solution if solution.length == 3
	
	return 0
end

$possible_cards = Hash.new
$impossible_cards = Hash.new

#main body:
require './setup'

found=0
until found!=0
	parse_suggest(gets.chomp)
	update_lists
	break if (found = solve_cluedo) !=0
end
puts "!!!!!!!!! SOLUTION FOUND !!!!!!!!!!!!!"
found.each{|key, val|
	puts key.to_s
}