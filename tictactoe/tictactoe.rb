class Game
  def self.start_game
    p 'One player or two?'
    get_player_count
    initialize_players(@@player_count)
    play
  end

  @@player1 = 0
  @@player2 = 0
  @@computer = 0
  @@current_player = 0
  @@player_count = 0
  @@board = %w[1 2 3 4 5 6 7 8 9]
  @@computer_options = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  def self.play
    display_board
    select_move
  end

  def self.verify_selection(input)
    if @@board[input - 1] == 'X' || @@board[input - 1] == 'O'
      p 'That space has already been taken!'
      display_board
      select_move
    else
      @@board[input - 1] = @@current_player.marker
      @@computer_options.delete(input)
      check_for_winner
    end
  end

  def self.verify_input(input)
    if input.between?(1, 9)
      verify_selection(input)
    else
      p 'Please input a number 1 through 9.'
      select_move
    end
  end

  def self.select_move
    if @@current_player == @@computer
      p "Computer's turn:"
      sleep 2
      computer_selection = @@computer_options.sample
      @@board[computer_selection - 1] = @@current_player.marker
      @@computer_options.delete(computer_selection)
      check_for_winner
    else
      p "#{@@current_player.marker}'s turn. Select your move:"
      input = gets.chomp.to_i
      verify_input(input)
    end
  end

  def self.get_player_count
    player_count = gets.chomp.to_i
    if [1, 2].include?(player_count)
      @@player_count = player_count
      p "player count: #{@@player_count}"
    else
      p "Please input '1' or '2'"
      get_player_count
    end
  end

  def self.initialize_players(player_count)
    @@player1 = Player.new('X')
    @@current_player = @@player1
    if player_count == 2
      @@player2 = Player.new('O')
    else
      @@computer = Player.new('O')
    end
  end

  def self.display_board
    p @@board[0..2]
    p @@board[3..5]
    p @@board[6..8]
  end

  def self.change_player
    @@current_player = if @@player_count == 2
                         if @@current_player == @@player1
                           @@player2
                         else
                           @@player1
                         end
                       elsif @@current_player == @@player1
                         @@computer
                       else
                         @@player1
                       end
  end

  def self.check_for_winner
    if @@board[0] == 'X' && @@board[1] == 'X' && @@board[2] == 'X' ||
       @@board[3] == 'X' && @@board[4] == 'X' && @@board[5] == 'X' ||
       @@board[6] == 'X' && @@board[7] == 'X' && @@board[8] == 'X' ||
       @@board[0] == 'X' && @@board[3] == 'X' && @@board[6] == 'X' ||
       @@board[1] == 'X' && @@board[4] == 'X' && @@board[7] == 'X' ||
       @@board[2] == 'X' && @@board[5] == 'X' && @@board[8] == 'X' ||
       @@board[0] == 'X' && @@board[4] == 'X' && @@board[8] == 'X' ||
       @@board[2] == 'X' && @@board[4] == 'X' && @@board[6] == 'X'
      display_board
      puts 'X wins!'
    elsif @@board[0] == 'O' && @@board[1] == 'O' && @@board[2] == 'O' ||
          @@board[3] == 'O' && @@board[4] == 'O' && @@board[5] == 'O' ||
          @@board[6] == 'O' && @@board[7] == 'O' && @@board[8] == 'O' ||
          @@board[0] == 'O' && @@board[3] == 'O' && @@board[6] == 'O' ||
          @@board[1] == 'O' && @@board[4] == 'O' && @@board[7] == 'O' ||
          @@board[2] == 'O' && @@board[5] == 'O' && @@board[8] == 'O' ||
          @@board[0] == 'O' && @@board[4] == 'O' && @@board[8] == 'O' ||
          @@board[2] == 'O' && @@board[4] == 'O' && @@board[6] == 'O'
      display_board
      puts 'O wins!'
    else
      change_player
      display_board
      select_move
    end
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

Game.start_game
