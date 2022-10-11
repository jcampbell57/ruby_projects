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
  @@board = [
    [1, 2, 3], 
    [4, 5, 6], 
    [7, 8, 9] 
  ]

  def self.play
    display_board()
    select_move()
  end

  def self.select_move
    p "Select your move:"
    input = gets.chomp.to_i
    unless input.between?(1,9)
      p "please input a number 1 through 9"
      select_move()
    else
      p input  
    end
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
    p @@board[0]
    p @@board[1]
    p @@board[2]
  end

  def self.check_for_winner
    if (board[0][0] == x && board[0][1] == x && [0][2] == x ||
      board[1][0] == x && board[1][1] == x && [1][2] == x ||
      board[2][0] == x && board[2][1] == x && [2][2] == x ||
      board[0][0] == x && board[1][0] == x && [2][0] == x ||
      board[0][1] == x && board[1][1] == x && [2][1] == x ||
      board[0][2] == x && board[1][2] == x && [2][2] == x ||
      board[0][0] == x && board[1][1] == x && [2][2] == x ||
      board[0][2] == x && board[1][1] == x && [2][0] == x)
      puts 'X wins!'
    elsif (board[0][0] == o && board[0][1] == o && [0][2] == o ||
      board[1][0] == o && board[1][1] == o && [1][2] == o ||
      board[2][0] == o && board[2][1] == o && [2][2] == o ||
      board[0][0] == o && board[1][0] == o && [2][0] == o ||
      board[0][1] == o && board[1][1] == o && [2][1] == o ||
      board[0][2] == o && board[1][2] == o && [2][2] == o ||
      board[0][0] == o && board[1][1] == o && [2][2] == o ||
      board[0][2] == o && board[1][1] == o && [2][0] == o)
      puts 'O wins!'
    end
  end
end

class Player

end

class Computer

end

Game.start_game()
