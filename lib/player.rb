require_relative 'display.rb'

class Player
	attr_reader :name, :colour, :piece
	include Display

	def initialize (name, colour)
		@name = name
		@colour = colour
		@piece = self.colour == "red" ? "o".red : "o".blue 
	end

	def choose_column # the GAME knows which columns are full...
		begin
			puts choose_column_message
			col = gets.chomp
			raise "Enter a single digit number (0/1/2/3)" unless col.match(/^[0-9]$/)
			col = col.to_i
			raise "Enter a valid column (0/1/2/3)" unless [0,1,2,3].include? col 
		rescue
			retry
		end
		return col
	end
end