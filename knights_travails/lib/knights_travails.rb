# frozen_string_literal: true

# board class
class Board
  attr_accessor :sqauares, :adjacency_list

  def initialize
    self.sqauares = build_board
    self.adjacency_list = build_adjacency_list
  end

  def build_board
    board = []
    8.times do |i|
      8.times do |j|
        board.push([i, j])
      end
    end
    board
  end

  def possible_moves(square)
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
      @sqauares.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def build_adjacency_list
    adjacency_list = {}
    @sqauares.each_with_index do |square, index|
      adjacency_list[index] = []
      adjacency_list[index] = possible_moves(square)
    end
    adjacency_list
  end
end

# knight class
class Knight
  attr_accessor :position, :parent, :children

  @@history = []

  def initialize(position, parent, board = Board.new)
    # reset history when given new move
    @@history = [] if parent.nil?
    @@history.push(position)
    self.position = position
    self.parent = parent
    self.children = board.adjacency_list[board.sqauares.find_index(position)].difference(@@history)
  end
end

def knight_moves(start_position, end_position, board = Board.new)
  queue = []
  current_node = Knight.new(start_position, nil, board)
  until current_node.position == end_position
    current_node.children.each { |move| queue << Knight.new(move, current_node, board) }
    break if queue.empty?

    current_node = queue.shift
  end
  shortest_path = []
  until current_node.nil?
    shortest_path.unshift(current_node.position)
    current_node = current_node.parent
  end
  puts "The shortest path from #{start_position} to #{end_position} is #{shortest_path.size - 1} moves: "
  shortest_path.each { |move| puts "#{move}" }
end

knight_moves([0, 0], [1, 2])
knight_moves([0, 0], [3, 3])
knight_moves([3, 3], [0, 0])
knight_moves([3, 3], [4, 3])
