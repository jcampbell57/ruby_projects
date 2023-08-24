# frozen_string_literal: true

require_relative 'piece'

# lib/king.rb
class King < Piece
  attr_accessor :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(board, position, color)
    super(position, color)
    self.adjacency_list = build_adjacency_list(board)
    self.children = adjacency_list[board.coordinates.find_index(position)]
  end

  def possible_moves(square, board)
    possibilities = [
      [square[0] + 1, square[1] + 1],
      [square[0] - 1, square[1] + 1],
      [square[0] + 1, square[1] - 1],
      [square[0] - 1, square[1] - 1],
      [square[0] + 1, square[1]],
      [square[0] - 1, square[1]],
      [square[0], square[1] + 1],
      [square[0], square[1] - 1]
    ]
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
    color == 'white' ? white + '♚' : black + '♚'
  end
end
