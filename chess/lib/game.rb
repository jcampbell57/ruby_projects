# frozen_string_literal: true

# lib/game.rb
class Game
  attr_accessor :board, :mode, :player, :turn

  require_relative 'board'
  require_relative 'markers'
  include Barkers
  include Markers

  def initialize(board = Board.new, mode = nil, player = nil, turn = 'white')
    self.board = board
    self.mode = mode
    self.player = player
    self.turn = turn
  end

  def play
    @mode = select_mode
    @player = select_color if @mode == 1
    turn_loop
  end

  def select_mode
    print 'Input 1 for single player or 2 for multiplayer: '
    verify_mode(gets.chomp.to_i)
  end

  def verify_mode(input)
    return input if input.to_s.match(/[1-2]/) && input.to_s.size == 1

    # else
    puts 'Invalid input!'
    select_mode
  end

  def select_color
    print 'Input 1 to play as white or 2 to play as black: '
    verify_color(gets.chomp.downcase)
  end

  def verify_color(input)
    return input if input.to_s.match(/[wb]/) && input.to_s.size == 1

    # else
    puts 'Invalid input!'
    select_color
  end

  def turn_loop
    until checkmate? == true
      display_board
      select_move
      switch_turn unless checkmate?
    end
    end_game
  end

  def select_move
    if @mode == 1
      input = nil
      if @marker == player_marker
        puts 'Your turn!'
        print 'Input: '
        input = gets.chomp.to_i
      else
        puts "Computer's turn!"
        print 'The computer chooses: '
        sleep(1)
        input = nil
      end
      place_piece(verify_move(input))
    elsif @mode == 2
      if @marker == player_marker
        puts "White's turn!"
      else
        puts "Black's turn!"
      end
      print 'Input: '
      input = gets.chomp.to_i
      place_piece(verify_move(input))
    end
    input
  end

  def verify_move(_input)
    # return input if valid?

    puts 'Invalid input!'
    select_move
  end

  def place_piece(piece, new_column_index, new_row_index)
    # @board[piece.column][piece.row] = nil
    # @board[new_column_index][new_row_index] = piece
  end

  def switch_turn
    @turn = @turn == 'white' ? 'black' : 'white'
  end

  def checkmate?
    true if winner?('white') || winner?('black')

    false
  end

  def winner?(_color)
    # return true if color won
    false
  end

  def end_game
    display_result
    prompt_new_game
  end

  def display_result
    display_board
    if @turn == 'white' && @mode == 1
      puts 'You win!'
    elsif @turn == 'black' && @mode == 1
      puts 'Better luck next time!'
    elsif @turn == 'white' && @mode == 2
      puts 'White wins!'
    elsif @turn == 'black' && @mode == 2
      puts 'Black wins!'
    end
  end

  def prompt_new_game
    print 'Would you like to play again? y/n: '
    input = verify_new_game_input(gets.chomp.downcase)
    return unless input == 'y'

    @board = Board.new
    @turn = 'white'
    play
  end

  def verify_new_game_input(input)
    return input if input.to_s.match(/[ny]/) && input.to_s.size == 1

    puts 'Invalid input!'
    prompt_new_game
  end
end
