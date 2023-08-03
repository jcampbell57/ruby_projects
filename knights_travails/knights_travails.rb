# frozen_string_literal: true

# knight class
class Knight
  attr_accessor :board

  def initialize
    self.board = build_board
  end

  def build_board
    board = []
    8.times do |i|
      8.times do |j|
        board.push([i + 1, j + 1])
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
      p possibility
      p @board.include?(possibility)
      @board.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end

  def adjacency_list
    adjacency_list = {}
    @board.each_with_index do |square, index|
      adjacency_list[index] = []
      adjacency_list[index] = possible_moves(square)
    end
    adjacency_list
  end

  def knight_moves(start_position, _end_position)
    # create graph
    queue = [start_position]
    count = 0
    square = queue.pop until queue.empty?
  end
end

test = Knight.new
p test.build_board
p test.adjacency_list
