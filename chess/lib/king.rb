# frozen_string_literal: true

# lib/king.rb
class King
  def initialize; end

  def possible_moves(square, coordinates)
    possibilities = [
      [square[0] + i, square[1] + i],
      [square[0] - i, square[1] + i],
      [square[0] + i, square[1] - i],
      [square[0] - i, square[1] - i],
      [square[0] + i, square[1]],
      [square[0] - i, square[1]],
      [square[0], square[1] + i],
      [square[0], square[1] - i]
    ]
    confirmed = []
    possibilities.each do |possibility|
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end
end
