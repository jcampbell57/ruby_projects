# frozen_string_literal: true

# spec/tictactoe_v2_spec.rb
require './lib/tictactoe_v2'

describe Game do
  subject(:game) do
    described_class.new(%w[1 2 3 4 5 6 7 8 9],
                        [1, 2, 3, 4, 5, 6, 7, 8, 9],
                        1,
                        'X')
  end

  describe '#initialize' do
    # no test needed?
  end

  describe '#prompt_player_move' do
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

      # I'm not actually sure exactly how this works
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

  describe '#process_move' do
    context 'when called' do
      before do
        allow(game).to receive(:computer_move)
        allow(game).to receive(:prompt_player_move)
      end

      it 'places marker on board' do
        valid_input = 5
        expect { game.process_move(valid_input) }.to change { game.board[valid_input - 1] }.to(game.marker)
      end

      it 'switches marker' do
        valid_input = 5
        original_marker = game.marker
        game.process_move(valid_input)
        expect(game.marker).not_to eq(original_marker)
      end
    end
    context 'when winner_declared?' do
      before do
        # allow(game).to receive(:computer_move)
        # allow(game).to receive(:prompt_player_move)
        allow(game).to receive(:winner_declared?).and_return(true)
        allow(Game).to receive(:new).and_return(game) # Stub Game.new to return the same game instance
      end

      it 'calls Game.new.prompt_player_move' do
        valid_input = 5
        expect(game).to receive(:prompt_player_move).once
        # expect(game).to receive(:computer_move).twice
        game.process_move(valid_input)
      end
    end
    context 'when game is not over' do
      before do
        allow(game).to receive(:computer_move)
        allow(game).to receive(:prompt_player_move)
      end

      it 'removes input from computer options' do
        valid_input = 5
        expect { game.process_move(valid_input) }.to change {
                                                       game.computer_options
                                                     }.to(game.computer_options - [valid_input])
        game.process_move(valid_input)
      end
    end
    context "when it is the computer's turn" do
      before do
        allow(game).to receive(:computer_move)
        allow(game).to receive(:prompt_player_move)
      end

      it 'calls computer_move' do
        valid_input = 5
        expect(game).to receive(:computer_move)
        game.process_move(valid_input)
      end
    end
    context "when it is not the computer's turn" do
      before do
        allow(game).to receive(:prompt_player_move)
        game.mode = 2
      end

      it 'calls prompt_player_move' do
        valid_input = 5
        expect(game).to receive(:prompt_player_move)
        game.process_move(valid_input)
      end
    end
  end

  describe '#computer_move' do
    let(:computer_choice) { 5 } # Choose a specific computer choice for testing

    before do
      allow(game).to receive(:computer_options).and_return([computer_choice])
      allow(game).to receive(:process_move)
      allow(game).to receive(:sleep)
    end

    it 'prints the computer choice' do
      expect { game.computer_move }.to output(/Computer chooses... #{computer_choice}/).to_stdout
    end

    it 'calls process_move with the computer choice' do
      expect(game).to receive(:process_move).with(computer_choice)
      game.computer_move
    end
  end

  describe '#validate_player_move' do
    context 'when given a valid input' do
      context 'when space not taken' do
        it 'returns input' do
          valid_input = 5
          result = game.validate_player_move(valid_input)
          expect(result).to eq(valid_input)
        end
      end

      context 'when space taken' do
        before do
          game.board[4] = 'X'
          allow(game).to receive(:gets).and_return('4')
        end

        it 'prompts for a new input' do
          valid_input = 5
          expect { game.validate_player_move(valid_input) }.to output("That spot is taken, pick again!\n").to_stdout
          expect(game).to receive(:gets).and_return('4')
          expect(game.validate_player_move(valid_input)).to eq(4)
        end
      end
    end

    context 'when given an invalid input' do
      before do
        allow(game).to receive(:gets).and_return('4')
      end

      it 'prompts for a new input' do
        invalid_input = 'b'
        expect { game.validate_player_move(invalid_input) }.to output("You must enter a space number 1-9.\n").to_stdout
        expect(game).to receive(:gets).and_return('4')
        expect(game.validate_player_move(invalid_input)).to eq(4)
      end
    end
  end

  describe '#display_board' do
    # no test needed
  end

  describe '#set_marker' do
    context "When checking 'O'" do
      it "changes to 'X'" do
        game.marker = 'O'
        expect { game.set_marker }.to change { game.marker }.from('O').to('X')
      end
    end

    context "When checking 'X'" do
      it "changes to 'O'" do
        game.marker = 'X'
        expect { game.set_marker }.to change { game.marker }.from('X').to('O')
      end
    end
  end

  describe '#winner_declared?' do
    before do
      allow(game).to receive(:display_board)
    end
    context "when 'X' wins" do
      it "display board, puts 'X wins!' and returns true" do
        game.board = %w[1 2 3 X X X 7 8 9]
        expect { game.winner_declared? }.to output("X wins!\n").to_stdout
        expect(game).to receive(:display_board).once
        expect(game.winner_declared?).to be(true)
      end
    end

    context "when 'O' wins" do
      it "puts 'O wins!' and returns true" do
        game.board = %w[1 2 3 O O O 7 8 9]
        expect { game.winner_declared? }.to output("O wins!\n").to_stdout
        expect(game).to receive(:display_board).once
        expect(game.winner_declared?).to be(true)
      end
    end

    context 'when its a tie' do
      it "puts It's a tie!' and returns true" do
        game.board = %w[X X O O O X X O X]
        expect { game.winner_declared? }.to output("It's a tie!\n").to_stdout
        expect(game).to receive(:display_board).once
        expect(game.winner_declared?).to be(true)
      end
    end

    context 'when game is not over' do
      it 'returns false' do
        game.board = %w[1 2 3 X O X 7 8 9]
        expect(game.winner_declared?).to be(false)
      end
    end
  end

  describe '#winner?' do
    context 'winning game' do
      before do
        game.board = %w[X X X X X X X X X]
      end
      context 'winning marker' do
        context 'when checking in spots [0, 1, 2]' do
          it 'returns true' do
            expect(game.winner?([0, 1, 2], 'X')).to be(true)
          end
        end

        context 'when checking in spots [3, 4, 5]' do
          it 'returns true' do
            expect(game.winner?([3, 4, 5], 'X')).to be(true)
          end
        end

        context 'when checking in spots [6, 7, 8]' do
          it 'returns true' do
            expect(game.winner?([6, 7, 8], 'X')).to be(true)
          end
        end

        context 'when checking in spots [0, 3, 6]' do
          it 'returns true' do
            expect(game.winner?([0, 3, 6], 'X')).to be(true)
          end
        end

        context 'when checking in spots [1, 4, 7]' do
          it 'returns true' do
            expect(game.winner?([1, 4, 7], 'X')).to be(true)
          end
        end

        context 'when checking in spots [2, 5, 8]' do
          it 'returns true' do
            expect(game.winner?([2, 5, 8], 'X')).to be(true)
          end
        end

        context 'when checking in spots [0, 4, 8]' do
          it 'returns true' do
            expect(game.winner?([0, 4, 8], 'X')).to be(true)
          end
        end

        context 'when checking in spots [2, 4, 6]' do
          it 'returns true' do
            expect(game.winner?([2, 4, 6], 'X')).to be(true)
          end
        end
      end

      context 'losing marker' do
        context 'when checking in spots [0, 1, 2]' do
          it 'returns false' do
            expect(game.winner?([0, 1, 2], 'O')).to be(false)
          end
        end

        context 'when checking in spots [3, 4, 5]' do
          it 'returns false' do
            expect(game.winner?([3, 4, 5], 'O')).to be(false)
          end
        end

        context 'when checking in spots [6, 7, 8]' do
          it 'returns false' do
            expect(game.winner?([6, 7, 8], 'O')).to be(false)
          end
        end

        context 'when checking in spots [0, 3, 6]' do
          it 'returns false' do
            expect(game.winner?([0, 3, 6], 'O')).to be(false)
          end
        end

        context 'when checking in spots [1, 4, 7]' do
          it 'returns false' do
            expect(game.winner?([1, 4, 7], 'O')).to be(false)
          end
        end

        context 'when checking in spots [2, 5, 8]' do
          it 'returns false' do
            expect(game.winner?([2, 5, 8], 'O')).to be(false)
          end
        end

        context 'when checking in spots [0, 4, 8]' do
          it 'returns false' do
            expect(game.winner?([0, 4, 8], 'O')).to be(false)
          end
        end

        context 'when checking in spots [2, 4, 6]' do
          it 'returns false' do
            expect(game.winner?([2, 4, 6], 'O')).to be(false)
          end
        end
      end
    end

    context 'losing game' do
      before do
        game.board = %w[b r a n d i r o x]
      end

      context 'when checking in spots [0, 1, 2]' do
        it 'returns false' do
          expect(game.winner?([0, 1, 2], 'O')).to be(false)
        end
      end

      context 'when checking in spots [3, 4, 5]' do
        it 'returns false' do
          expect(game.winner?([3, 4, 5], 'O')).to be(false)
        end
      end

      context 'when checking in spots [6, 7, 8]' do
        it 'returns false' do
          expect(game.winner?([6, 7, 8], 'O')).to be(false)
        end
      end

      context 'when checking in spots [0, 3, 6]' do
        it 'returns false' do
          expect(game.winner?([0, 3, 6], 'O')).to be(false)
        end
      end

      context 'when checking in spots [1, 4, 7]' do
        it 'returns false' do
          expect(game.winner?([1, 4, 7], 'O')).to be(false)
        end
      end

      context 'when checking in spots [2, 5, 8]' do
        it 'returns false' do
          expect(game.winner?([2, 5, 8], 'O')).to be(false)
        end
      end

      context 'when checking in spots [0, 4, 8]' do
        it 'returns false' do
          expect(game.winner?([0, 4, 8], 'O')).to be(false)
        end
      end

      context 'when checking in spots [2, 4, 6]' do
        it 'returns false' do
          expect(game.winner?([2, 4, 6], 'O')).to be(false)
        end
      end
    end
  end
end
