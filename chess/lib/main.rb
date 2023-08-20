# frozen_string_literal: true

# lib/main.rb
require_relative 'game'
game = Game.new

# play game:
# game.play

# move piece:
# piece = game.board.squares[game.board.coordinates.find_index([1, 7])]
# game.display_board
# game.place_piece(piece, 2, 5)
# game.display_board

# eliminate piece:
piece = game.board.squares[game.board.coordinates.find_index([1, 7])]
game.display_board
game.eliminate_piece(piece)
game.display_board

# display board:
# puts "board from white's perspective: "
# game.turn = 'white'
# game.display_board
# puts
# puts "board from black's perspective: "
# game.turn = 'black'
# game.display_board
