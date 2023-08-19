# frozen_string_literal: true

# lib/pawn.rb
class Pawn
  def initialize; end

  def possible_moves(square, coordinates)
    possibilities = []
    possibilities << [square[0], square[1] + 1] if color == 'white'
    possibilities << [square[0], square[1] - 1] if color == 'black'
    possibilities << [square[0], square[1] + 2] if square[1] == 6 && color == 'white'
    possibilities << [square[0], square[1] - 2] if square[1] == 1 && color == 'black'

    # fix these
    # possibilities << [square[0] + 1, square[1] + 1] if 'capture available' && color == 'white'
    # possibilities << [square[0] - 1, square[1] + 1] if 'capture available' && color == 'white'
    # possibilities << [square[0] + 1, square[1] + 1] if 'capture available' && color == 'black'
    # possibilities << [square[0] - 1, square[1] + 1] if 'capture available' && color == 'black'

    confirmed = []
    possibilities.each do |possibility|
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end
end
