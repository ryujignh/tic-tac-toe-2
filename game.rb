require 'pry'

class Game
  def initialize
    @game_board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @player_type = "X"
    @play_count = 1
  end

  def next_player
    {
      "X" => "O",
      "O" => "X"
    }
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

  # Ask user input
  def play
    # Check if board is still playable by checking if there are empty cells available
    while playable?
      display_board
      puts "Round #{@play_count}: Please select the number"
      # Gets input from user
      user_input_idx = gets.strip.to_i - 1
      # If input is valid, then save input to the gaming board
      if input_valid?(user_input_idx) & board_empty?(user_input_idx)
        @game_board[user_input_idx] = @player_type

        if winner
          puts "Congratulations! #{@player_type} won!"
          break
          return
        end
        # Change player type and continue play
        switch_player
        @play_count += 1
        play
      else
        play
      end
    end
  end

  def playable?
    @play_count <= @game_board.length && !winner
  end

  def switch_player
    @player_type = next_player[@player_type]
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

  # Input have to be either o or x

  # Display user input on the gaming board
  # Check if player wins
  def winner
    lines = [
      [0, 1, 2], # 横1列目
      [3, 4, 5], # 横2列目
      [6, 7, 8], # 横3列目
      [0, 3, 6], # 縦1列目
      [1, 4, 7], # 縦2列目
      [2, 5, 8], # 縦3列目
      [0, 4, 8], # 左 -> 右斜め
      [2, 4, 6], # 右 -> 左斜め
    ]

    lines.each do |line|
      a, b, c = line

      if @game_board[a] && @game_board[a] == @game_board[b] && @game_board[a] == @game_board[c]
        return @game_board[a]
      end
    end
    nil
  end

  # Let CPU to input response
  # Display CPU response on the gaming board
  # Check if CPU wins
  # Display the gaming board
  # end
end

Game.new.play