# frozen_string_literal: true

# lib/main.rb
require_relative 'game'
game = Game.new

# new game:
# game.new_game

# move piece:
piece = game.board.squares[game.board.coordinates.find_index([1, 7])]
game.display_board
game.place_piece(piece, 2, 5)
game.display_board

# eliminate piece:
# piece1 = game.board.squares[game.board.coordinates.find_index([1, 7])]
# piece2 = game.board.squares[game.board.coordinates.find_index([3, 7])]
# piece3 = game.board.squares[game.board.coordinates.find_index([7, 6])]
# game.display_board
# game.eliminate_piece(piece1)
# game.eliminate_piece(piece2)
# game.eliminate_piece(piece3)
# game.display_board

# display board:
# puts "board from white's perspective: "
# game.turn = 'white'
# game.display_board
# puts
# puts "board from black's perspective: "
# game.turn = 'black'
# game.player = 'black'
# game.display_board
