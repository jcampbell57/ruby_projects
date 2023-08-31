# frozen_string_literal: true

require_relative 'piece'

# lib/pawn.rb
class Pawn < Piece
  attr_accessor :position, :color, :adjacency_list, :children

  require_relative 'colors'

  def initialize(game, position, color)
    super(position, color)
    self.adjacency_list = build_adjacency_list(game.board)
    self.children = update_children(game)
  end

  def possible_moves(square, board)
    possibilities = []
    if color == 'white'
      possibilities << [square[0], square[1] - 1]
      possibilities << [square[0], square[1] - 2] if square[1] == 6
      possibilities << [square[0] + 1, square[1] - 1]
      possibilities << [square[0] - 1, square[1] - 1]
    elsif color == 'black'
      possibilities << [square[0], square[1] + 1]
      possibilities << [square[0], square[1] + 2] if square[1] == 1
      possibilities << [square[0] + 1, square[1] + 1]
      possibilities << [square[0] - 1, square[1] + 1]
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

  def update_children(game)
    return nil if position.nil? || position[1].zero? || position[1] == 7

    moves = []

    adjacency_list[game.board.coordinates.find_index(position)].each do |child|
      target_square = game.board.squares[game.board.coordinates.find_index(child)]
      is_same_color = target_square != ' ' && target_square.color == color
      is_empty_and_diagonal = target_square == ' ' && child[0] != position[0]

      # Only append if not same color or not empty diagonal.
      moves << child unless is_same_color || is_empty_and_diagonal
    end

    # do not include 1 or 2 square move if blocked
    if color == 'white'
      move_one_square = game.board.coordinates.find_index([position[0], position[1] - 1])
      move_two_squares = game.board.coordinates.find_index([position[0], position[1] - 2])
      if move_one_square.nil? || game.board.squares[move_one_square] != ' '
        moves.delete([position[0], position[1] - 1])
        moves.delete([position[0], position[1] - 2])
      elsif move_two_squares.nil? || game.board.squares[move_two_squares] != ' '
        moves.delete([position[0], position[1] - 2])
      end
    elsif color == 'black'
      move_one_square = game.board.coordinates.find_index([position[0], position[1] + 1])
      move_two_squares = game.board.coordinates.find_index([position[0], position[1] + 2])
      if move_one_square.nil? || game.board.squares[move_one_square] != ' '
        moves.delete([position[0], position[1] + 1])
        moves.delete([position[0], position[1] + 2])
      elsif move_two_squares.nil? || game.board.squares[move_two_squares] != ' '
        moves.delete([position[0], position[1] + 2])
      end
    end
    moves
  end

  def to_s
    color == 'white' ? white + '♟' : black + '♟'
  end
end
