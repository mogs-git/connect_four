module Display
	def enter_name_message
		"Please enter your name:"
	end

	def choose_colour_message
		"Please choose the colour of your pieces (red or blue)"
	end

	def player_welcome_message(name, colour)
		"Hi #{name}, your pieces are #{colour}!"
	end

	def draw_message
		"It's a draw!"
	end

	def win_message (winner)
		"#{winner.name} wins! Well done!"
	end

	def play_again_message
		"Would you like to play again? (y/n)"
	end

	def choose_column_message
		"Choose a column (0/1/2/3)"
	end

end