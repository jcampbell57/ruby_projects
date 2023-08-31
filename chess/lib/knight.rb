# frozen_string_literal: true

require_relative 'piece'

# lib/knight.rb
class Knight < Piece
  attr_accessor :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(game, position, color)
    super(position, color)
    self.adjacency_list = build_adjacency_list(game.board)
    self.children = update_children(game)
  end

  def possible_moves(square, board)
    possibilities = [[square[0] + 2, square[1] + 1],
                     [square[0] + 2, square[1] - 1],
                     [square[0] - 2, square[1] + 1],
                     [square[0] - 2, square[1] - 1],
                     [square[0] + 1, square[1] + 2],
                     [square[0] + 1, square[1] - 2],
                     [square[0] - 1, square[1] + 2],
                     [square[0] - 1, square[1] - 2]]
    confirmed = []
    possibilities.each do |possibility|
      board.coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def build_adjacency_list(board)
    adjacency_list = {}
    board.coordinates.each_with_index do |square, index|
      adjacency_list[index] = possible_moves(square, board)
    end
    adjacency_list
  end

  def to_s
    color == 'white' ? white + '♞' : black + '♞'
  end
end
