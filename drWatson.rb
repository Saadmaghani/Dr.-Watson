class Weapons
	$all_weapons = {}
	@@count =0
	attr_reader :name, :owned_by
	
	def initialize(name, owned_by=0)
		@name = name
		@owned_by = owned_by
		@@count +=1
		$all_weapons[name]=self
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
		$all_suspects[name]=self
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
		$all_rooms[name]=self
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
		$all_players[name] = self
	end
end

class Suggestions
	$all_suggestions={}
	@@suggestID=0
	attr_reader :suggest_by, :suspect, :weapon, :room, :disproved_by, :card_shown
	def initialize(suggest_by, suspect, weapon, room, disproved_by=nil, card_shown=nil) #nil if not disproved by anyone or card not shown to the user
		@suggest_by = suggest_by
		@suspect = suspect
		@weapon = weapon
		@room = room
		@disproved_by = disproved_by
		@card_shown = card_shown
		@@suggestID+=1
		$all_suggestions[@@suggestID]=self
	end
end

#hard coded all cards for now
Weapons.new("candlestick"); Weapons.new("revolver"); Weapons.new("rope"); Weapons.new("wrench"); Weapons.new("lead pipe"); Weapons.new("knife")
Suspects.new("white"); Suspects.new("peacock"); Suspects.new("scarlet"); Suspects.new("mustard"); Suspects.new("green"); Suspects.new("plum")
Rooms.new("study"); Rooms.new("library"); Rooms.new("conservatory"); Rooms.new("hall"); Rooms.new("kitchen"); Rooms.new("ballroom"); Rooms.new("dining room"); Rooms.new("lounge");Rooms.new("billiard room")
#not sure if all_cards needed but why not
#all_cards = [$all_suspects, $all_weapons, $all_rooms]

#going to handle errors from the input. not complete
def error_handler(suggest)
	while suggest.length < 4
		puts "re enter suggest. not of valid format"
		suggest = gets.chomp.split
	end

	err = false
	new_suggest = []
	until err
		if $all_players.has_key?(suggest[0]) 
			new_suggest[0] = suggest[0] 
		else
			puts "player by not found"
			suggest[0] = gets.chomp
			next
		end

		for i in 1..3
			card = suggest[i]
			found = false
			if $all_weapons.has_key?(card)
				found = true
				new_suggest[2] = card
			elsif $all_rooms.has_key?(card)
				found = true
				new_suggest[3] = card
			elsif $all_suspects.has_key?(card)
				found = true
				new_suggest[1] = card
			end
			if !found
				puts "{card} not found"
				suggest[i] = gets.chomp
				next 
			end
		end
	end	
end

#parsing a suggest to form Suggestion. suggest should be a string of form "suggest_by w/r/s w/r/s w/r/s disproved_by card_shown". ie. weapon, room or suspect can be placed anywhere in 2->4 position
#for now no error handling. assumed that suggest is of the correct form
def parse_suggest(suggest) 
	suggest = suggest.split
	
end

#algorithm 1: simplest one. in which you find out all the cards people have and the cards which arent there are in the envelope
def algo1
	
end

#main body:
found=false
until found
	parse_suggest(gets.chomp)
end
