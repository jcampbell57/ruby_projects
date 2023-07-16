# tic tac toe game logic
class Game
  attr_reader :board, :mode

  # initialization methods

  def initialize(board = [1, 2, 3, 4, 5, 6, 7, 8, 9], mode = prompt_mode)
    self.board = board
    self.mode = mode
  end

  def prompt_mode
    puts '1 player or 2?'
    check_mode_input(gets.chomp.to_i)
  end

  def check_mode_input(input)
    if input == 1
      1
    elsif input == 2
      2
    else
      puts "please enter '1' or '2' for number of players"
      check_mode_input(gets.chomp.to_i)
    end
  end

  protected

  # game methods

  def display_board
    puts board[0..2]
    puts board[3..5]
    puts board[6..8]
  end

  attr_writer :board, :mode

  # winner selection methods

  WINNING_ARRAYS = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                    [0, 3, 6], [1, 4, 7], [2, 5, 8],
                    [0, 4, 8], [2, 4, 6]]

  def declare_winner
    WINNING_ARRAYS.each do |winning_array|
      return 'X wins!' if winner?(winning_array, 'X')
      return 'Y wins!' if winner?(winning_array, 'O')
    end
  end

  def winner?(winning_array, marker)
    (board[winning_array[0]] == marker && board[winning_array[1]] == marker && board[winning_array[2]] == marker)
  end

  # def old_winner?(marker)
  #   (board[0] == marker && board[1] == marker && board[2] == marker) ||
  #     (board[3] == marker && board[4] == marker && board[5] == marker) ||
  #     (board[6] == marker && board[7] == marker && board[8] == marker) ||
  #     (board[0] == marker && board[3] == marker && board[6] == marker) ||
  #     (board[1] == marker && board[4] == marker && board[7] == marker) ||
  #     (board[2] == marker && board[5] == marker && board[8] == marker) ||
  #     (board[0] == marker && board[4] == marker && board[8] == marker) ||
  #     (board[2] == marker && board[4] == marker && board[6] == marker)
  # end
end

Game.new
