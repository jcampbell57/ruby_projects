# frozen_string_literal: true

# lib/knight.rb
class Knight
  attr_accessor :symbol, :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(coordinates, position, color)
    # self.symbol = '♞'
    self.position = position
    self.color = color
    self.adjacency_list = build_adjacency_list(coordinates)
    # self.parent = parent
    self.children = adjacency_list[coordinates.find_index(position)]
  end

  def possible_moves(square, coordinates)
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
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def build_adjacency_list(coordinates)
    adjacency_list = {}
    coordinates.each_with_index do |square, index|
      # adjacency_list[index] = [] # do I need this?
      adjacency_list[index] = possible_moves(square, coordinates)
    end
    adjacency_list
  end

  def to_s
    color == 'white' ? white + '♞' : black + '♞'
  end

  # def knight_moves(start_position, end_position, board = Board.new)
  #   queue = []
  #   current_node = Knight.new(start_position, nil, board)
  #   until current_node.position == end_position
  #     current_node.children.each { |move| queue << Knight.new(move, current_node, board) }
  #     break if queue.empty?

  #     current_node = queue.shift
  #   end
  #   shortest_path = []
  #   until current_node.nil?
  #     shortest_path.unshift(current_node.position)
  #     current_node = current_node.parent
  #   end
  #   puts "The shortest path from #{start_position} to #{end_position} is #{shortest_path.size - 1} moves: "
  #   shortest_path.each { |move| puts "#{move}" }
  # end
end
