# frozen_string_literal: true

# spec/game_spec.rb
require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#play' do
    xit 'sets game.mode' do
      expect(game)
    end

    xit 'starts game_loop' do
      expect(game)
    end
  end

  describe '#select_mode' do
    xit 'prompts player for mode' do
      expect(game)
    end
  end

  describe '#verify_mode' do
    context 'when given valid input' do
      xit 'returns input' do
        expect(game)
      end
    end

    context 'when given invalid input' do
      xit 'prompts player for new input' do
        expect(game)
      end
    end
  end

  describe '#game_loop' do
    xit 'loops until game is over' do
      expect(game)
    end
  end

  describe '#display_board' do
    xit 'displays board' do
      # no test needed
    end
  end

  describe '#select_move' do
    xit 'prompts player for move' do
      expect(game)
    end
  end

  describe '#verify move' do
    context 'when given valid input' do
      xit 'returns input' do
        expect(game)
      end
    end

    context 'when given invalid input' do
      xit 'prompts player for new input' do
        expect(game)
      end
    end
  end

  describe '#game_over?' do
    context 'when game is over' do
      xit 'returns true' do
        expect(game)
      end
    end

    context 'when game is not over' do
      xit 'returns false' do
        expect(game)
      end
    end
  end

  describe '#display_result' do
    xit 'displays result' do
      # no test needed
    end
  end

  describe '#prompt_new_game' do
    xit 'prompts player for new game' do
      expect(game)
    end
  end

  describe '#verify_new_game_input' do
    context 'when given valid input' do
      xit 'returns input' do
        expect(game)
      end
    end

    context 'when given invalid input' do
      xit 'prompts player for new input' do
        expect(game)
      end
    end
  end
end
