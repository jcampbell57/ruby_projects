# frozen_string_literal: true

# spec/tictactoe_v2_spec.rb
require './lib/tictactoe_v2'

describe Game do
  # Cant seem to get initialize method to stop calling prompt_mode
  # subject(:game) { described_class.new }
  subject(:game) do
    described_class.new(%w[1 2 3 4 5 6 7 8 9],
                        [1, 2, 3, 4, 5, 6, 7, 8, 9],
                        1,
                        'X')
  end

  describe '#initialize' do
    # no test needed?
  end

  describe '#prompt_mode' do
    # no test needed?
  end

  describe '#validate_mode_input' do
    # recursively calls itself until valid input is entered
    context 'when valid input given' do
      it 'returns input' do
        valid_input = 1
        expect(game.validate_mode_input(valid_input)).to eq(valid_input)
        game.validate_mode_input(valid_input)
      end
    end

    context 'when invalid input given once' do
      before do
        valid_input = '2'
        allow(game).to receive(:gets).and_return(valid_input)
        allow(game).to receive(:puts).with("please enter '1' or '2' for number of players").once
      end

      it 'displays error once' do
        invalid_number = 4
        expect(game).to receive(:puts).with("please enter '1' or '2' for number of players").once
        game.validate_mode_input(invalid_number)
      end

      it 'calls itself once' do
        invalid_input = 4
        expect(game).to receive(:validate_mode_input).once
        game.validate_mode_input(invalid_input)
      end

      it 'returns valid input' do
        invalid_input = 4
        result = game.validate_mode_input(invalid_input)
        expect(result).to be(2)
      end
    end

    context 'when invalid input given twice' do
      before do
        invalid_letter = 'j'
        valid_input = '2'
        allow(game).to receive(:gets).and_return(invalid_letter, valid_input)
        allow(game).to receive(:puts).with("please enter '1' or '2' for number of players").twice
      end

      it 'displays error twice' do
        invalid_number = 4
        expect(game).to receive(:puts).with("please enter '1' or '2' for number of players").twice
        game.validate_mode_input(invalid_number)
      end

      # I'm not actually sure what this is doing
      it 'calls itself three times (once for the correct input)' do
        invalid_number = 4
        expect(game).to receive(:validate_mode_input).exactly(3).times.and_call_original
        game.validate_mode_input(invalid_number)
      end

      it 'returns valid input' do
        invalid_number = 4
        result = game.validate_mode_input(invalid_number)
        expect(result).to be(2)
      end
    end
  end

  describe '#prompt_player_move' do
    # no test needed?
  end

  describe '#process_move' do
    xit '' do
    end
  end

  describe '#computer_move' do
    xit '' do
    end
  end

  describe '#validate_player_move' do
    xit '' do
    end
  end

  describe '#display_board' do
    xit '' do
    end
  end

  describe '#set_marker' do
    xit '' do
    end
  end

  describe '#winner_declared?' do
    xit '' do
    end
  end

  describe '#winner?' do
    xit '' do
    end
  end
end
