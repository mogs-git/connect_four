module Display
	def enter_name_message
		"Please enter your name: "
	end

	def choose_colour_message
		"Please choose the colour of your pieces (red or blue): "
	end

	def player_welcome_message(name, colour)
		"\nHi #{name}, your pieces are #{colour}!\n\n"
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
		"Choose a column (0/1/2/3/4/5/6): "
	end

	def game_commence_message
		3.times do 
			print "."
			sleep(0.5)
		end
		puts
		puts
		print "LET THE GAME COMMENCE"
		puts
		puts
		3.times do 
			print "."
			sleep(0.5)
		end
		puts
		puts
	end

end