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
      # adjacency_list[index] = [] # do I need this?
      adjacency_list[index] = possible_moves(square, board)
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
