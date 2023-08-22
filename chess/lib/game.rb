# frozen_string_literal: true

# lib/game.rb
class Game
  attr_accessor :board, :mode, :player, :turn, :pieces

  require_relative 'board'
  require_relative 'bishop'
  require_relative 'king'
  require_relative 'knight'
  require_relative 'pawn'
  require_relative 'queen'
  require_relative 'rook'

  require_relative 'piece'
  # include Piece

  def initialize(board = Board.new,
                 pieces = nil,
                 mode = nil,
                 player = 'white',
                 turn = 'white')
    self.board = board
    self.pieces = pieces.nil? ? create_pieces : pieces
    self.mode = mode
    self.player = player
    self.turn = turn
    @board.set(@pieces)
  end

  def new_game
    # @pieces = create_pieces
    @mode = select_mode
    @player = select_color if @mode == 1
    turn_loop
  end

  def create_pieces
    pieces_array = []

    # create pawns
    8.times do |i|
      pieces_array << Pawn.new(@board.coordinates, [i, 6], 'white') # "\e[97m♟"
      pieces_array << Pawn.new(@board.coordinates, [i, 1], 'black') # "\e[30m♟"
    end

    # create rooks
    pieces_array << Rook.new(@board.coordinates, [0, 7], 'white') # "\e[97m♜"
    pieces_array << Rook.new(@board.coordinates, [7, 7], 'white') # "\e[97m♜"
    pieces_array << Rook.new(@board.coordinates, [0, 0], 'black') # "\e[30m♜"
    pieces_array << Rook.new(@board.coordinates, [7, 0], 'black') # "\e[30m♜"

    # create knights
    pieces_array << Knight.new(@board.coordinates, [1, 7], 'white') # "\e[97m♞"
    pieces_array << Knight.new(@board.coordinates, [6, 7], 'white') # "\e[97m♞"
    pieces_array << Knight.new(@board.coordinates, [1, 0], 'black') # "\e[30m♞"
    pieces_array << Knight.new(@board.coordinates, [6, 0], 'black') # "\e[30m♞"

    # create bishops
    pieces_array << Bishop.new(@board.coordinates, [2, 7], 'white') # "\e[97m♝"
    pieces_array << Bishop.new(@board.coordinates, [5, 7], 'white') # "\e[97m♝"
    pieces_array << Bishop.new(@board.coordinates, [2, 0], 'black') # "\e[30m♝"
    pieces_array << Bishop.new(@board.coordinates, [5, 0], 'black') # "\e[30m♝"

    # create queens
    pieces_array << Queen.new(@board.coordinates, [3, 7], 'white') # "\e[97m♛"
    pieces_array << Queen.new(@board.coordinates, [3, 0], 'black') # "\e[30m♛"

    # create kings
    pieces_array << King.new(@board.coordinates, [4, 7], 'white') # "\e[97m♚"
    pieces_array << King.new(@board.coordinates, [4, 0], 'black') # "\e[30m♚"

    # return
    pieces_array
  end

  def select_mode
    print 'Input 1 for single player or 2 for multiplayer: '
    verify_mode(gets.chomp.to_i)
  end

  def verify_mode(input)
    return input if input.to_s.match(/[1-2]/) && input.to_s.size == 1

    # else
    puts 'Invalid input!'
    select_mode
  end

  def select_color
    print 'Input 1 to play as white or 2 to play as black: '
    input = verify_color(gets.chomp.to_i)
    return 'white' if input == 1
    return 'black' if input == 2
  end

  def verify_color(input)
    return input if input.to_s.match(/[1-2]/) && input.to_s.size == 1

    # else
    puts 'Invalid input!'
    select_color
  end

  def turn_loop
    until checkmate? == true
      display_board
      select_move
      switch_turn unless checkmate?
    end
    end_game
  end

  def display_board
    @player == 'white' ? @board.display_white : @board.display_black
  end

  def select_move
    if @mode == 1
      input = nil
      if @turn == @player
        puts 'Your turn!'
        print 'Input: '
        input = gets.chomp.to_i
      else
        puts "Computer's turn!"
        print 'The computer chooses: '
        # sleep(1)
        puts ''
        # input = nil
      end
      # place_piece(verify_move(input))
    elsif @mode == 2
      if @turn == @player
        puts "White's turn!"
      else
        puts "Black's turn!"
      end
      print 'Input: '
      input = gets.chomp.to_i
      place_piece(verify_move(input))
    end
    input
  end

  def verify_move(input)
    # return [piece, column, row] if valid input
    process_standard_move(input) if valid_standard_move?(input)
    process_disambiguating_move(input) if valid_disambiguating_move?(input)
    process_pawn_promotion_move(input) if valid_pawn_promotion_move?(input)
    process_pawn_promotion_capture_move(input) if valid_pawn_promotion_capture_move?(input)
    process_capture_move(input) if valid_capture_move?(input)
    process_castling_move(input) if valid_castling_move?(input)

    # still need to add:
    # check moves (ex: anything above with "+" or "ch" at the end):
    # checkmate moves (ex: anything above with "#" or "mate" at the end):

    # else
    puts 'Invalid input!'
    select_move
  end

  # standard moves (ex: Be5, Nf3, c5):
  def valid_standard_move?(input)
    input.to_s.match(/\A[BKNPQR][a-h][1-8]\z/) ||
      input.to_s..match(/\A[a-h][1-8]\z/)
  end

  def process_standard_move(input)
    column = column_index(input[-2])
    row = input[-1]
    if input.to_s.size == 3
    # piece = board.coordinates.find_index(column, row) if turn == 'white'
    # piece = board.coordinates.find_index(column, row) if turn == 'black'
    # check for pawn position if moving 2 spaces is possible
    elsif input.to_s.size == 2
      piece = board.coordinates.find_index(column + 1, row) if turn == 'white'
      piece = board.coordinates.find_index(column - 1, row) if turn == 'black'
    end
    [piece, column, row]
  end

  # disambiguating moves (ex: Qh4e1, R1a3, Rdf8):
  def valid_disambiguating_move?(input)
    input.to_s.match(/\A[BKNPQR][a-h][1-8][a-h][1-8]\z/) ||
      input.to_s.match(/\A[BKNPQR][a-h][a-h][1-8]\z/) ||
      input.to_s.match(/\A[BKNPQR][1-8][a-h][1-8]\z/)
  end

  def process_disambiguating_move(input)
    column = column_index(input[-2])
    row = input[-1]
    if input.to_s.size == 5
      piece = board.coordinates.find_index(column_index(input[1]), input[2] - 1)
    elsif input.to_s.size == 4
      if input[1].to_s.match(/[a-h]/)
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
      elsif input[1].to_s.match(/[1-8]/)
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
      end
    end
    [piece, column, row]
  end

  # pawn promotion moves (ex: e8Q, e8=Q, e8(Q), e8/Q):
  def valid_pawn_promotion_move?(input)
    input.to_s.match(/\A[a-h]8\([BNQR]\)\z/) ||
      input.to_s.match(%r{\A[a-h]8[/=][BNQR]\z}) ||
      input.to_s.match(/\A[a-h]8[BNQR]\z/)
  end

  def process_pawn_promotion_move(input)
    if input.to_s.size == 5
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    elsif input.to_s.size == 4
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    elsif input.to_s.size == 3
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    end
    [piece, column, row]
  end

  # pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q):
  def valid_pawn_promotion_capture_move?(input)
    input.to_s.match(/\A[a-h]x[a-h]8\([BNQR]\)\z/) ||
      input.to_s.match(%r{/\A[a-h]x[a-h]8[=/][BNQR]\z/}) ||
      input.to_s.match(/[a-h]x[a-h]8[BNQR]/)
  end

  def process_pawn_promotion_capture_move(input)
    if input.to_s.size == 7
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    elsif input.to_s.size == 6
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    elsif input.to_s.size == 5
      column = column_index(input[1])
      row = input[2]
      # piece = board.coordinates.find_index(column, row) if turn == 'white'
      # piece = board.coordinates.find_index(column, row) if turn == 'black'
    end
    [piece, column, row]
  end

  # capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6):
  def valid_capture_move?(input)
    input.to_s.match(/\A[BKNPQR][a-h][1-8]x[a-h][1-8]\z/) ||
      input.to_s.match(/\A[BKNPQR][a-h]x[a-h][1-8]\z/) ||
      input.to_s.match(/\A[BKNPQR][1-8]x[a-h][1-8]\z/) ||
      input.to_s.match(/\A[BKNPQR]x[a-h][1-8]\z/) ||
      input.to_s.match(/\A[a-h]x[a-h][1-8]\z/)
  end

  def process_capture_move(input)
    column = column_index(input[-2])
    row = input[-1]
    if input.to_s.size == 6
      # piece = board.coordinates.find_index(column, row)
    elsif input.to_s.size == 5
      if input[1].to_s.match(/[a-h]/)
        # piece = board.coordinates.find_index(column, row)
      elsif input[1].to_s.match(/[1-8]/)
        # piece = board.coordinates.find_index(column, row)
      end
    elsif input.to_s.size == 4
      if input[0].to_s.match(/[BKNPQR]/)
        # piece = board.coordinates.find_index(column, row)
      elsif input[0].to_s.match(/[a-h]/)
        # piece = board.coordinates.find_index(column, row)
      end
    end
    [piece, column, row]
  end

  # castling moves (ex: Kg1, Kb8):
  def valid_castling_move?(input)
    input.to_s.match(/\A[0O]-[0O]-[0O]\z/) ||
      input.to_s.match(/\A[0O]-[0O]\z/) ||
      input.to_s.match(/\AK[bg][18]\z/)
  end

  def process_castling_move(input)
    if input.to_s.size == 5
      if @turn == 'white'
        column = column_index(input[1])
        row = input[2]
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
        # piece = board.coordinates.find_index(column, row) if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = input[2]
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
        # piece = board.coordinates.find_index(column, row) if turn == 'black'
      end
    elsif input.to_s.size == 3
      if @turn == 'white'
        column = column_index(input[1])
        row = input[2]
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
        # piece = board.coordinates.find_index(column, row) if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = input[2]
        # piece = board.coordinates.find_index(column, row) if turn == 'white'
        # piece = board.coordinates.find_index(column, row) if turn == 'black'
      end
    end
    [piece, column, row]
  end

  def column_index(input)
    return 0 if input == 'a'
    return 1 if input == 'b'
    return 2 if input == 'c'
    return 3 if input == 'd'
    return 4 if input == 'e'
    return 5 if input == 'f'
    return 6 if input == 'g'
    return 7 if input == 'h'
  end

  def place_piece(piece, new_column_index, new_row_index)
    piece.position = [new_column_index, new_row_index]
    @board.reset_squares
    @board.set(@pieces)
  end

  def eliminate_piece(piece)
    piece.position = nil
    @board.reset_squares
    @board.set(@pieces)
  end

  def switch_turn
    @turn = @turn == 'white' ? 'black' : 'white'
    return unless @mode == 2

    @player = @player == 'white' ? 'black' : 'white'
  end

  def checkmate?
    true if winner?('white') || winner?('black')

    false
  end

  def winner?(_color)
    # return true if color won
    false
  end

  def end_game
    display_result
    prompt_new_game
  end

  def display_result
    display_board
    if @turn == 'white' && @mode == 1
      puts 'You win!'
    elsif @turn == 'black' && @mode == 1
      puts 'Better luck next time!'
    elsif @turn == 'white' && @mode == 2
      puts 'White wins!'
    elsif @turn == 'black' && @mode == 2
      puts 'Black wins!'
    end
  end

  def prompt_new_game
    print 'Would you like to play again? y/n: '
    input = verify_new_game_input(gets.chomp.downcase)
    return unless input == 'y'

    @board = Board.new
    @turn = 'white'
    play
  end

  def verify_new_game_input(input)
    return input if input.to_s.match(/[ny]/) && input.to_s.size == 1

    puts 'Invalid input!'
    prompt_new_game
  end
end
