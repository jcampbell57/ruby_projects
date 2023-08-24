# frozen_string_literal: true

require_relative 'piece'

# lib/rook.rb
class Rook < Piece
  attr_accessor :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(board, position, color)
    super(position, color)
    self.adjacency_list = build_adjacency_list(board)
    self.children = adjacency_list[board.coordinates.find_index(position)]
  end

  def possible_moves(square, board)
    possibilities = []
    8.times do |i|
      possibilities << [square[0] + i, square[1]]
      possibilities << [square[0] - i, square[1]]
      possibilities << [square[0], square[1] + i]
      possibilities << [square[0], square[1] - i]
    end
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

  def update_children(board)
    return nil if position.nil?

    children = []
    adjacency_list[board.coordinates.find_index(position)].each do |child|
      # add all possible squares except squares with same color pieces
      target_square = board.squares[board.coordinates.find_index(child)]
      children << child unless target_square != ' ' && target_square.color == color
    end

    # remove squares past obstacle
    obstacle = []
    4.times { |i| obstacle[i] = false }

    8.times do |i|
      [[position[0] + i, position[1]],
       [position[0] - i, position[1]],
       [position[0], position[1] + i],
       [position[0], position[1] - i]].each_with_index do |square, j|
        next if square == position

        # remove from children if blocked
        children.delete(square) if obstacle[j] == true
        # block if off of the board
        obstacle[j] = true && next if board.coordinates.include?(square) == false
        # block if square is not blank
        obstacle[j] = true if board.squares[board.coordinates.find_index(square)] != ' '
      end
    end

    children
  end

  def to_s
    color == 'white' ? white + '♜' : black + '♜'
  end
end
