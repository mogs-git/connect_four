require_relative '../lib/game.rb'

describe Board do
	context "#check_board is true game ends, #check_board is false game continues" do
		it "returns true when four in bottom row" do
			board = Board.new
			expect(board.check_board).to eql(true)
		end

		it "returns true when four in left column" do
			board = Board.new
			expect(board.check_board).to eql(true)
		end