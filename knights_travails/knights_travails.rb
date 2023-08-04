# frozen_string_literal: true

# knight class
class Knight
  attr_accessor :board, :adjacency_list

  def initialize
    self.board = build_board
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
      @board.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def build_adjacency_list
    adjacency_list = {}
    @board.each_with_index do |square, index|
      adjacency_list[index] = []
      adjacency_list[index] = possible_moves(square)
    end
    adjacency_list
  end

  def find_shortest(solutions_array)
    solution_counts = []
    solutions_array.each do |solution|
      solution_counts << solution.size
    end
    shortest = solution_counts.min
    shortest_index = solution_counts.find_index(shortest)
    solutions_array[shortest_index]
  end

  def find_path(start_position, end_position, path_array = [])
    path_array << start_position
    position_index = @board.find_index(start_position)
    possible_moves = @adjacency_list[position_index].difference(path_array)

    return nil if possible_moves.empty?
    return path_array << end_position if possible_moves.include?(end_position)

    # this is the problem:
    solutions_array = []
    possible_moves.each do |move|
      next_move = find_path(move, end_position, path_array)
      solutions_array << next_move unless next_move.nil?
    end
    return nil if solutions_array.empty? || solutions_array[-1].nil?

    find_shortest(solutions_array)
  end

  def knight_moves(start_position, end_position)
    shortest_path = find_path(start_position, end_position)
    puts "The shortest path is #{shortest_path.size - 1} moves: "
    shortest_path.each { |move| p move }
  end
end

test = Knight.new

test.knight_moves([0, 0], [1, 2])
test.knight_moves([0, 0], [3, 3])
test.knight_moves([3, 3], [0, 0])
test.knight_moves([3, 3], [4, 3])
