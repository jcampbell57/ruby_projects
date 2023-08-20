# frozen_string_literal: true

# lib/game.rb
class Game
  attr_accessor :board, :mode, :player, :turn

  require_relative 'board'
  require_relative 'pieces'
  include Pieces

  def initialize(board = Board.new, mode = nil, player = 'white', turn = 'white')
    self.board = board
    self.mode = mode
    self.player = player
    self.turn = turn
  end

  def play
    @mode = select_mode
    @player = select_color if @mode == 1
    turn_loop
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
    # return input if valid

    # standard moves (ex: Be5, Nf3, c5):

    return input if input.to_s.size == 3 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[a-h]/) &&
                    input[2].to_s.match(/[1-8]/)

    return input if input.to_s.size == 2 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/[1-8]/)

    # disambiguating moves (ex: Qh4e1, R1a3, Rdf8):

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[a-h]/) &&
                    input[2].to_s.match(/[1-8]/) &&
                    input[3].to_s.match(/[a-h]/) &&
                    input[4].to_s.match(/[1-8]/)

    return input if input.to_s.size == 4 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[a-h]/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/[1-8]/)

    return input if input.to_s.size == 4 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[1-8]/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/[1-8]/)

    # pawn promotion moves (ex: e8Q, e8=Q, e8(Q), e8/Q):

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/8/) &&
                    input[2].to_s.match(/[(]/) &&
                    input[3].to_s.match(/[BNQR]/) &&
                    input[4].to_s.match(/[)]/)

    return input if input.to_s.size == 4 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/8/) &&
                    input[2].to_s.match(%r{[=/]}) &&
                    input[3].to_s.match(/[BNQR]/)

    return input if input.to_s.size == 3 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/8/) &&
                    input[2].to_s.match(/[BNQR]/)

    # pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q):

    return input if input.to_s.size == 7 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/x/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/8/) &&
                    input[4].to_s.match(/[(]/) &&
                    input[5].to_s.match(/[BNQR]/) &&
                    input[6].to_s.match(/[)]/)

    return input if input.to_s.size == 6 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/x/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/8/) &&
                    input[4].to_s.match(%r{[=/]}) &&
                    input[5].to_s.match(/[BNQR]/)

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/x/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/8/) &&
                    input[4].to_s.match(/[BNQR]/)

    # capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6):

    return input if input.to_s.size == 6 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[a-h]/) &&
                    input[2].to_s.match(/[1-8]/) &&
                    input[3].to_s.match(/x/) &&
                    input[4].to_s.match(/[a-h]/) &&
                    input[5].to_s.match(/[1-8]/)

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[a-h]/) &&
                    input[2].to_s.match(/x/) &&
                    input[3].to_s.match(/[a-h]/) &&
                    input[4].to_s.match(/[1-8]/)

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/[1-8]/) &&
                    input[2].to_s.match(/x/) &&
                    input[3].to_s.match(/[a-h]/) &&
                    input[4].to_s.match(/[1-8]/)

    return input if input.to_s.size == 4 &&
                    input[0].to_s.match(/[BKNPQR]/) &&
                    input[1].to_s.match(/x/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/[1-8]/)

    return input if input.to_s.size == 4 &&
                    input[0].to_s.match(/[a-h]/) &&
                    input[1].to_s.match(/x/) &&
                    input[2].to_s.match(/[a-h]/) &&
                    input[3].to_s.match(/[1-8]/)

    # castling moves (eX: Kg1, Kb8):

    return input if input.to_s.size == 5 &&
                    input[0].to_s.match(/[0O]/) &&
                    input[1].to_s.match(/-/) &&
                    input[0].to_s.match(/[0O]/) &&
                    input[1].to_s.match(/-/) &&
                    input[2].to_s.match(/0O/)

    return input if input.to_s.size == 3 &&
                    input[0].to_s.match(/[0O]/) &&
                    input[1].to_s.match(/-/) &&
                    input[2].to_s.match(/0O/)

    return input if input.to_s.size == 3 &&
                    input[0].to_s.match(/K/) &&
                    input[1].to_s.match(/[bg]/) &&
                    input[2].to_s.match(/18/)

    # still need to add:
    # check moves (ex: anything above with "+" or "ch" at the end):
    # checkmate moves (ex: anything above with "#" or "mate" at the end):

    # else

    puts 'Invalid input!'
    select_move
  end

  def place_piece(piece, new_column_index, new_row_index)
    # remove from previous position
    board.squares[board.coordinates.find_index(piece.position)] = ' '
    # place in new position
    board.squares[board.coordinates.find_index([new_column_index, new_row_index])] = piece.to_s
    piece.position = [new_column_index, new_row_index]
  end

  def eliminate_piece(piece)
    # remove piece from board
    board[board.find_index(piece.position)] = ' '
    piece.position = nil
    # add piece to appropriate player's collection
    piece.color == 'white' ? white_captured << piece.to_s : black_captured << piece.to_s
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
