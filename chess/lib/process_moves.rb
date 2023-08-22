module ProcessMoves
  require_relative 'board'

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
end
