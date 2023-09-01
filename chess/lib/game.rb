# frozen_string_literal: true

# lib/game.rb
class Game
  attr_accessor :board, :mode, :player, :turn, :pieces

  require_relative 'board'
  require_relative 'piece_maker'
  require_relative 'process_moves'
  require_relative 'serializer'

  include PieceMaker
  include ProcessMoves
  include Serializer

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

  def menu
    puts 'Chess?'
    puts '[1] New Game'
    puts '[2] Load Game'
    puts '[3] Info'
    print 'Selection: '
    input = gets.chomp.to_i
    menu_selection = verify_menu_selection(input)
    process_menu_selection(menu_selection)
  end

  def verify_menu_selection(input)
    if input.to_s.match(/[1-3]/) && input.to_s.size == 1
      input
    else
      puts 'Invalid input!'
      menu
    end
  end

  def process_menu_selection(menu_selection)
    new_game if menu_selection == 1
    choose_game if menu_selection == 2
    return unless menu_selection == 3

    display_info
    menu
  end

  def display_info
    puts 'This is a game of Chess played in the console using algebraic notation:'
    puts '- standard moves (ex: Be5, Nf3, c5)'
    puts '- disambiguating moves (ex: Qh4e1, R1a3, Rdf8)'
    puts '- capture moves (ex: Qh4xe1, R1xa3, Rdxf8, Bxe5, Nxf3, exd6)'
    puts '- pawn promotion moves (ex: e8Q, e8=Q, e8(Q), e8/Q)'
    puts '- pawn promotion capture moves (ex: dxe8Q, dxe8=Q, dxe8(Q), dxe8/Q)'
    puts '- castling moves (ex: Kg1, Kb8, 0-0-0, O-O)'
    puts "- this game supports '+' or '#' at the end of any input to signify check or mate respectively"
  end

  def new_game
    @pieces = create_pieces
    @mode = select_mode
    @player = select_color if @mode == 1
    turn_loop
  end

  def create_pieces
    # create pieces
    pieces_array = []
    create_pawns(pieces_array)
    create_knights(pieces_array)
    create_bishops(pieces_array)
    create_rooks(pieces_array)
    create_queens(pieces_array)
    create_kings(pieces_array)

    # place pieces and update possible moves
    @board.set(pieces_array)
    pieces_array.each { |piece| piece.children = piece.update_children(self) }

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
    until mate? == true
      display_board
      select_move
      switch_turn
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
      puts 'Check!' if check?(@turn) && mate? == false
      return computer_move unless @turn == @player

      input_prompt = "Your turn! Input 'save'/'info' or input your next move: "
    elsif @mode == 2
      input_prompt = @turn == 'white' ? "White's turn!" : "Black's turn!"
      input_prompt += " Input 'save'/'info' or input your next move: "
    end
    input = get_input(input_prompt)
    verify_move(input)
  end

  def verify_move(input)
    loop do
      if input.downcase == 'save'
        process_save
        exit
      elsif input.downcase == 'info'
        display_info
        input = get_input("Input 'save'/'info' or input your next move: ")
      else
        result = process_move(input)
        if result.nil?
          input = get_input('Invalid input! Try again: ')
        else
          place_piece(result)
          break
        end
      end
    end
  end

  def process_save
    save_game(self)
    prompt_new_game
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

    input.delete_suffix!('+')
    input.delete_suffix!('#')

    methods_to_check.each do |method|
      result, result_array = send(method, input.delete('+#'), self)
      next unless result == true

      return result_array if resolved_check?(result_array)
    end

    nil # Return nil if none of the conditions are met
  end

  def resolved_check?(result_array)
    place_piece(result_array)
    check_test = check?(@turn)
    # undo most moves
    if result_array.size == 3
      undo_move(result_array[0])
    # undo castle moves
    elsif result_array.size == 2
      undo_move(result_array[0][0])
      undo_move(result_array[1][0])
    end
    check_test ? false : true
  end

  def undo_move(piece)
    previous_move = piece.previous_moves.pop
    previous_move[1].position = piece.position unless previous_move[1].nil?
    piece.position = previous_move[0]
    @board.reset_squares
    @board.set(@pieces)
    @pieces.each { |board_piece| board_piece.children = board_piece.update_children(self) }
  end

  def computer_move
    print "Computer's turn! The computer chooses: "
    sleep(0.5)
    2.times do
      print '.'
      sleep(0.5)
    end

    # choose piece & move
    possible_pieces = @pieces.select do |piece|
      piece.position.nil? == false && piece.color == @turn && piece.children.empty? == false
    end

    if possible_pieces.empty?
      puts
      end_game
    end

    if check?(@turn)
      random_move = nil
      random_piece = possible_pieces.find do |possible_piece|
        random_move = possible_piece.children.find do |possible_move|
          resolved_check?([possible_piece, possible_move[0], possible_move[1]]) == true
        end
      end

    else
      loop do
        random_piece = possible_pieces.is_a?(Array) ? possible_pieces.sample : possible_pieces
        if random_piece.nil? || random_piece.children.nil?
          puts
          end_game
        end
        random_move = random_piece.children.sample
        break if resolved_check?([random_piece, random_move[0], random_move[1]]) == true

        possible_pieces.delete(random_piece)
      end
    end

    # Log move
    notated_move = generate_algebraic_notation(random_piece, random_move)
    puts " #{notated_move}"

    # execute move
    result = process_move(notated_move)
    place_piece(result)
  end

  def generate_algebraic_notation(chosen_piece, chosen_move)
    target_column = chosen_move[0]
    target_row = chosen_move[1]

    log = String.new
    log += chosen_piece.class.to_s[0] unless chosen_piece.instance_of?(Pawn) || chosen_piece.instance_of?(Knight)
    log += 'N' if chosen_piece.instance_of?(Knight)
    log += reverse_column_index(chosen_piece.position[0]) if @pieces.find do |piece|
                                                               next if piece.position.nil? || piece.children.nil?

                                                               piece.instance_of?(chosen_piece.class) &&
                                                               piece.children.include?([chosen_move]) &&
                                                               piece.position[0] != chosen_piece.position[0]
                                                             end.nil? == false
    log += chosen_piece.position[1].to_s if @pieces.find do |piece|
                                              next if piece.position.nil? || piece.children.nil?

                                              piece.instance_of?(chosen_piece.class) &&
                                              piece.children.include?([chosen_move]) &&
                                              piece.position[1] != chosen_piece.position[1]
                                            end.nil? == false
    if @board.squares[@board.coordinates.find_index([target_column, target_row])] != ' '
      log += 'x'
      log.prepend(reverse_column_index(chosen_piece.position[0])) if chosen_piece.instance_of?(Pawn)
    end
    log += reverse_column_index(target_column)
    log += (8 - target_row).to_s
    if chosen_piece.is_a?(Pawn) && (@turn == 'white' && target_row.zero? || @turn == 'black' && target_row == 7)
      log += '='
      log += %w[B Q N R].sample
    end

    # check for check or mate
    result = process_move(log)
    place_piece(result)
    enemy = @turn == 'black' ? 'white' : 'black'

    log += '+' if check?(enemy) && mate? == false
    log += '#' if mate?

    # undo most moves
    if result.size == 3
      undo_move(result[0])
    # undo castle moves
    elsif result.size == 2
      undo_move(result[0][0])
      undo_move(result[1][0])
    end

    log
  end

  def place_piece(input_array)
    # pawn promotion returns a piece to delete:
    if input_array.size == 2 && input_array[1].nil?
      eliminate_piece(input_array[0])
    # castling move returns two moves to process:
    elsif input_array.size == 2
      input_array.each do |array|
        place_piece(array)
      end
    elsif input_array.size == 3
      # assign values from array
      piece = input_array[0]
      new_column_index = input_array[1]
      new_row_index = input_array[2]

      # build current move [piece, eliminated_piece]
      current_move = [piece.position, nil]

      # eliminate piece (if needed)
      target_square = board.squares[board.coordinates.find_index([new_column_index, new_row_index])]
      if target_square != ' '
        current_move[1] = target_square
        eliminate_piece(target_square)
      end

      # place piece
      piece.previous_moves << current_move
      piece.position = [new_column_index, new_row_index]
      @board.reset_squares
      @board.set(@pieces)
      @pieces.each { |board_piece| board_piece.children = board_piece.update_children(self) }
    else
      p 'error 4329'
    end
  end

  def eliminate_piece(piece)
    piece.previous_moves << [piece.position, nil]
    piece.position = nil

    @board.reset_squares
    @board.set(@pieces)
    @pieces.each { |board_piece| board_piece.children = board_piece.update_children(self) }
  end

  def switch_turn
    @turn = @turn == 'white' ? 'black' : 'white'
    return unless @mode == 2

    @player = @player == 'white' ? 'black' : 'white'
  end

  def check?(victim_color)
    king = @pieces.find { |piece| piece.is_a?(King) && piece.color == victim_color }
    return true if @pieces.any? do |piece|
                     piece.color != victim_color &&
                     piece.children.nil? == false &&
                     piece.children.include?(king.position)
                   end

    # else
    false
  end

  # update mate to check all pieces moves to resolve check, not just king
  def mate?
    kings = @pieces.select { |board_piece| board_piece.is_a?(King) }
    kings.each do |king|
      same_color_pieces = @pieces.select do |board_piece|
        board_piece.color == king.color &&
          board_piece.position.nil? == false &&
          board_piece.children.nil? == false &&
          board_piece.children.empty? == false
      end
      if check?(king.color) &&
         same_color_pieces.all? do |possible_piece|
           possible_piece.children.all? do |possible_move|
             resolved_check?([possible_piece, possible_move[0], possible_move[1]]) == false
           end
         end
        return true
      end
    end
    false
  end

  def end_game
    display_result
    prompt_new_game
  end

  def display_result
    winner = @turn == 'black' ? 'white' : 'black'
    display_board
    if mate? == false
      puts 'Its a draw!'
    elsif @turn == 'white' && @mode == 1
      puts 'You win!'
    else
      puts "#{winner.capitalize} wins!"
    end
  end

  def prompt_new_game
    print 'Would you like to play again? y/n: '
    input = verify_new_game_input(gets.chomp.downcase)
    exit unless input == 'y'

    Game.new.menu
  end

  def verify_new_game_input(input)
    return input if input.to_s.match(/[ny]/) && input.to_s.size == 1

    puts 'Invalid input!'
    prompt_new_game
  end
end
