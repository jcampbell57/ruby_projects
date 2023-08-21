# frozen_string_literal: true

# lib/board.rb
class Board
  attr_accessor :squares, :coordinates

  require_relative 'colors'
  require_relative 'bishop'
  require_relative 'king'
  require_relative 'knight'
  require_relative 'pawn'
  require_relative 'queen'
  require_relative 'rook'

  # @coordinates = create_coordinates

  def initialize(squares = nil)
    self.coordinates = create_coordinates
    self.squares = squares.nil? ? create_squares : sqauares
  end

  def display_white
    temp_squares = @squares.dup
    8.times do |i|
      row = []
      8.times do |j|
        background_color = if (i + j).even?
                             medium_brown_checker
                           else
                             brown_checker
                           end
        cell_content = background_color + "   \e[30m#{temp_squares.shift}   " + "\e[0m"
        row << cell_content
      end
      insert_padding(i)
      puts row.join('').prepend(" #{8 - i} ")
      insert_padding(i)
    end
    puts '       a      b      c      d      e      f      g      h'
  end

  def display_black
    # create rows
    rows = []
    temp_squares = @squares.dup
    8.times do
      rows << temp_squares.shift(8)
    end
    # print 8 rows
    rows.reverse.each_with_index do |row_array, i|
      row = []
      row_array.reverse.each_with_index do |square, j|
        background_color = if (i + j).even?
                             medium_brown_checker
                           else
                             brown_checker
                           end
        cell_content = background_color + "   \e[30m#{square}   " + "\e[0m"
        row << cell_content
      end
      insert_padding(i)
      puts row.join('').prepend(" #{1 + i} ")
      insert_padding(i)
    end
    puts '       h      g      f      e      d      c      b      a'
  end

  def insert_padding(index)
    if index.even?
      puts padding_variant_one.prepend('   ')
    else
      puts padding_variant_two.prepend('   ')
    end
  end

  def padding_variant_one
    padding = String.new
    4.times do
      padding << medium_brown_checker + '       ' + "\e[0m"
      padding << brown_checker + '       ' + "\e[0m"
    end
    padding
  end

  def padding_variant_two
    padding = String.new
    4.times do
      padding << brown_checker + '       ' + "\e[0m"
      padding << medium_brown_checker + '       ' + "\e[0m"
    end
    padding
  end

  def create_coordinates
    coordinates = []
    8.times do |i|
      8.times do |j|
        coordinates.push([j, i])
      end
    end
    coordinates
  end

  def create_squares
    squares = []
    8.times do
      8.times do
        squares.push(' ')
      end
    end
    reset_pieces(squares)
    squares
  end

  def reset_pieces(blank_board)
    # pawns
    8.times do |i|
      blank_board[@coordinates.find_index([i, 6])] = Pawn.new(@coordinates, [i, 6], 'white') # "\e[97m♟"
      blank_board[@coordinates.find_index([i, 1])] = Pawn.new(@coordinates, [i, 1], 'black') # "\e[30m♟"
    end

    # rooks
    blank_board[@coordinates.find_index([0, 7])] = Rook.new(@coordinates, [0, 7], 'white') # "\e[97m♜"
    blank_board[@coordinates.find_index([7, 7])] = Rook.new(@coordinates, [7, 7], 'white') # "\e[97m♜"
    blank_board[@coordinates.find_index([0, 0])] = Rook.new(@coordinates, [0, 0], 'black') # "\e[30m♜"
    blank_board[@coordinates.find_index([7, 0])] = Rook.new(@coordinates, [7, 0], 'black') # "\e[30m♜"

    # knights
    blank_board[@coordinates.find_index([1, 7])] = Knight.new(@coordinates, [1, 7], 'white') # "\e[97m♞"
    blank_board[@coordinates.find_index([6, 7])] = Knight.new(@coordinates, [6, 7], 'white') # "\e[97m♞"
    blank_board[@coordinates.find_index([1, 0])] = Knight.new(@coordinates, [1, 0], 'black') # "\e[30m♞"
    blank_board[@coordinates.find_index([6, 0])] = Knight.new(@coordinates, [6, 0], 'black') # "\e[30m♞"

    # bishops
    blank_board[@coordinates.find_index([2, 7])] = Bishop.new(@coordinates, [2, 7], 'white') # "\e[97m♝"
    blank_board[@coordinates.find_index([5, 7])] = Bishop.new(@coordinates, [5, 7], 'white') # "\e[97m♝"
    blank_board[@coordinates.find_index([2, 0])] = Bishop.new(@coordinates, [2, 0], 'black') # "\e[30m♝"
    blank_board[@coordinates.find_index([5, 0])] = Bishop.new(@coordinates, [5, 0], 'black') # "\e[30m♝"

    # queens
    blank_board[@coordinates.find_index([3, 7])] = Queen.new(@coordinates, [3, 7], 'white') # "\e[97m♛"
    blank_board[@coordinates.find_index([3, 0])] = Queen.new(@coordinates, [3, 0], 'black') # "\e[30m♛"

    # kings
    blank_board[@coordinates.find_index([4, 7])] = King.new(@coordinates, [4, 7], 'white') # "\e[97m♚"
    blank_board[@coordinates.find_index([4, 0])] = King.new(@coordinates, [4, 0], 'black') # "\e[30m♚"
  end

  @visual_squares = [
    [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
    [0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1],
    [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2],
    [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3],
    [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4],
    [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5],
    [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6],
    [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]
  ]
end
