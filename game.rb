require 'pry'
require_relative 'player'

class Game
  def initialize
    @game_board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @player_1 = nil
    @player_2 = nil
  end

  def start
    @player_1 = set_players
    @player_2 = set_players
    @current_player = @player_1
    play
  end

  def set_players
    puts "Please enter your symbol"
    symbol = gets.strip.to_s
    Player.new(symbol)
  end

  # Ask user input
  def play
    while playable?
      turn
    end

    if winner
      # Show winner and message
      display_board
      puts "Congratulations! #{winner} won!"
    elsif draw
      display_board
      # Show draw message
      puts "Cat's game!"
    end
    puts "Thank you for playing!"
  end

  private

  def turn
    puts "Player: #{@current_player.symbol}: Please select the number"
    display_board
    # Gets input from user
    user_input_idx = gets.strip.to_i - 1

    if valid_move?(user_input_idx)
      # If input is valid, then save input to the gaming board
      move(user_input_idx)
      # Then switch current player
      switch_player
    else
      # If invalid input, ask for input again
      play
    end
  end

  def next_player(current_player)
    {
      @player_1 => @player_2,
      @player_2 => @player_1,
    }[current_player]
  end

  # Display 3x3 board
  def display_board
    puts "----------------"
    for i in 0..@game_board.length do
      if i % 3 == 2
        print("#{@game_board[i]}\n") # line break
      else
        print("#{@game_board[i]}")
      end
    end
    puts "----------------"
    nil
  end

  def valid_move?(user_input_idx)
    input_valid?(user_input_idx) & board_empty?(user_input_idx)
  end

  def move(user_input_idx)
    @game_board[user_input_idx] = @current_player.symbol
  end

  def playable?
    !board_full? && !winner && !draw
  end

  def switch_player
    @current_player = next_player(@current_player)
  end

  # Input needs to be between 1 - 9
  def input_valid?(input)
    if input.between?(0, 8)
      true
    else
      puts "Please select number between 1 - 9"
      play
    end
  end

  # check if selected cell is empty or not
  def board_empty?(input)
    if %w[O X].include?(@game_board[input])
      puts "The number is taken, please select a different number"
    else
      true
    end
  end

  # Check if player wins
  def winner
    lines = [
      [0, 1, 2], # 1st Row
      [3, 4, 5], # 2nd Row
      [6, 7, 8], # 3rd Row
      [0, 3, 6], # 1st Column
      [1, 4, 7], # 2st Column
      [2, 5, 8], # 3st Column
      [0, 4, 8], # Diagonal (Bottom left to top right)
      [2, 4, 6], # Diagonal (Top right to bottom left)
    ]

    lines.each do |line|
      a, b, c = line

      if @game_board[a] && @game_board[a] == @game_board[b] && @game_board[a] == @game_board[c]
        return @game_board[a]
      end
    end
    nil
  end

  def draw
    if !winner & board_full?
      true
    elsif !winner || !board_full?
      false
    else
      winner
    end
  end

  def board_full?
    @game_board.all? { |i| i == @player_1.symbol || i == @player_2.symbol }
  end

  # Let CPU to input response
  # Display CPU response on the gaming board
  # Check if CPU wins
  # Display the gaming board
  # end
end

Game.new.start