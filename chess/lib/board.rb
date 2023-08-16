# frozen_string_literal: true

# lib/board.rb
class Board
  attr_accessor :columns

  require_relative 'colors'

  def initialize(columns = create_board)
    self.columns = columns
  end

  def display_white
    8.times do |i|
      row = []
      columns.each do |column|
        row << column[8 - i]
      end
      puts row.join(' ').prepend(" #{8 - i}")
    end
    puts '    a b c d e f g h'
  end

  def display_black
    8.times do |i|
      row = []
      columns.each do |column|
        row << column[1 + i]
      end
      puts row.join(' ').prepend(" #{1 + i}")
    end
    puts '    h g f e d c b a'
  end

  def create_board
    column_letters = ('a'..'h').to_a
    columns_hash = {}
    column_letters.each do |letter|
      columns_hash[letter] = Array.new(8, ' ')
    end
    columns_hash
  end

  @visual_columns = {
    a: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    b: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    c: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    d: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    e: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    f: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    g: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    h: [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  }
end
