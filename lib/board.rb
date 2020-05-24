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