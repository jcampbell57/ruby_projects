class Game

  public

  def self.start_game
    p "One player or two?"
    get_player_count()
    if @@player_count.between?(1,2)
      play()
    end
  end

  private 

  @@player_count = 0
  @@board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"] 

  def self.play
    display_board()
    select_move()
  end

  def self.verify_selection(input)
    if (@@board[input - 1] == "X" || @@board[input - 1] == "O")
      p "That space has already been taken!"
      display_board()
      select_move()
    else
      @@board[input - 1] = "X"  
      check_for_winner()
    end
  end

  def self.verify_input(input)
    unless input.between?(1,9)
      p "Please input a number 1 through 9."
      select_move()
    else 
      verify_selection(input)
    end
  end

  def self.select_move
    p "Select your move:"
    input = gets.chomp.to_i
    verify_input(input)
  end

  def self.get_player_count
    player_count = gets.chomp.to_i
    unless player_count == 1 || player_count == 2
      p "Please input '1' or '2'"
      get_player_count()
    else
      @@player_count = player_count
      p "player count: #{@@player_count}"
    end
  end

  def self.display_board
    p @@board[0..2]
    p @@board[3..5]
    p @@board[6..8]
  end

  def self.check_for_winner
    if (@@board[0] == "X" && @@board[1] == "X" && @@board[2] == "X" ||
      @@board[3] == "X" && @@board[4] == "X" && @@board[5] == "X" ||
      @@board[6] == "X" && @@board[7] == "X" && @@board[8] == "X" ||
      @@board[0] == "X" && @@board[3] == "X" && @@board[6] == "X" ||
      @@board[1] == "X" && @@board[4] == "X" && @@board[7] == "X" ||
      @@board[2] == "X" && @@board[5] == "X" && @@board[8] == "X" ||
      @@board[0] == "X" && @@board[4] == "X" && @@board[8] == "X" ||
      @@board[2] == "X" && @@board[4] == "X" && @@board[6] == "X")
      display_board()
      puts 'X wins!'
    elsif (@@board[0] == "O" && @@board[1] == "O" && @@board[2] == "O" ||
      @@board[3] == "O" && @@board[4] == "O" && @@board[5] == "O" ||
      @@board[6] == "O" && @@board[7] == "O" && @@board[8] == "O" ||
      @@board[0] == "O" && @@board[3] == "O" && @@board[6] == "O" ||
      @@board[1] == "O" && @@board[4] == "O" && @@board[7] == "O" ||
      @@board[2] == "O" && @@board[5] == "O" && @@board[8] == "O" ||
      @@board[0] == "O" && @@board[4] == "O" && @@board[8] == "O" ||
      @@board[2] == "O" && @@board[4] == "O" && @@board[6] == "O")
      display_board()
      puts 'O wins!'
    else
      display_board()
      select_move()
    end
  end
end

class Player

end

class Computer

end

Game.start_game()
