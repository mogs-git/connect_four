class Board
	attr_accessor :cells,:n_rows, :n_cols
	def initialize 
		@n_rows = 6
		@n_cols = 7
		@cells = build_board
	end

	def display_board
		puts
		puts "  0  1  2  3  4  5  6 "
		cells.each do |row|
			string = "|"
			row.each do |cell|
				string += " #{cell} "
			end
			string += "|"
			puts string
		end
		puts "-"*(3*8 -1)
		puts
	end 

	def full?
		cells.flatten.none? {|cell| cell == " "}
	end

	def sliding_grid_check
		# start in top left of board (0,0)
		# move across rows, then down columns, until n_rows-4, n_cols-4
		# call connected_four on every subgrid
		row_origins = (0..n_rows-4).to_a
		column_origins = (0..n_cols-4).to_a 
		row_origins.each do |x|
			column_origins.each do |y|
				return true if connected_four?(x, y)
			end
		end
		return false
	end

	def play_piece (column_index, player)
		next_row = next_empty_position(column_index)
		cells[next_row][column_index] = player.piece
	end

	def column_full? column # column is an array of four cells
		empty_cell = " "
		column.count{|el| el == empty_cell} == 0
	end

	private

	def next_empty_position column_index
		empty_cell = " "
		cells.transpose[column_index].rindex(empty_cell)
	end

	def connected_four? (origin_x, origin_y)
		winning_combinations(origin_x, origin_y).any? {|combo| all_same?(combo) && none_empty?(combo)}
	end

	def winning_combinations (origin_x, origin_y)
		# puts "testing #{origin_x} to #{origin_x+3},#{origin_y} to #{origin_y+3}"
		rows = cells[origin_x..(origin_x+3)]
		rows = rows.map {|sub_array| sub_array[origin_y..(origin_y+3)]}
		columns = cells.transpose[origin_y..(origin_y+3)]
		columns = columns.map {|sub_array| sub_array[origin_x..(origin_x+3)]}
		# puts "columns: #{columns.to_s}" if origin_x == 2 && origin_y == 3
		diagonals = Array.new(2){Array.new(1).compact}
		(0..3).to_a.each do |val|
			diagonals.first.push(cells[origin_x + val][origin_y + val])
			diagonals.last.push(cells[origin_x + (3-val)][origin_y + val])
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

	def build_board	
		Array.new(6) { Array.new(7, " ") }
	end
end