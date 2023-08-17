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
      columns.each_with_index do |(_column_letter, column), column_index|
        background_color = if (i + column_index).even?
                             medium_brown_checker
                           else
                             brown_checker
                           end
        cell_content = background_color + "   \e[30m#{column[7 - i]}   " + "\e[0m"
        row << cell_content
      end
      insert_padding(i)
      puts row.join('').prepend("  #{8 - i} ")
      insert_padding(i)
    end
    puts '       a      b      c      d      e      f      g      h'
  end

  def display_black
    8.times do |i|
      row = []
      reversed_columns = Hash[columns.to_a.reverse]
      reversed_columns.each_with_index do |(_column_letter, column), column_index|
        background_color = if (i + column_index).even?
                             medium_brown_checker
                           else
                             brown_checker
                           end
        cell_content = background_color + "   \e[30m#{column[i]}   " + "\e[0m"
        row << cell_content
      end
      insert_padding(i)
      puts row.join('').prepend("  #{1 + i} ")
      insert_padding(i)
    end
    puts '       h      g      f      e      d      c      b      a'
  end

  def insert_padding(index)
    if index.even?
      puts padding_variant_one.prepend('    ')
    else
      puts padding_variant_two.prepend('    ')
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
      column[1][1] = "\e[97m♟"
      column[1][6] = "\e[30m♟"
    end

    # rooks
    @columns[:a][0] = "\e[97m♜"
    @columns[:a][7] = "\e[30m♜"
    @columns[:h][0] = "\e[97m♜"
    @columns[:h][7] = "\e[30m♜"

    # knights
    @columns[:b][0] = "\e[97m♞"
    @columns[:b][7] = "\e[30m♞"
    @columns[:g][0] = "\e[97m♞"
    @columns[:g][7] = "\e[30m♞"

    # bishops
    @columns[:c][0] = "\e[97m♝"
    @columns[:c][7] = "\e[30m♝"
    @columns[:f][0] = "\e[97m♝"
    @columns[:f][7] = "\e[30m♝"

    # queens
    @columns[:d][0] = "\e[97m♛"
    @columns[:d][7] = "\e[30m♛"

    # kings
    @columns[:e][0] = "\e[97m♚"
    @columns[:e][7] = "\e[30m♚"
  end

  def old_set_pieces
    # pawns
    @columns.each do |column|
      column[1][1] = "\e[97m♟"
      column[1][6] = "\e[30m♜♟"
    end

    # rooks
    @columns[:a][0] = "\e[97m♖"
    @columns[:a][7] = "\e[30m♜"
    @columns[:h][0] = "\e[97m♖"
    @columns[:h][7] = "\e[30m♜"

    # knights
    @columns[:b][0] = "\e[97m♘"
    @columns[:b][7] = "\e[30m♞"
    @columns[:g][0] = "\e[97m♘"
    @columns[:g][7] = "\e[30m♞"

    # bishops
    @columns[:c][0] = "\e[97m♗"
    @columns[:c][7] = "\e[30m♝"
    @columns[:f][0] = "\e[97m♗"
    @columns[:f][7] = "\e[30m♝"

    # queens
    @columns[:d][0] = "\e[97m♕"
    @columns[:d][7] = "\e[30m♛"

    # kings
    @columns[:e][0] = "\e[97m♔"
    @columns[:e][7] = "\e[30m♚"
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
