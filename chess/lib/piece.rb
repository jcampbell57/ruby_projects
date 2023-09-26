# frozen_string_literal: true

# lib/piece.rb
class Piece
  attr_accessor :position, :previous_moves, :color

  # require_relative 'colors'

  def initialize(position, color)
    self.position = position
    self.previous_moves = []
    self.color = color
  end

  def update_children(game)
    return nil if position.nil?

    children = []
    adjacency_list[game.board.coordinates.find_index(position)].each do |child|
      # do not include squares with same color pieces
      target_square = game.board.squares[game.board.coordinates.find_index(child)]
      children << child unless target_square != ' ' && target_square.color == color
    end
    children
  end
end
