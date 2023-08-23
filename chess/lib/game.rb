# frozen_string_literal: true

# lib/game.rb
class Game
  attr_accessor :board, :mode, :player, :turn, :pieces

  require_relative 'board'
  require_relative 'bishop'
  require_relative 'king'
  require_relative 'knight'
  require_relative 'pawn'
  require_relative 'process_moves'
  require_relative 'queen'
  require_relative 'rook'

  include ProcessMoves

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
        input = gets.chomp
      else
        puts "Computer's turn!"
        print 'The computer chooses: '
        # sleep(1)
        puts ''
        # input = nil
        return
      end
    elsif @mode == 2
      puts @turn == @player ? "White's turn!" : "Black's turn!"
      print 'Input: '
      input = gets.chomp
    end
    verify_move(input)
  end

  def verify_move(input)
    loop do
      if valid_move?(input, self)
        place_piece(process_move(input))
        break
      else
        print 'Invalid input! Try again: '
        input = gets.chomp
      end
    end
  end

  def process_move(input)
    # return [piece, column, row] if valid input
    if valid_standard_move?(input, self)
      process_standard_move(input, self)
    elsif valid_disambiguating_move?(input, self)
      process_disambiguating_move(input, self)
    elsif valid_pawn_promotion_move?(input, self)
      process_pawn_promotion_move(input, self)
    elsif valid_pawn_promotion_capture_move?(input, self)
      process_pawn_promotion_capture_move(input, self)
    elsif valid_capture_move?(input, self)
      process_capture_move(input, self)
    elsif valid_castling_move?(input, self)
      process_castling_move(input, self)
    else

      # else
      puts 'Error3045'
    end
  end

  def place_piece(input_array)
    # assign values from array
    piece = input_array[0]
    new_column_index = input_array[1]
    new_row_index = input_array[2]

    # place piece
    piece.position = [new_column_index, new_row_index]
    piece.children = piece.adjacency_list[board.coordinates.find_index(piece.position)]
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
