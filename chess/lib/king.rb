# frozen_string_literal: true

# lib/king.rb
class King
  attr_accessor :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(coordinates, position, color)
    self.position = position
    self.color = color
    self.adjacency_list = build_adjacency_list(coordinates)
    self.children = adjacency_list[coordinates.find_index(position)]
  end

  def possible_moves(square, coordinates)
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
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def build_adjacency_list(coordinates)
    adjacency_list = {}
    coordinates.each_with_index do |square, index|
      adjacency_list[index] = possible_moves(square, coordinates)
    end
    adjacency_list
  end

  def to_s
    color == 'white' ? white + '♚' : black + '♚'
  end
end
