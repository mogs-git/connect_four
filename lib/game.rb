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
		while column_full? column
			column_index = players[turn].choose_column
			column = board.cells.transpose[column_index]
		end
		board.cells[next_empty_position(column_index)][column_index] = players[turn].piece
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

	def next_empty_position column_index
		empty_cell = " "
		board.cells.transpose[column_index].rindex(empty_cell)
	end

	def column_full? column # column is an array of four cells
		empty_cell = " "
		column.count{|el| el == empty_cell} == 0
	end

	def winning_combinations
		rows = self.board.cells[0..3]
		columns = self.board.cells.transpose[0..3]
		diagonals = Array.new(2){Array.new(1).compact}
		(0..3).to_a.each do |val|
			diagonals.first.push(self.board.cells[val][val])
			diagonals.last.push(self.board.cells[3-val][val])
		end
		return rows + columns + diagonals
	end

	def all_same? four
		four.uniq.length == 1
	end

	def none_empty? four
		empty_cell = " "
		four.none?{|el| el == empty_cell}
	end

	def board_full?
		board.cells.flatten.none? {|cell| cell == " "}
	end

	def connected_four?
		winning_combinations.any? {|combo| all_same?(combo) && none_empty?(combo)}
	end

	def game_over?
		connected_four? || board_full?
	end

	def create_player(other=nil)
		valid_colours = ["red", "blue"]
		puts enter_name_message
		name = gets.chomp
		if !other
			begin 
				puts choose_colour_message
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
		turn_sequence
		board.display_board
		if board_full?
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
