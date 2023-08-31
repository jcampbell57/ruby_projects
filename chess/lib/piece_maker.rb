# frozen_string_literal: true

# lib/piece_maker.rb
module PieceMaker
  require_relative 'bishop'
  require_relative 'king'
  require_relative 'knight'
  require_relative 'pawn'
  require_relative 'queen'
  require_relative 'rook'

  def create_pawns(pieces_array)
    8.times do |i|
      pieces_array << Pawn.new(self, [i, 6], 'white') # "\e[97m♟"
      pieces_array << Pawn.new(self, [i, 1], 'black') # "\e[30m♟"
    end
  end

  def create_rooks(pieces_array)
    pieces_array << Rook.new(self, [0, 7], 'white') # "\e[97m♜"
    pieces_array << Rook.new(self, [7, 7], 'white') # "\e[97m♜"
    pieces_array << Rook.new(self, [0, 0], 'black') # "\e[30m♜"
    pieces_array << Rook.new(self, [7, 0], 'black') # "\e[30m♜"
  end

  def create_knights(pieces_array)
    pieces_array << Knight.new(self, [1, 7], 'white') # "\e[97m♞"
    pieces_array << Knight.new(self, [6, 7], 'white') # "\e[97m♞"
    pieces_array << Knight.new(self, [1, 0], 'black') # "\e[30m♞"
    pieces_array << Knight.new(self, [6, 0], 'black') # "\e[30m♞"
  end

  def create_bishops(pieces_array)
    pieces_array << Bishop.new(self, [2, 7], 'white') # "\e[97m♝"
    pieces_array << Bishop.new(self, [5, 7], 'white') # "\e[97m♝"
    pieces_array << Bishop.new(self, [2, 0], 'black') # "\e[30m♝"
    pieces_array << Bishop.new(self, [5, 0], 'black') # "\e[30m♝"
  end

  def create_queens(pieces_array)
    pieces_array << Queen.new(self, [3, 7], 'white') # "\e[97m♛"
    pieces_array << Queen.new(self, [3, 0], 'black') # "\e[30m♛"
  end

  def create_kings(pieces_array)
    pieces_array << King.new(self, [4, 7], 'white') # "\e[97m♚"
    pieces_array << King.new(self, [4, 0], 'black') # "\e[30m♚"
  end
end
