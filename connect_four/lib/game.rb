# frozen_string_literal: true

# Game class
class Game
  attr_accessor :board, :mode, :marker

  require_relative 'markers'

  include Markers

  def initialize(board = create_board, mode = nil)
    self.board = board
    self.mode = mode
    self.marker = player_marker
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
    Array.new(6) { Array.new(7, empty_marker.dup) }
  end

  def display_board
    @board.reverse.each do |row|
      puts row.join(' ').prepend('  ')
    end
    puts '  1 2 3 4 5 6 7'
  end

  def select_move
    if @mode == 1
      input = nil
      if @marker == player_marker
        puts 'Your turn!'
        print 'Input the culumn you would like to drop your marker 1-7: '
        input = gets.chomp.to_i
      else
        puts "Computer's turn!"
        print 'The computer chooses: '
        sleep(1)
        input = rand(1..7)
      end
      place_marker(verify_move(input - 1))
      switch_marker unless game_over?
      input
    elsif @mode == 2
      if @marker == player_marker
        puts "Player one's turn!"
      else
        puts "Player two's turn!"
      end

      print 'Input the culumn you would like to drop your marker 1-7: '
      input = gets.chomp.to_i
      place_marker(verify_move(input) - 1)
      switch_marker unless game_over?
      input
    end
  end

  def verify_move(input)
    return input if input.between?(0, 6)

    puts 'Invalid input!'
    select_move
  end

  def place_marker(column_index)
    @board.each do |row|
      if row[column_index] == empty_marker
        row[column_index] = @marker
        break
      end
    end
  end

  def switch_marker
    @marker = @marker == player_marker ? second_marker : player_marker
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
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index] == second_marker &&
              @board[row_index + 2][column_index] == second_marker &&
              @board[row_index + 3][column_index] == second_marker
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
          return true
        elsif mark == second_marker &&
              row[column_index + 1] == second_marker &&
              row[column_index + 2] == second_marker &&
              row[column_index + 3] == second_marker
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
          return true
        elsif mark == player_marker &&
              @board[row_index + 1][column_index - 1] == player_marker &&
              @board[row_index + 2][column_index - 2] == player_marker &&
              @board[row_index + 3][column_index - 3] == player_marker
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index + 1] == second_marker &&
              @board[row_index + 2][column_index + 2] == second_marker &&
              @board[row_index + 3][column_index + 3] == second_marker
          return true
        elsif mark == second_marker &&
              @board[row_index + 1][column_index - 1] == second_marker &&
              @board[row_index + 2][column_index - 2] == second_marker &&
              @board[row_index + 3][column_index - 3] == second_marker
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
    if @marker == player_marker && @mode == 1
      puts 'You win!'
    elsif @marker == second_marker && @mode == 1
      puts 'Better luck next time!'
    elsif @marker == player_marker && @mode == 2
      puts 'Player one wins!'
    elsif @marker == second_marker && @mode == 2
      puts 'Player two wins!'
    end
  end

  def prompt_new_game
    print 'Would you like to play again? y/n: '
    input = verify_new_game_input(gets.chomp.downcase)
    return unless input == 'y'

    @board = create_board
    @marker = player_marker
    play
  end

  def verify_new_game_input(input)
    return input if input.to_s.match(/[ny]/) && input.to_s.size == 1

    puts 'Invalid input!'
    prompt_new_game
  end
end
