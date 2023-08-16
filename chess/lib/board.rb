# frozen_string_literal: true

# lib/board.rb
class Board
  attr_accessor :columns

  require_relative 'colors'

  def initialize(columns = create_board)
    self.columns = columns
    set_pieces
  end

  def display_white
    8.times do |i|
      row = []
      columns.each do |column|
        row << column[1][7 - i]
      end
      puts row.join(' ').prepend("  #{8 - i} ")
    end
    puts '    a b c d e f g h'
  end

  def display_black
    8.times do |i|
      row = []
      columns.each do |column|
        row << column[1][i]
      end
      puts row.join(' ').prepend("  #{1 + i} ")
    end
    puts '    h g f e d c b a'
  end

  def create_board
    column_letters = (:a..:h).to_a
    columns_hash = {}
    column_letters.each do |letter|
      columns_hash[letter] = Array.new(8, ' ')
    end
    columns_hash
  end

  def set_pieces
    # pawns
    @columns.each do |column|
      column[1][1] = '♙'
      column[1][6] = '♟'
    end

    # rooks
    @columns[:a][0] = '♖'
    @columns[:a][7] = '♜'
    @columns[:h][0] = '♖'
    @columns[:h][7] = '♜'

    # knights
    @columns[:b][0] = '♘'
    @columns[:b][7] = '♞'
    @columns[:g][0] = '♘'
    @columns[:g][7] = '♞'

    # bishops
    @columns[:c][0] = '♗'
    @columns[:c][7] = '♝'
    @columns[:f][0] = '♗'
    @columns[:f][7] = '♝'

    # queens
    @columns[:d][0] = '♕'
    @columns[:d][7] = '♛'

    # kings
    @columns[:e][0] = '♔'
    @columns[:e][7] = '♚'
  end

  @visual_columns = {
    a: ['♖', '♙', ' ', ' ', ' ', ' ', '♟︎', '♜'],
    b: ['♘', '♙', ' ', ' ', ' ', ' ', '♟︎', '♞'],
    c: ['♗', '♙', ' ', ' ', ' ', ' ', '♟︎', '♝'],
    d: ['♕', '♙', ' ', ' ', ' ', ' ', '♟︎', '♛'],
    e: ['♔', '♙', ' ', ' ', ' ', ' ', '♟︎', '♚'],
    f: ['♗', '♙', ' ', ' ', ' ', ' ', '♟︎', '♝'],
    g: ['♘', '♙', ' ', ' ', ' ', ' ', '♟︎', '♞'],
    h: ['♖', '♙', ' ', ' ', ' ', ' ', '♟︎', '♜']
  }
end
