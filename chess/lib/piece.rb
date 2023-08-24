# frozen_string_literal: true

# lib/piece.rb
class Piece
  attr_accessor :position, :color

  # require_relative 'colors'

  def initialize(position, color)
    self.position = position
    self.color = color
  end

  def update_children(board)
    return nil if position.nil?

    children = []
    adjacency_list[board.coordinates.find_index(position)].each do |child|
      # do not include squares with same color pieces
      target_square = board.squares[board.coordinates.find_index(child)]
      children << child unless target_square != ' ' && target_square.color == color
    end
    children
  end
end

# module Piece
#   # ♔ white king
#   def white_king
#     "\u2654"
#   end

#   # ♕ white queen
#   def white_queen
#     "\u2655"
#   end

#   # ♖ white rook
#   def white_rook
#     "\u2656"
#   end

#   # ♗ white bishop
#   def white_bishop
#     "\u2657"
#   end

#   # ♘ white knight
#   def white_knight
#     "\u2658"
#   end

#   # ♙ white pawn
#   def white_pawn
#     "\u2659"
#   end

#   # ♚ black king
#   def black_king
#     "\u265A"
#   end

#   # ♛ black queen
#   def black_queen
#     "\u265B"
#   end

#   # ♜ black rook
#   def black_rook
#     "\u265C"
#   end

#   # ♝ black bishop
#   def black_bishop
#     "\u265D"
#   end

#   # ♞ black knight
#   def black_knight
#     "\u265E"
#   end

#   # ♟︎ black pawn
#   def black_pawn
#     "\u265F"
#   end
# end
