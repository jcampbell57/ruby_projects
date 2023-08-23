# frozen_string_literal: true

# lib/process_moves.rb
module ProcessMoves
  # require_relative 'board'

  # still need to add:
  # check moves (ex: anything above with "+" or "ch" at the end):
  # checkmate moves (ex: anything above with "#" or "mate" at the end):
  # need to stop bishop/rook and other pieces from moving if other piece is in the way.

  def valid_move?(input, game)
    return true if
      valid_standard_move?(input, game) == true
    # valid_disambiguating_move?(input, _game) == true ||
    # valid_pawn_promotion_move?(input, _game) == true ||
    # valid_pawn_promotion_capture_move?(input, _game) == true ||
    # valid_capture_move?(input, _game) == true ||
    # valid_castling_move?(input, _game) == true
  end

  # standard moves (ex: Be5, Nf3, c5):
  def valid_standard_move?(input, game)
    return if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[a-h][1-8]\z/)&.[](0)

    # check to see if a piece is able to move to target square
    if first_match == input || second_match == input
      column = column_index(input[-2])
      row = 8 - input[-1].to_i
      piece = nil
      if input.to_s.size == 3
        piece_class = translate_class(input[0])
        game.pieces.each do |board_piece|
          next unless board_piece.is_a?(piece_class) &&
                      board_piece.color == game.turn &&
                      board_piece.children.include?([column, row])

          piece = board_piece
          break
        end
      elsif input.to_s.size == 2
        # check for pawn position if moving 2 spaces is possible
        if game.turn == 'white'
          row_three_square = game.board.squares[game.board.coordinates.find_index([column, 5])]
          piece = if row == 4 && row_three_square.is_a?(Pawn) == false
                    game.board.squares[game.board.coordinates.find_index([column, 6])]
                  else
                    game.board.squares[game.board.coordinates.find_index([column, row + 1])]
                  end
        elsif game.turn == 'black'
          piece = if row == 3 && game.board.squares[game.board.coordinates.find_index([column, 2])] == ' '
                    game.board.squares[game.board.coordinates.find_index([column, 1])]
                  else
                    game.board.squares[game.board.coordinates.find_index([column, row - 1])]
                  end
        end
      end
      return if piece.nil?
    end

    return true if first_match == input || second_match == input
  end

  def process_standard_move(input, game)
    column = column_index(input[-2])
    row = 8 - input[-1].to_i
    piece = nil
    if input.to_s.size == 3
      piece_class = translate_class(input[0])
      game.pieces.each do |board_piece|
        next unless board_piece.is_a?(piece_class) &&
                    board_piece.color == game.turn &&
                    board_piece.children.include?([column, row])

        piece = board_piece
        break
      end
      # if piece.nil?

      # end
      # game.board.squares[game.board.coordinates.find_index([column, 3])]
      [piece, column, row]
    elsif input.to_s.size == 2
      # check for pawn position if moving 2 spaces is possible
      if game.turn == 'white'
        row_three_square = game.board.squares[game.board.coordinates.find_index([column, 5])]
        piece = if row == 4 && row_three_square.is_a?(Pawn) == false
                  game.board.squares[game.board.coordinates.find_index([column, 6])]
                else
                  game.board.squares[game.board.coordinates.find_index([column, row + 1])]
                end
      elsif game.turn == 'black'
        piece = if row == 3 && game.board.squares[game.board.coordinates.find_index([column, 2])] == ' '
                  game.board.squares[game.board.coordinates.find_index([column, 1])]
                else
                  game.board.squares[game.board.coordinates.find_index([column, row - 1])]
                end
      end
    end
    [piece, column, row]
  end

  # disambiguating moves (ex: Qh4e1, R1a3, Rdf8):
  def valid_disambiguating_move?(input, _game)
    return true if input.to_s.match(/\A[BKNPQR][a-h][1-8][a-h][1-8]\z/) ||
                   input.to_s.match(/\A[BKNPQR][a-h][a-h][1-8]\z/) ||
                   input.to_s.match(/\A[BKNPQR][1-8][a-h][1-8]\z/)
  end

  def process_disambiguating_move(input, _turn)
    column = column_index(input[-2])
    row = input[-1] - 1
    if input.to_s.size == 5
      piece = game.board.squares[game.board.coordinates.find_index(column_index(input[1]), input[2] - 1)]
    elsif input.to_s.size == 4
      if input[1].to_s.match(/[a-h]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      elsif input[1].to_s.match(/[1-8]/)
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      end
    end
    [piece, column, row]
  end

  # pawn promotion moves (ex: e8Q, e8=Q, e8(Q), e8/Q):
  def valid_pawn_promotion_move?(input, _game)
    return true if input.to_s.match(/\A[a-h]8\([BNQR]\)\z/) ||
                   input.to_s.match(%r{\A[a-h]8[/=][BNQR]\z}) ||
                   input.to_s.match(/\A[a-h]8[BNQR]\z/)
  end

  def process_pawn_promotion_move(input, _turn)
    if input.to_s.size == 5
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 4
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 3
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    end
    [piece, column, row]
  end

  # pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q):
  def valid_pawn_promotion_capture_move?(input, _game)
    return true if input.to_s.match(/\A[a-h]x[a-h]8\([BNQR]\)\z/) ||
                   input.to_s.match(%r{/\A[a-h]x[a-h]8[=/][BNQR]\z/}) ||
                   input.to_s.match(/\A[a-h]x[a-h]8[BNQR]\z/)
  end

  def process_pawn_promotion_capture_move(input, _turn)
    if input.to_s.size == 7
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 6
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    elsif input.to_s.size == 5
      column = column_index(input[1])
      row = input[2] - 1
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
      # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
    end
    [piece, column, row]
  end

  # capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6):
  def valid_capture_move?(input, _game)
    return true if input.to_s.match(/\A[BKNPQR][a-h][1-8]x[a-h][1-8]\z/) ||
                   input.to_s.match(/\A[BKNPQR][a-h]x[a-h][1-8]\z/) ||
                   input.to_s.match(/\A[BKNPQR][1-8]x[a-h][1-8]\z/) ||
                   input.to_s.match(/\A[BKNPQR]x[a-h][1-8]\z/) ||
                   input.to_s.match(/\A[a-h]x[a-h][1-8]\z/)
  end

  def process_capture_move(input, _turn)
    column = column_index(input[-2])
    row = input[-1] - 1
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
    return true if input.to_s.match(/\A[0O]-[0O]-[0O]\z/) ||
                   input.to_s.match(/\A[0O]-[0O]\z/) ||
                   input.to_s.match(/\AK[bg][18]\z/)
  end

  def process_castling_move(input, _turn)
    if input.to_s.size == 5
      if @turn == 'white'
        column = column_index(input[1])
        row = input[2] - 1
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = input[2] - 1
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      end
    elsif input.to_s.size == 3
      if @turn == 'white'
        column = column_index(input[1])
        row = input[2] - 1
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'white'
        # piece = game.board.squares[game.board.coordinates.find_index(column, row)] if turn == 'black'
      elsif @turn == 'black'
        column = column_index(input[1])
        row = input[2] - 1
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
