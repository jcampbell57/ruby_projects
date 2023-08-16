# frozen_string_literal: true

# lib/board.rb
class Board
  require_relative 'colors'

  def initialize(squares = Array.new(8) { Array.new(8, nil) })
    self.squares = squares
  end

  def display_white
    @board.each_with_index do |row, row_index|
      puts row.join(' ').prepend(" #{8 - row_index}")
    end
    puts '    a b c d e f g h'
  end

  def display_black
    @board.each_with_index do |row, row_index|
      puts row.join(' ').prepend(" #{1 + row_index}")
    end
    puts '    h g f e d c b a'
  end

  @squares = [
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  ]
end
