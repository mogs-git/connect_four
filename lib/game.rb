require_relative 'display.rb'

class Game
	attr_accessor :board, :players, :turn
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
		column_index = self.players[turn].choose_column
		column = board.cells.transpose[column_index]
		while column_full? column
			column_index = self.players[turn].choose_column
			column = board.cells.transpose[column_index]
		end
		board.cells[next_empty_position(column_index)][column_index] = self.players[turn].piece
	end

	def next_turn
		self.turn = self.turn ^ 1 # swaps
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
			puts "board at #{val},#{val}: #{self.board.cells[val][val]}"
			diagonals.first.push(self.board.cells[val][val])
			diagonals.last.push(self.board.cells[3-val][val])
		end
		puts diagonals.to_s
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
		colours = ["red", "blue"]
		puts enter_name_message
		name = gets.chomp
		if !other
			puts choose_colour_message
			colour = colours[colours.index(gets.chomp)]
		else 
			colour = colours.select{|el| el != other.colour}.first
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
	attr_reader :name, :colour, :piece
	include Display

	def initialize (name, colour)
		@name = name
		@colour = colour
		@piece = self.colour == "red" ? "o".red : "o".blue 
	end

	def choose_column # the GAME knows which columns are full...
		puts choose_column_message
		gets.chomp.to_i
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


board = []
4.times {|i|board.push ["a", "b","c", "d"]}

puts board.to_s
puts board.transpose.to_s
board.transpose[0][0] = "e"
board[0][0] = "e"
puts board.to_s

Game.new