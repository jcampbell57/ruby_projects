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
    self.pieces = pieces
    self.mode = mode
    self.player = player
    self.turn = turn
  end

  def new_game
    @pieces = create_pieces
    @mode = select_mode
    @player = select_color if @mode == 1
    turn_loop
  end

  def create_pieces
    pieces_array = []
    create_pawns(pieces_array)
    create_knights(pieces_array)
    create_bishops(pieces_array)
    create_rooks(pieces_array)
    create_queens(pieces_array)
    create_kings(pieces_array)
    @board.set(pieces_array)

    pieces_array.each { |piece| piece.children = piece.update_children(self) }

    # return
    pieces_array
  end

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

  def get_input(prompt)
    print prompt
    gets.chomp
  end

  def select_move
    if @mode == 1
      return computer_move unless @turn == @player

      input_prompt = 'Your turn! Input: '
    elsif @mode == 2
      input_prompt = @turn == @player ? "White's turn! Input: " : "Black's turn! Input: "
    end
    input = get_input(input_prompt)
    verify_move(input)
  end

  def verify_move(input)
    loop do
      result = process_move(input)
      if result.nil?
        input = get_input('Invalid input! Try again: ')
      else
        place_piece(result)
        break
      end
    end
  end

  def process_move(input)
    methods_to_check = %i[
      valid_standard_move?
      valid_disambiguating_move?
      valid_pawn_promotion_move?
      valid_pawn_promotion_capture_move?
      valid_capture_move?
      valid_castling_move?
    ]

    methods_to_check.each do |method|
      result, result_array = send(method, input, self)
      return result_array if result == true
    end

    nil # Return nil if none of the conditions are met
  end

  def computer_move
    puts "Computer's turn! The computer chooses: "
    # print "Computer's turn! The computer chooses: "
    # 3.times do
    #   sleep(1)
    #   print '.'
    # end
    # computer_input =
    # verify_move(computer_input)
  end

  def place_piece(input_array)
    # assign values from array
    piece = input_array[0]
    new_column_index = input_array[1]
    new_row_index = input_array[2]

    # eliminate piece
    target_square = board.squares[board.coordinates.find_index([new_column_index, new_row_index])]
    eliminate_piece(target_square) unless target_square == ' '

    # place piece
    piece.position = [new_column_index, new_row_index]
    @board.reset_squares
    @board.set(@pieces)
    @pieces.each { |board_piece| board_piece.children = board_piece.update_children(self) }
  end

  def eliminate_piece(piece)
    piece.position = nil
    # @board.reset_squares
    # @board.set(@pieces)
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
    else
      puts "#{@turn.capitalize} wins!"
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
