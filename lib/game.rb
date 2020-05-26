require_relative 'display.rb'

class Game
	attr_reader :turn, :players, :board
	include Display

	def initialize
		@players = setup_players
		@board = Board.new
		@turn = 0
		play_game
	end

	private

	def setup_players
		p1 = create_player
		p2 = create_player(p1)
		[p1, p2]
	end

	def play_turn
		column_index = players[turn].choose_column
		column = board.cells.transpose[column_index]
		while board.column_full? column
			column_index = players[turn].choose_column
			column = board.cells.transpose[column_index]
		end
		board.play_piece(column_index, players[turn])
	end

	def turn=(str)
		@turn = str
	end

	def next_turn
		self.turn = turn ^ 1 # swaps
	end

	def turn_sequence
		loop do
			board.display_board
			play_turn
			break if game_over?
			next_turn
		end
	end

	def game_over?
		board.sliding_grid_check || board.full?
	end

	def create_player(other=nil)
		valid_colours = ["red", "blue"]
		print enter_name_message
		name = gets.chomp
		if !other
			begin 
				print choose_colour_message
				colour = gets.chomp
				raise "Colour not valid" unless valid_colours.include? colour
			rescue
				retry
			end
		else 
			colour = valid_colours.select{|el| el != other.colour}.first
		end
		puts player_welcome_message(name, colour) # "hi #name, your pieces are #colour"
		Player.new(name, colour)
	end

	def play_game
		game_commence_message
		turn_sequence
		board.display_board
		if board.full?
			puts draw_message
		else
			puts win_message (players[turn])
		end
		play_again?
	end

	def play_again?
		puts play_again_message
		ans = gets.chomp
		Game.new if ans.downcase.start_with?("y")
	end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def blue
    colorize(34)
  end
end
