class Game
	attr_accessor :board, :players
	attr_reader :turn
	def initialize
		@players = [create_player] << create_player(self.players[0])
		@board = Board.new
		@turn = 0
		play_game
	end

	private

	def play_turn
		chosen_column = self.players[turn].choose_column
		while !column_full? chosen_column
			chosen_column = self.players[turn].choose_column
		end
		board[next_empty_position(chosen_column)][chosen_column] = self.players[turn].piece
	end

	def next_turn
		self.turn = self.turn ^ 1 # swaps
	end

	def turn_sequence
		loop do
			play_turn
			break if game_over?
			next_turn
		end
	end

	def next_empty_position column
		empty_cell = " "
		board.transpose[column].rindex(empty_cell)
	end

	def column_full? column # column is an array of four cells
		empty_cell = " "
		column.count{|el| el == empty_cell} == 0
	end

	def winning_combinations
		rows = self.board[0..3]
		columns = self.board.transpose[0..3]
		diagonals = [[][]]
		[0..3].each do |index|
			diagonals.first.push(board[index][index])
			diagonals.last.push(board[3-index][index])
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
		winning_combinations.any? {|combo| all_same? && none_empty?}
	end

	def game_over?
		connected_four? || board.full?
	end

	def create_player(other=nil)
		colours = ["red", "blue"]
		puts enter_name_message
		name = gets.chomp
		if !other
			puts choose_colour_message
			colour = colours[colours.index(gets.chomp)]
		else 
			colour = colours.select{|el| el != other.colour}.first
		end
		puts player_welcome_message # "hi #name, your pieces are #colour"
		Player.new(name, colour)
	end

	def play_game
		turn_sequence
		if board.full?
			puts draw_message
		else
			puts win_message (players[turn])
		end
		play_again?
	end

	def play_again?
		puts play_again_message
		ans = get.chomp
		Game.new if ans.downcase.start_with?("y")
	end
end

class Board
	attr_accessor :cells
	def initialize 
		@cells = build_board
	end

	def display_board
		puts <<~HEREDOC
		  0   1   2   3  
		| #{cells[0][0]} | #{cells[0][1]} | #{cells[0][2]} | #{cells[0][3]} |
		| #{cells[1][0]} | #{cells[1][1]} | #{cells[1][2]} | #{cells[1][3]} |
		| #{cells[2][0]} | #{cells[2][1]} | #{cells[2][2]} | #{cells[2][3]} |
		| #{cells[3][0]} | #{cells[3][1]} | #{cells[3][2]} | #{cells[3][3]} |
		-----------------
		HEREDOC
	end 

	private

	def build_board
		board = []
		4.times {board.push [" ", " ", " ", " "]}
		puts board.to_s
		return board
	end
end

class Player
	def initialize (name, colour)
		@name = name
		@colour = colour
		@piece = self.colour == "red" ? "o".red : "o".blue 
	end

	def choose_column # the GAME knows which columns are full...
		puts choose_column_message
		gets.chomp
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

def swap two_value_array, current
	return current == two_value_array[0] ? two_value_array[1] : two_value_array[0]
end

board = []
4.times {|i|board.push ["a", "b","c", "d"]}

puts board.to_s
puts board.transpose.to_s
board.transpose[0][0] = "e"
board[0][0] = "e"
puts board.to_s

puts swap([1,2], 1)