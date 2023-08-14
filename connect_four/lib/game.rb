# frozen_string_literal: true

# Game class
class Game
  attr_accessor :board, :mode, :player_marker, :second_marker

  require_relative 'markers'

  include Markers

  def initialize(board = create_board, mode = nil)
    self.board = board
    self.mode = mode
    self.player_marker = green_circle
    self.second_marker = pink_circle
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
    Array.new(7, Array.new(6, empty_circle))
  end

  def display_board
    6.times do |i|
      puts display_row(5 - i)
    end
    puts '1 2 3 4 5 6 7'
  end

  def display_row(row_index)
    current_row = []
    @board.each do |column|
      current_row << column[row_index]
    end
    current_row
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

  def game_over?; end

  def end_game; end

  def display_result; end

  def prompt_new_game; end

  def verify_new_game_input(input); end
end
