require_relative '../lib/board.rb'

describe "#full?" do
	let(:board) {Board.new}

	it "returns false when empty" do
		expect(board.full?).to eql(false)
	end

	it "returns false when partially full" do
		board.cells[0][0] = "a"
		board.cells[1][0] = "b"
		board.cells[2][0] = "a"
		expect(board.full?).to eql(false)
	end

	it "returns true when full" do
		filled_row = Array.new(board.n_cols) {"a"}
		board.cells.map! {|row| row = filled_row}

		expect(board.full?).to eql(true)
	end
end

describe "#sliding_grid_check" do
	let(:board) {Board.new}

	def populate_board(dir = "row_right", len = 4, start={:x => 0, :y => 0}, symbol = "a")
		len.times do |i|
			case dir
			when "row_right"
				board.cells[start[:x]][start[:y]+i] = symbol
			when "row_left"
				board.cells[start[:x]][start[:y]-i] = symbol
			when "column_up"
				board.cells[start[:x]-i][start[:y]] = symbol
			when "column_down"
				board.cells[start[:x]+i][start[:y]] = symbol
			when "diagonal_up"
				board.cells[start[:x]-i][start[:y]+i] = symbol
			when "diagonal_down"
				board.cells[start[:x]+i][start[:y]+i] = symbol
			else
				nil
			end
		end
		board
	end

	it "returns true when four in row from corner" do
		populate_board("row_right", 4, {:x => 5, :y => 0}, "a")
		board.display_board
		expect(board.sliding_grid_check).to eql(true)
	end

	it "returns true when more than four in row from corner" do
		populate_board("row_right", 6, {:x => 5, :y => 0}, "a")
		board.display_board
		expect(board.sliding_grid_check).to eql(true)
	end

	it "returns true when upwards diagonal" do
		populate_board("diagonal_up", 4, {:x => 5, :y => 0}, "a")
		board.display_board
		expect(board.sliding_grid_check).to eql(true)
	end

	it "returns true when downward diagonal" do
		populate_board("diagonal_down", 4, {:x => 0, :y => 0}, "a")
		board.display_board
		expect(board.sliding_grid_check).to eql(true)
	end

	it "returns false when board is empty" do
		board.display_board
		expect(board.sliding_grid_check).to eql(false)
	end

	it "returns false when three in row from corner" do
		board_copy = populate_board("row_right", 3, {:x => 5, :y => 0}, "a")
		board_copy.display_board
		expect(board.sliding_grid_check).to eql(false)
	end

	it "returns false when blocked by other player" do
		populate_board("row_right", 2, {:x => 5, :y => 0}, "a")
		populate_board("row_right", 1, {:x => 5, :y => 2}, "b")
		populate_board("row_right", 1, {:x => 5, :y => 3}, "a")
		board.display_board
		expect(board.sliding_grid_check).to eql(false)
	end
end