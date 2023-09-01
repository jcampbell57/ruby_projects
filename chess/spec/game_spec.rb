# frozen_string_literal: true

# spec/game_spec.rb
require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#create_pieces' do
    context 'when called' do
      it 'creates 32 game pieces' do
        expect(game.pieces).to be(nil)
        game.pieces = game.create_pieces
        expect(game.pieces.size).to be(32)
      end
    end
  end

  # not working
  # describe '#process_move(input)' do
  #   context "when given valid input (ex: 'd4')" do
  #     it 'returns array including piece' do
  #       input = 'd4'
  #       allow(input).to receive(:delete_suffix!).with('+')
  #       expect(game.process_move(input)).to_return([game.board.pieces.find(piece.position == [3, 6]), 3, 4])
  #     end
  #   end
  # end

  describe '#place_piece(input_array)' do
    context 'when given valid input array' do
      before do
        game.pieces = game.create_pieces
      end

      it 'changes piece position' do
        piece = game.pieces.find { |board_piece| board_piece.position == [3, 6] }
        input_array = [piece, 3, 4]
        expect { game.place_piece(input_array) }.to change(piece, :position)
      end
    end
  end

  describe '#eliminate_piece(piece)' do
    context 'when given a piece' do
      before do
        game.pieces = game.create_pieces
      end

      it 'changes piece position to nil' do
        piece = game.pieces.find { |board_piece| board_piece.position == [3, 6] }
        # input_array = [piece, 3, 4]
        expect { game.eliminate_piece(piece) }.to change(piece, :position).to(nil)
      end
    end
  end
end
