# frozen_string_literal: true

# Game class
class Game
  attr_accessor :mode, :player_marker, :second_marker

  require_relative 'markers'

  include Markers

  def initialize(mode = nil)
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
    return input if input.to_s.match(/[1-9]/) && input.to_s.size == 1

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

  def display_board; end

  def select_move; end

  def verify_move(input); end

  def game_over?; end

  def end_game; end

  def display_result; end

  def prompt_new_game; end

  def verify_new_game_input(input); end
end
