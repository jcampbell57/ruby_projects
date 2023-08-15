# frozen_string_literal: true

# Game class
class Game
  attr_accessor :board, :mode, :winner

  require_relative 'markers'

  include Markers

  def initialize(board = create_board, mode = nil)
    self.board = board
    self.mode = mode
    self.winner = nil
  end

  def play
    self.mode = select_mode
    game_loop
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

  def game_loop
    until game_over? == true
      display_board
      select_move
    end
    end_game
  end

  def create_board
    Array.new(6, Array.new(7, empty_marker))
  end

  def display_board
    @board.reverse.each do |row|
      puts row.split(' ')
    end
    puts '1 2 3 4 5 6 7'
  end

  def select_move
    print 'Input the culumn you would like to drop your marker 1-7: '
    verify_move(gets.chomp.to_i)
  end

  def verify_move(input)
    return input if input.between?(1, 7)

    puts 'Invalid input!'
    select_move
  end

  def game_over?
    return true if vertical_win? || horizontal_win? || diagonal_win?

    false
  end

  def vertical_win?
    @board.each_with_index do |row, row_index|
      row.each_with_index do |mark, column_index|
        if mark == player_marker &&
           @board[row_index + 1][column_index] == player_marker &&
           @board[row_index + 2][column_index] == player_marker &&
           @board[row_index + 3][column_index] == player_marker
          @winner = player_marker
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index] == second_marker &&
              @board[row_index + 2][column_index] == second_marker &&
              @board[row_index + 3][column_index] == second_marker
          @winner = second_marker
          return true
        end
      end
    end
    false
  end

  def horizontal_win?
    @board.each do |row|
      row.each_with_index do |mark, column_index|
        if mark == player_marker &&
           row[column_index + 1] == player_marker &&
           row[column_index + 2] == player_marker &&
           row[column_index + 3] == player_marker
          @winner = player_marker
          return true
        elsif mark == second_marker &&
              row[column_index + 1] == second_marker &&
              row[column_index + 2] == second_marker &&
              row[column_index + 3] == second_marker
          @winner = second_marker
          return true
        end
      end
    end
    false
  end

  def diagonal_win?
    @board.each_with_index do |row, row_index|
      row.each_with_index do |mark, column_index|
        if mark == player_marker &&
           @board[row_index + 1][column_index + 1] == player_marker &&
           @board[row_index + 2][column_index + 2] == player_marker &&
           @board[row_index + 3][column_index + 3] == player_marker
          @winner = player_marker
          return true
        elsif mark == player_marker &&
              @board[row_index + 1][column_index - 1] == player_marker &&
              @board[row_index + 2][column_index - 2] == player_marker &&
              @board[row_index + 3][column_index - 3] == player_marker
          @winner = player_marker
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index + 1] == second_marker &&
              @board[row_index + 2][column_index + 2] == second_marker &&
              @board[row_index + 3][column_index + 3] == second_marker
          @winner = second_marker
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index - 1] == second_marker &&
              @board[row_index + 2][column_index - 2] == second_marker &&
              @board[row_index + 3][column_index - 3] == second_marker
          @winner = second_marker
          return true
        end
      end
    end
    false
  end

  def end_game
    display_result
    prompt_new_game
  end

  def display_result
    display_board
    if @winner == player_marker && @mode == 1
      puts 'You win!'
    elsif @winner == second_marker && @mode == 1
      puts 'Better luck next time!'
    elsif @winner == player_marker && @mode == 2
      puts 'Player one wins!'
    elsif @winner == second_marker && @mode == 2
      puts 'Player two wins!'
    end
  end

  def prompt_new_game
    print 'Would you like to play again? y/n: '
    input = verify_new_game_input(gets.chomp.downcase)
    return unless input == 'y'

    @board = create_board
    @winner = nil
    play
  end

  def verify_new_game_input(input)
    return input if input.to_s.match(/[ny]/) && input.to_s.size == 1

    puts 'Invalid input!'
    prompt_new_game
  end
end
