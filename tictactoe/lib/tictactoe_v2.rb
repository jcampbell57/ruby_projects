# tic tac toe game logic
class Game
  attr_accessor :board, :mode, :marker, :computer_options

  # initialization methods

  def initialize(board = %w[1 2 3 4 5 6 7 8 9],
                 computer_options = [1, 2, 3, 4, 5, 6, 7, 8, 9],
                 mode = prompt_mode,
                 marker = 'X')
    self.board = board
    self.computer_options = computer_options
    self.mode = mode
    self.marker = marker
    # prompt_player_move
  end

  def prompt_player_move
    display_board
    print "#{marker}'s turn! Choose a space on the board: "
    process_move(validate_player_move(gets.chomp.to_i))
  end

  # protected

  def prompt_mode
    puts '1 player or 2?'
    validate_mode_input(gets.chomp.to_i)
  end

  def validate_mode_input(input)
    if input == 1
      1
    elsif input == 2
      2
    else
      puts "please enter '1' or '2' for number of players"
      validate_mode_input(gets.chomp.to_i)
    end
  end

  # game methods

  def process_move(input)
    board[input - 1] = marker
    set_marker
    return Game.new.prompt_player_move if winner_declared?

    computer_options.delete(input)
    computer_move if mode == 1 && marker == 'O'
    prompt_player_move
  end

  def computer_move
    print 'Computer chooses... '
    computer_choice = computer_options.sample
    sleep 0.5
    puts computer_choice
    process_move(computer_choice)
  end

  def validate_player_move(input)
    if input.to_s.match(/[1-9]/) && input.to_s.size == 1
      return input unless board[input - 1] == 'X' || board[input - 1] == 'Y'

      puts 'That spot is taken, pick again!'
    else
      puts 'You must enter a space number 1-9.'
    end
    validate_player_move(gets.chomp.to_i)
  end

  def display_board
    p board[0..2]
    p board[3..5]
    p board[6..8]
  end

  def set_marker
    self.marker = (marker == 'X' ? 'O' : 'X')
  end

  # winner selection methods

  WINNING_ARRAYS = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                    [0, 3, 6], [1, 4, 7], [2, 5, 8],
                    [0, 4, 8], [2, 4, 6]]

  def winner_declared?
    WINNING_ARRAYS.each do |winning_array|
      if winner?(winning_array, 'X')
        display_board
        puts 'X wins!'
        return true
      elsif winner?(winning_array, 'O')
        display_board
        puts 'O wins!'
        return true
      end
    end
    return false unless board.count('X') + board.count('O') == 9

    display_board
    puts "It's a tie!"
    true
  end

  def winner?(winning_array, marker)
    (board[winning_array[0]] == marker && board[winning_array[1]] == marker && board[winning_array[2]] == marker)
  end
end

# Game.new
