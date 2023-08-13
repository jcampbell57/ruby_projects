# frozen_string_literal: true

# spec/game_spec.rb
require './lib/game'

describe Game do
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

    xit 'prompts player for mode' do
      expect(game).to receive(:print).with('Input 1 for single player or 2 for multiplayer: ').once
      game.select_mode
      expect(game.mode).to_be(mode_selection)
    end
  end

  describe '#verify_mode' do
    context 'when given valid input' do
      xit 'returns input' do
        valid_input = 1
        expect(game.verify_mode(valid_input)).to_return(valid_input)
        game.verify_mode(valid_input)
      end
    end

    context 'when given invalid input' do
      before do
        valid_input = 1
        allow(game).to receive(:puts).with('Invalid input!').once
        allow(game).to receive(:select_mode).once
        allow(game).to receive(:gets).and_return(valid_input.to_s)
      end

      xit 'prompts player for new input' do
        invalid_input = 'b'
        expect(game).to receive(:puts).with('Invalid input!').once
        expect(game).to receive(:select_mode).once
        expect(game).to receive(:gets).and_return(valid_input)
        game.verify_mode(invalid_input)
        expect(game.mode).to_be(valid_input)
      end
    end
  end

  describe '#game_loop' do
    context 'when game_over? is true' do
      before do
        # set board
        allow(game).to receive(:end_game)
      end

      xit 'ends game' do
        expect(game).to receive(:end_game)
        game.game_loop
      end
    end

    context 'when game_over? is false' do
      xit 'loops' do
        expect(game).to receive(:loop)
      end
    end
  end

  describe '#display_board' do
    xit 'displays board' do
      # no test needed
    end
  end

  describe '#select_move' do
    xit 'prompts player for move' do
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
      xit 'returns input' do
        valid_input = 4
        expect(game.verify_move(valid_input)).to_return(valid_input.to_s)
        game.verify_move
      end
    end

    context 'when given invalid input' do
      xit 'prompts player for new input' do
        valid_input = 4
        invalid_input = 'b'
        expect(game).to receive(:puts).with('Invalid input!').once
        expect(game).to receive(:select_move).once
        expect(game).to receive(:gets).and_return(valid_input.to_s)
        game.verify_move(invalid_input)
        expect(game.verify_move).to_return(valid_input)
      end
    end
  end

  describe '#game_over?' do
    context 'when game is over' do
      before do
        game.player_marker = 'X'
        game.board = [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['X', ' ', ' ', ' ', ' ', ' ', ' '],
          ['X', ' ', ' ', ' ', ' ', ' ', ' '],
          ['X', ' ', ' ', ' ', ' ', ' ', ' '],
          ['X', ' ', ' ', ' ', ' ', ' ', ' ']
        ]
      end

      xit 'returns true' do
        expect(game.game_over?).to_return(true)
        game.game_over?
      end
    end

    context 'when game is not over' do
      xit 'returns false' do
        expect(game.game_over?).to_return(false)
        game.game_over?
      end
    end
  end

  describe '#end_game' do
    xit 'displays result' do
      # no test needed
    end

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

  describe '#display_result' do
    xit 'displays result' do
      # no test needed
    end
  end

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
        expect(game.verify_new_game_input(valid_input)).to_return(valid_input)
        game.verify_new_game_input(valid_input)
      end
    end

    context 'when given valid input (uppercase)' do
      xit 'returns input' do
        valid_input = 'N'
        expect(game.verify_new_game_input(valid_input)).to_return(valid_input)
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
