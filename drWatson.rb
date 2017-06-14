class Cards
	$all_cards = {}
	attr_reader :name, :type
	def initialize(type, name)
		@type = type
		@name = name
		$all_cards[name]=self
	end
end

class Players
	$all_players = {}
	def initialize(name, total_cards, order)
		@name = name
		@total_cards = total_cards
		@order = order
		$all_players[name] = self
	end
end

class Suggestions
	def initalize(suggest_by, suspect, weapon, room, disproved_by, card_shown=nil)
		@suggest_by = suggest_by
		@suspect = suspect
		@weapon = weapon
		@room = room
		@disproved_by = disproved_by
		@card_shown = card_shown
	end
end

Cards.new("weapon","slingshot")
Cards.new("room","bedroom")
Cards.new("room","courtyard")
Cards.new("suspect","mr white")
puts $all_cards