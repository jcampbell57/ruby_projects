# frozen_string_literal: true

# lib/main.rb
require_relative 'game'
game = Game.new

# play game
game.play

# display board
# puts "board from white's perspective: "
# game.turn = 'white'
# game.display_board
# puts
# puts "board from black's perspective: "
# game.turn = 'black'
# game.display_board
