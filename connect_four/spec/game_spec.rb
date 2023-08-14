# frozen_string_literal: true

# spec/game_spec.rb
require './lib/game'
require './lib/markers'

describe Game do
  include Markers

  subject(:game) { described_class.new }

  describe '#play' do
    single_player_mode = 1

    before do
      allow(game).to receive(:gets).and_return(single_player_mode.to_s)
      allow(game).to receive(:print).with('Input 1 for single player or 2 for multiplayer: ').once
      allow(game).to receive(:game_loop).once
    end

    it 'sets game.mode' do
      # expect { game.play }.to change(game.mode).to be(single_player_mode)
      expect(game.mode).to be(nil)
      game.play
      expect(game.mode).to be(single_player_mode)
    end

    it 'starts game_loop' do
      expect(game).to receive(:game_loop).once
      game.play
    end
  end

  describe '#select_mode' do
    mode_selection = 1

    before do
      allow(game).to receive(:print).with('Input 1 for single player or 2 for multiplayer: ').once
      allow(game).to receive(:gets).and_return(mode_selection.to_s)
    end

    it 'prompts player for mode' do
      expect(game).to receive(:print).with('Input 1 for single player or 2 for multiplayer: ').once
      game.mode = game.select_mode
      expect(game.mode).to be(mode_selection)
    end
  end

  describe '#verify_mode' do
    context 'when given valid input' do
      it 'returns input' do
        valid_input = 1
        expect(game.verify_mode(valid_input)).to be(valid_input)
        game.verify_mode(valid_input)
      end
    end

    context 'when given invalid input' do
      it 'prompts player for new input' do
        valid_input = 1
        invalid_input = 'b'
        expect(game).to receive(:puts).with('Invalid input!').once
        expect(game).to receive(:select_mode).once.and_return(valid_input)
        expect(game.verify_mode(invalid_input)).to be(valid_input)
      end
    end
  end

  describe '#game_loop' do
    context 'when game is not over' do
      before do
        allow(game).to receive(:game_over?).and_return(false, false, true) # Simulate loop iterations
        allow(game).to receive(:display_board)
        allow(game).to receive(:select_move)
        allow(game).to receive(:end_game)
      end

      it 'calls display_board and select_move' do
        expect(game).to receive(:display_board).twice
        expect(game).to receive(:select_move).twice
        expect(game).to receive(:end_game).once
        game.game_loop
      end
    end

    context 'when game is over' do
      before do
        allow(game).to receive(:game_over?).and_return(true)
        allow(game).to receive(:display_board)
        allow(game).to receive(:select_move)
        allow(game).to receive(:end_game)
      end

      it 'calls end_game' do
        expect(game).not_to receive(:display_board)
        expect(game).not_to receive(:select_move)
        expect(game).to receive(:end_game).once
        game.game_loop
      end
    end
  end

  describe '#create_board' do
    it 'creates board' do
      empty_circle = "\u25cb"
      expect(game).to receive(:create_board).and_return(Array.new(7, Array.new(6, empty_circle)))
      game.create_board
    end
  end

  # describe '#display_board' do
  #   xit 'displays board' do
  #     # no test needed
  #   end
  # end

  # describe '#display_row' do
  #   context 'when given row index' do
  #     it 'returns row as array' do
  #       empty_circle = "\u25cb"
  #       expect(game.display_row(5)).to eql(Array.new(7, empty_circle))
  #     end
  #   end
  # end

  describe '#select_move' do
    it 'prompts player for move' do
      valid_input = 4
      allow(game).to receive(:gets).and_return(valid_input.to_s)
      expect(game).to receive(:print).with('Input the culumn you would like to drop your marker 1-7: ')
      expect(game).to receive(:gets).and_return(valid_input.to_s)
      expect(game).to receive(:verify_move)
      game.select_move
    end
  end

  describe '#verify_move' do
    context 'when given valid input' do
      it 'returns input' do
        valid_input = 4
        expect(game.verify_move(valid_input)).to be(valid_input)
        game.verify_move(valid_input)
      end
    end

    context 'when given invalid input' do
      it 'prompts player for new input' do
        valid_input = 4
        invalid_input = 'b'
        expect(game).to receive(:puts).with('Invalid input!').once
        expect(game).to receive(:print).with('Input the culumn you would like to drop your marker 1-7: ')
        expect(game).to receive(:gets).and_return(valid_input.to_s)
        expect(game.verify_move(invalid_input.chomp.to_i)).to be(valid_input)
      end
    end
  end

  describe '#game_over?' do
    context 'when game is over' do
      before do
        allow(game).to receive(:diagonal_win?).and_return(true)
      end

      it 'returns true' do
        expect(game.game_over?).to be(true)
        # game.game_over?
      end
    end

    context 'when game is not over' do
      it 'returns false' do
        expect(game.game_over?).to be(false)
        game.game_over?
      end
    end
  end

  describe '#vertical_win?' do
    context 'when there are 4 vertically matching markers' do
      before do
        @board = [
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark]
        ]
      end

      it 'returns true' do
        expect(game.diagonal_win?).to be(true)
      end
    end

    context 'when there are not 4 vertically matching markers' do
      before do
        @board = game.create_board
      end

      it 'returns false' do
        expect(game.diagonal_win?).to be(false)
      end
    end
  end

  describe '#horizontal_win?' do
    context 'when there are 4 horizontally matching markers' do
      before do
        @board = [
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, player_mark, player_mark, player_mark, player_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark]
        ]
      end

      xit 'returns true' do
        expect(game.diagonal_win?).to be(true)
      end
    end

    context 'when there are not 4 horizontally matching markers' do
      before do
        @board = game.create_board
      end

      xit 'returns false' do
        expect(game.diagonal_win?).to be(false)
      end
    end
  end

  describe '#diagonal_win?' do
    context 'when there are 4 diagonally matching markers' do
      before do
        @board = [
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, player_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, player_mark, empty_mark, empty_mark, empty_mark, empty_mark],
          [empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark, empty_mark]
        ]
      end

      xit 'returns true' do
        expect(game.diagonal_win?).to be(true)
      end
    end

    context 'when there are not 4 diagonally matching markers' do
      xit 'returns false' do
        expect(game.diagonal_win?).to be(false)
      end
    end
  end

  describe '#end_game' do
    # xit 'displays result' do
    #   # no test needed
    # end

    context 'player wins' do
      before do
        game.player_marker = 'b'
        game.board = [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['b', ' ', ' ', ' ', ' ', ' ', ' '],
          ['b', ' ', ' ', ' ', ' ', ' ', ' '],
          ['b', ' ', ' ', ' ', ' ', ' ', ' '],
          ['b', ' ', ' ', ' ', ' ', ' ', ' ']
        ]
      end

      xit 'declares player winner' do
        expect(game).to receive(:puts).with("'#{game.player_marker}' wins!")
      end
    end

    context 'second_player wins' do
      before do
        game.second_marker = 'j'
        game.board = [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['j', ' ', ' ', ' ', ' ', ' ', ' '],
          ['j', ' ', ' ', ' ', ' ', ' ', ' '],
          ['j', ' ', ' ', ' ', ' ', ' ', ' '],
          ['j', ' ', ' ', ' ', ' ', ' ', ' ']
        ]
      end

      xit 'declares player winner' do
        expect(game).to receive(:puts).with("'#{game.second_marker}' wins!")
      end
    end

    xit 'prompts new game' do
      # no test needed
    end
  end

  # describe '#display_result' do
  #   xit 'displays result' do
  #     # no test needed
  #   end
  # end

  describe '#prompt_new_game' do
    before do
      valid_input = 'n'
      allow(game).to receive(:print).with('Would you like to play again? y/n: ')
      allow(game).to receive(:gets).and_return(valid_input)
      allow(game).to receive(:verify_new_game_input).and_return(valid_input)
    end

    xit 'prompts player for new game' do
      expect(game).to receive(:print).with('Would you like to play again? y/n: ')
      expect(game).to receive(:gets).and_return(valid_input)
      expect(game).to receive(:verify_new_game_input).and_return(valid_input)
      game.select_move
    end
  end

  describe '#verify_new_game_input' do
    context 'when given valid input (lowercase)' do
      xit 'returns input' do
        valid_input = 'n'
        expect(game.verify_new_game_input(valid_input)).to be(valid_input)
        game.verify_new_game_input(valid_input)
      end
    end

    context 'when given valid input (uppercase)' do
      xit 'returns input' do
        valid_input = 'N'
        expect(game.verify_new_game_input(valid_input)).to be(valid_input)
        game.verify_new_game_input(valid_input)
      end
    end

    context 'when given invalid input' do
      before do
        allow(game).to receive(:puts).with('Invalid input!').once
        allow(game).to receive(:prompt_new_game).once
      end

      xit 'prompts player for new input' do
        valid_input = 'b'
        expect(game).to receive(:puts).with('Invalid input!').once
        expect(game).to receive(:prompt_new_game).once
        game.verify_new_game_input(valid_input)
      end
    end
  end
end
