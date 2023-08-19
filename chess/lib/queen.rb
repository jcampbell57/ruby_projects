# frozen_string_literal: true

# lib/queen.rb
class Queen
  def initialize; end

  def possible_moves(square, coordinates)
    possibilities = []
    8.times do |i|
      possibilities << [square[0] + i, square[1] + i]
      possibilities << [square[0] - i, square[1] + i]
      possibilities << [square[0] + i, square[1] - i]
      possibilities << [square[0] - i, square[1] - i]
      possibilities << [square[0] + i, square[1]]
      possibilities << [square[0] - i, square[1]]
      possibilities << [square[0], square[1] + i]
      possibilities << [square[0], square[1] - i]
    end
    confirmed = []
    possibilities.each do |possibility|
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end
end
