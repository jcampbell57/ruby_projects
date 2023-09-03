# frozen_string_literal: true

# lib/process_moves.rb
module ProcessMoves
  # standard moves (ex: Be5, Nf3, c5):
  def valid_standard_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[a-h][1-8]\z/)&.[](0)
    return false, [] unless first_match == input || second_match == input

    # skip castling moves
    return false if %w[Kg1 Kg8 Kb1 Kb8].include?(input)

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
    first_match = input.to_s.match(/\A[a-h][18]\([BNQR]\)\z/)&.[](0)
    second_match = input.to_s.match(%r{\A[a-h][18][/=][BNQR]\z})&.[](0)
    third_match = input.to_s.match(/\A[a-h][18][BNQR]\z/)&.[](0)
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
    new_piece_class = translate_class(input[/[BNQR]/])
    piece = new_piece_class.new(game, nil, game.turn)
    game.pieces << piece

    # delete old piece
    pawn_column = column_index(input[0])
    old_piece = game.pieces.find do |board_piece|
      board_piece.children.nil? == false &&
        board_piece.instance_of?(Pawn) &&
        board_piece.position[0] == pawn_column &&
        board_piece.children.include?([column, row])
    end

    # return
    [[piece, column, row], [old_piece, nil]]
  end

  # pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q):
  def valid_pawn_promotion_capture_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[a-h]x[a-h][18]\([BNQR]\)\z/)&.[](0)
    second_match = input.to_s.match(%r{\A[a-h]x[a-h][18][/=][BNQR]\z})&.[](0)
    third_match = input.to_s.match(/\A[a-h]x[a-h][18][BNQR]\z/)&.[](0)
    return false, [] unless first_match == input ||
                            second_match == input ||
                            third_match == input

    # process move
    result_array = process_pawn_promotion_capture_move(input, game)
    # return false if piece is not able to move to target square
    return false, [] if result_array[0].nil?

    [true, result_array]
  end

  def process_pawn_promotion_capture_move(input, game)
    column = column_index(input[2])
    row = 8 - input[3].to_i

    # create new piece
    new_piece_class = translate_class(input[/[BNQR]/])
    piece = new_piece_class.new(game, nil, game.turn)
    game.pieces << piece

    # delete old piece
    pawn_column = column_index(input[0])
    old_piece = game.pieces.find do |board_piece|
      board_piece.children.nil? == false &&
        board_piece.instance_of?(Pawn) &&
        board_piece.position[0] == pawn_column &&
        board_piece.children.include?([column, row])
    end

    # return
    [[piece, column, row], [old_piece, nil]]
  end

  # capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6):
  def valid_capture_move?(input, game)
    return false, [] if input.nil?

    # check to see if input matches syntax
    first_match = input.to_s.match(/\A[BKNPQR][a-h][1-8]x[a-h][1-8]\z/)&.[](0)
    second_match = input.to_s.match(/\A[BKNQR][a-h]x[a-h][1-8]\z/)&.[](0)
    third_match = input.to_s.match(/\A[BKNPQR][1-8]x[a-h][1-8]\z/)&.[](0)
    fourth_match = input.to_s.match(/\A[BKNPQR]x[a-h][1-8]\z/)&.[](0)
    fifth_match = input.to_s.match(/\A[a-h]x[a-h][1-7]\z/)&.[](0)
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

  def process_capture_move(input, game)
    # assign target column/row
    column = column_index(input[-2])
    row = 8 - input[-1].to_i

    # assign current column/row
    piece_column = nil
    piece_row = nil
    if input.to_s.size == 6
      piece_column = column_index(input[1])
      piece_row = 8 - input[2].to_i
    elsif input.to_s.size == 5
      if input[1].to_s.match(/[a-h]/)
        piece_column = column_index(input[1])
      elsif input[1].to_s.match(/[1-8]/)
        piece_row = 8 - input[1].to_i
      end
    elsif input.to_s.size == 4
      if input[0].to_s.match(/[BKNPQR]/)
        # there is no known column or row in this case
      elsif input[0].to_s.match(/[a-h]/)
        piece_column = column_index(input[0])
      end
    end

    # find piece
    piece = nil
    piece_class = input[0].to_s.match(/[BKNPQR]/) ? translate_class(input[0]) : Pawn
    game.pieces.each do |board_piece|
      # skip captured pieces
      next if board_piece.children.nil?

      conditions = []
      conditions << board_piece.instance_of?(piece_class)
      conditions << (board_piece.color == game.turn)
      if piece_column
        conditions << (input.to_s.size == 4 ? board_piece.position[0] == piece_column : board_piece.position[1] == piece_column)
      end
      conditions << board_piece.position[1] == piece_row if piece_row
      conditions << board_piece.children.include?([column, row])
      piece = board_piece if conditions.all?
    end

    [piece, column, row]
  end

  # castling moves (ex: Kg1, Kb8, 0-0-0, O-O):
  def valid_castling_move?(input, game)
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
    return false, [] if result_array[0].nil? || result_array[-1].nil?

    [true, result_array]
  end

  def spaces_clear?(spaces_array, game)
    spaces_array.all? { |space| game.board.squares[game.board.coordinates.find_index([space[0], space[1]])] == ' ' }
  end

  def can_castle?(input, game, king)
    king.position == (king.color == 'white?' ? [4, 7] : [4, 0]) &&
      king.previous_moves.empty? &&
      if input == 'Kb1' || input[/\A[0O]-[0O]-[0O]\z/]
        game.board.squares[game.board.coordinates.find_index([0, 7])].is_a?(Rook)
        spaces_clear?([[1, 7], [2, 7], [3, 7]], game)
      elsif input == 'Kg1' || input[/\A[0O]-[0O]\z/]
        game.board.squares[game.board.coordinates.find_index([7, 7])].is_a?(Rook)
        spaces_clear?([[5, 7], [6, 7]], game)
      elsif input == 'Kb8' || input[/\A[0O]-[0O]-[0O]\z/]
        game.board.squares[game.board.coordinates.find_index([0, 0])].is_a?(Rook)
        spaces_clear?([[1, 0], [2, 0], [3, 0]], game)
      elsif input == 'Kg8' || input[/\A[0O]-[0O]\z/]
        game.board.squares[game.board.coordinates.find_index([7, 0])].is_a?(Rook)
        spaces_clear?([[5, 0], [6, 0]], game)
      end
  end

  def process_castling_move(input, game)
    column = nil
    row = nil
    rook_move = nil
    piece = game.pieces.find { |board_piece| board_piece.is_a?(King) && board_piece.color == game.turn }
    if can_castle?(input, game, piece) == false
      return process_standard_move(input, game) if %w[Kb1 Kg1 Kb8 Kg8].include?(input)

      return [nil]
    elsif input == 'Kb1' || (input[/\A[0O]-[0O]-[0O]\z/] && game.turn == 'white')
      rook_move = [game.board.squares[game.board.coordinates.find_index([0, 7])], 3, 7]
      column = 2
      row = 7
    elsif input == 'Kg1' || (input[/\A[0O]-[0O]\z/] && game.turn == 'white')
      rook_move = [game.board.squares[game.board.coordinates.find_index([7, 7])], 5, 7]
      column = 6
      row = 7
    elsif input == 'Kb8' || (input[/\A[0O]-[0O]-[0O]\z/] && game.turn == 'black')
      rook_move = [game.board.squares[game.board.coordinates.find_index([0, 0])], 3, 0]
      column = 2
      row = 0
    elsif input == 'Kg8' || (input[/\A[0O]-[0O]\z/] && game.turn == 'black')
      rook_move = [game.board.squares[game.board.coordinates.find_index([7, 0])], 5, 0]
      column = 6
      row = 0
    else
      return [nil]
    end

    [[piece, column, row], rook_move]
  end

  def translate_class(input)
    return Bishop if input == 'B'
    return King if input == 'K'
    return Knight if input == 'N'
    return Pawn if input == 'P'
    return Queen if input == 'Q'
    return Rook if input == 'R'
  end

  def reverse_column_index(input)
    return 'a' if input.zero?
    return 'b' if input == 1
    return 'c' if input == 2
    return 'd' if input == 3
    return 'e' if input == 4
    return 'f' if input == 5
    return 'g' if input == 6
    return 'h' if input == 7
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
