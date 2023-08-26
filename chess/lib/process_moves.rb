# frozen_string_literal: true

# lib/process_moves.rb
module ProcessMoves
  # require_relative 'board'

  # still need to add:
  # check moves (ex: anything above with "+" or "ch" at the end):
  # checkmate moves (ex: anything above with "#" or "mate" at the end):

  # standard moves (ex: Be5, Nf3, c5):
  def valid_standard_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[a-h][1-8]\z/)&.[](0)
    return false, [] unless first_match == input || second_match == input

    # process move
    result_array = process_standard_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_standard_move(input, game)
    # set variables
    piece_class = input.to_s.size == 3 ? translate_class(input[0]) : Pawn
    column = column_index(input[-2])
    row = 8 - input[-1].to_i
    piece = nil
    # find piece
    game.pieces.each do |board_piece|
      # skip captured pieces
      next if board_piece.children.nil?
      next unless board_piece.is_a?(piece_class) &&
                  board_piece.color == game.turn &&
                  board_piece.children.include?([column, row])

      piece = board_piece
      break
    end
    # return
    [piece, column, row]
  end

  # disambiguating moves (ex: Qh4e1, R1a3, Rdf8):
  def valid_disambiguating_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8][a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[BKNPQR][a-h][a-h][1-8]\z/)&.[](0)
    third_match = input.to_s.match(/\A[BKNPQR][1-8][a-h][1-8]\z/)&.[](0)
    # p input == first_match
    # p input == second_match
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input

    # process move
    result_array = process_disambiguating_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_disambiguating_move(input, game)
    piece_class = translate_class(input[0])
    column = column_index(input[-2])
    row = 8 - input[-1].to_i
    piece = nil
    if input.to_s.size == 5
      game.pieces.each do |board_piece|
        piece = board_piece if board_piece.position == [column_index(input[1]), 8 - input[2].to_i]
      end
    elsif input.to_s.size == 4
      if input[1].to_s.match(/[a-h]/)
        piece = game.pieces.find do |p|
          p.instance_of?(piece_class) &&
            p.position[0] == column_index(input[1]) &&
            p.color == game.turn
        end
      elsif input[1].to_s.match(/[1-8]/)
        piece = game.pieces.find do |p|
          p.instance_of?(piece_class) &&
            p.position[1] == 8 - input[1].to_i &&
            p.color == game.turn
        end
      end
    end
    [piece, column, row]
  end

  # pawn promotion moves (ex: e8Q, e8=Q, e8(Q), e8/Q):
  def valid_pawn_promotion_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[a-h]8\([BNQR]\)\z/)&.[](0)
    second_match = input.to_s.match(%r{\A[a-h]8[/=][BNQR]\z})&.[](0)
    third_match = input.to_s.match(/\A[a-h]8[BNQR]\z/)&.[](0)
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input

    # process move
    result_array = process_pawn_promotion_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_pawn_promotion_move(input, game)
    column = column_index(input[0])
    row = 8 - input[1].to_i

    # create new piece
    piece = nil
    if input.to_s.size == 3
      new_piece_class = translate_class(input[2])
      piece = new_piece_class.new(game, nil, game.turn)
    else
      new_piece_class = translate_class(input[3])
      piece = new_piece_class.new(game, nil, game.turn)
    end
    game.pieces << piece

    # delete old piece
    old_piece = nil
    game.pieces.each do |board_piece|
      # skip captured pieces
      next if board_piece.children.nil?
      next unless board_piece.instance_of?(Pawn) && board_piece.children.include?([column, row])

      old_piece = board_piece
      break
    end
    old_piece.position = nil

    # return
    [piece, column, row]
  end

  # pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q):
  def valid_pawn_promotion_capture_move?(input, _game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[a-h]x[a-h]8\([BNQR]\)\z/)&.[](0)
    second_match = input.to_s.match(%r{/\A[a-h]x[a-h]8[=/][BNQR]\z/})&.[](0)
    third_match = input.to_s.match(/\A[a-h]x[a-h]8[BNQR]\z/)&.[](0)
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input

    # process move
    result_array = process_pawn_promotion_capture_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_pawn_promotion_capture_move(input, _turn)
    if input.to_s.size == 7
      column = column_index(input[1])
      row = 8 - input[2].to_i
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 6
      column = column_index(input[1])
      row = 8 - input[2].to_i
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 5
      column = column_index(input[1])
      row = 8 - input[2].to_i
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    end
    [piece, column, row]
  end

  # capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6):
  def valid_capture_move?(input, _game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8]x[a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[BKNPQR][a-h]x[a-h][1-8]\z/)&.[](0)
    third_match = input.to_s.match(/\A[BKNPQR][1-8]x[a-h][1-8]\z/)&.[](0)
    fourth_match = input.to_s.match(/\A[BKNPQR]x[a-h][1-8]\z/)&.[](0)
    fifth_match = input.to_s.match(/\A[a-h]x[a-h][1-8]\z/)&.[](0)
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input ||
                            fourth_match == input ||
                            fifth_match == input

    # process move
    result_array = process_capture_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_capture_move(input, _turn)
    column = column_index(input[-2])
    row = 8 - input[-1].to_i
    if input.to_s.size == 6
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)]
    elsif input.to_s.size == 5
      if input[1].to_s.match(/[a-h]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)]
      elsif input[1].to_s.match(/[1-8]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)]
      end
    elsif input.to_s.size == 4
      if input[0].to_s.match(/[BKNPQR]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)]
      elsif input[0].to_s.match(/[a-h]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)]
      end
    end
    [piece, column, row]
  end

  # castling moves (ex: Kg1, Kb8):
  def valid_castling_move?(input, _game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[0O]-[0O]-[0O]\z/)&.[](0)
    second_match = input.to_s.match(/\A[0O]-[0O]\z/)&.[](0)
    third_match = input.to_s.match(/\AK[bg][18]\z/)&.[](0)
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input

    # process move
    result_array = process_castling_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_castling_move(input, _turn)
    if input.to_s.size == 5
      if @turn == 'white'
        column = column_index(input[1])
        row = 8 - input[2].to_i
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = 8 - input[2].to_i
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      end
    elsif input.to_s.size == 3
      if @turn == 'white'
        column = column_index(input[1])
        row = 8 - input[2].to_i
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = 8 - input[2].to_i
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      end
    end
    [piece, column, row]
  end

  def translate_class(input)
    return Bishop if input == 'B'
    return King if input == 'K'
    return Knight if input == 'N'
    return Pawn if input == 'P'
    return Queen if input == 'Q'
    return Rook if input == 'R'
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
end
