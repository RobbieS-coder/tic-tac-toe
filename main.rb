class Board
	attr_reader :board

	def initialize
		@board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	end

	def display_board
		puts "#{@board[0]} | #{@board[1]} | #{@board[2]}\n--+---+--\n#{@board[3]} | #{@board[4]} | #{@board[5]}\n--+---+--\n#{@board[6]} | #{@board[7]} | #{@board[8]}"
	end

	def update_board(player, cell)
		player.players_cells.push(cell)
		@board[cell - 1] = player.token
	end
end

class Game
	WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

	def initialize
		@board = Board.new
		@player_one = Player.new
		@player_two = Player.new
		@current_player = @player_two
	end

	def start_game
		@board.display_board
		until	game_over? do
			play_round
		end
		announce_winner
	end

	def play_round
		switch_player
		loop do
			puts "Where does #{@current_player.name} want to go?"
			cell = gets.chomp.to_i
			if valid_cell?(cell)
				@board.update_board(@current_player, cell)
				@board.display_board
				break
			else
				puts "Invalid input. Please enter a valid cell."
				@board.display_board
			end
		end
	end

	def valid_cell?(cell)
		cell.between?(1, 9) && !(Player.player_tokens.include?(@board.board[cell - 1]))
	end

	def game_over?
		WINNING_COMBOS.any? { |combo| (combo - @current_player.players_cells).empty? } || board_full?
	end

	def board_full?
    @board.board.all? { |cell| cell == @player_one.token || cell == @player_two.token }
  end

	def announce_winner
		if WINNING_COMBOS.any? { |combo| (combo - @player_one.players_cells).empty? }
			puts "#{@player_one.name} won!"
		elsif WINNING_COMBOS.any? { |combo| (combo - @player_two.players_cells).empty? }
			puts "#{@player_two.name} won!"
		elsif board_full?
			puts "It was a draw!"
		end
	end

	def switch_player
  	@current_player = @current_player == @player_one ? @player_two : @player_one
	end
end

class Player
	attr_accessor :players_cells
	attr_reader :name, :token

	@@player_number = 1
	@@player_names = []
	@@player_tokens = []

	def self.player_tokens
		@@player_tokens
	end

	def initialize
		assign_name
		assign_token
		@players_cells = []
		@@player_number += 1
	end

	def assign_name
    loop do
      puts "Enter Player #{@@player_number}'s name:"
      @name = gets.chomp
      break if valid_name?
      puts "Player name must be unique."
    end
    @@player_names << @name
  end

  def valid_name?
    !@name.empty? && !@@player_names.include?(@name)
  end

  def assign_token
    loop do
      puts "Enter Player #{@@player_number}'s token (it must be a non-numeric single character):"
      @token = gets.chomp
      break if valid_token?
      puts "Token must be one character, non-numeric and unique."
    end
    @@player_tokens << @token
  end

  def valid_token?
    @token.length == 1 && !@token.match?(/\d/) && !@@player_tokens.include?(@token)
  end
end

game = Game.new
game.start_game