def stock_picker(array)
  pick = {}

  pick[:buy] = []
  pick[:buy][0] = 0
  pick[:buy][1] = array[0]

  pick[:sell] = []
  pick[:sell][0] = 1
  pick[:sell][1] = array[1]

  profit = pick[:sell][1] - pick[:buy][1]

  array.each_with_index do |price, index|
    next if index.zero?

    next unless (price - pick[:buy][1]) >= profit

    pick[:buy] = pick[:sell] if pick[:sell][1] < pick[:buy][1]
    pick[:sell] = [index, price]
    profit = pick[:sell][1] - pick[:buy][1]
  end
  puts "[#{pick[:buy][0]},#{pick[:sell][0]}]  # for a profit of $#{pick[:sell][1]} - $#{pick[:buy][1]} == $#{profit}"
end

stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
