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

	private

	def build_board
		board = []
		row = []
		n_cols.times {row.push(" ")}
		n_rows.times {board.push(row.dup)}
		return board
	end
end