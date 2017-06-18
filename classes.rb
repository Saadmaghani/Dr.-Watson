class Weapons
	$all_weapons = {}
	@@count =0
	attr_reader :name
	attr_accessor :owned_by
	
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
	attr_reader :name
	attr_accessor :owned_by
	
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
	attr_reader :name
	attr_accessor :owned_by
	
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