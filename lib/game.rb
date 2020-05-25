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

	def sliding_grid_check
		# start in top left of board (0,0)
		# move across rows, then down columns, until n_rows-4, n_cols-4
		# call connected_four on every subgrid
		row_origins = (0..board.n_rows-4).to_a
		column_origins = (0..board.n_cols-4).to_a 
		row_origins.each do |x|
			column_origins.each do |y|
				return true if connected_four?(x, y)
			end
		end
		return false
	end

	def winning_combinations (origin_x, origin_y)
		# puts "testing #{origin_x} to #{origin_x+3},#{origin_y} to #{origin_y+3}"
		rows = board.cells[origin_x..(origin_x+3)]
		rows = rows.map {|sub_array| sub_array[origin_y..(origin_y+3)]}
		columns = board.cells.transpose[origin_y..(origin_y+3)]
		columns = columns.map {|sub_array| sub_array[origin_x..(origin_x+3)]}
		# puts "columns: #{columns.to_s}" if origin_x == 2 && origin_y == 3
		diagonals = Array.new(2){Array.new(1).compact}
		(0..3).to_a.each do |val|
			diagonals.first.push(board.cells[origin_x + val][origin_y + val])
			diagonals.last.push(board.cells[origin_x + (3-val)][origin_y + val])
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

	def connected_four? (origin_x, origin_y)
		winning_combinations(origin_x, origin_y).any? {|combo| all_same?(combo) && none_empty?(combo)}
	end

	def game_over?
		sliding_grid_check || board_full?
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
