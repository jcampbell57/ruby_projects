# frozen_string_literal: true

# lib/bishop.rb
class Bishop
  def initialize; end

  def possible_moves(square, coordinates)
    possibilities = []
    8.times do |i|
      possibilities << [square[0] + i, square[1] + i]
      possibilities << [square[0] - i, square[1] + i]
      possibilities << [square[0] + i, square[1] - i]
      possibilities << [square[0] - i, square[1] - i]
    end
    confirmed = []
    possibilities.each do |possibility|
      coordinates.include?(possibility) ? confirmed << possibility : next
    end
    confirmed
  end
end
