def stock_picker(num_array)
  profit = 0
  best_choice = []
  num_array.each_with_index do |num1, index1|
    num_array.each_with_index do |num2, index2|
      unless index1 >= index2
        result = num2 - num1
        if result > profit
          # p "old profit: #{profit}"
          # p "new result: #{result}"
          profit = result
          best_choice[0] = [index1, index2]
          best_choice[1] = [num1, num2]
        end
      end
    end
  end
  p "the best choiice is #{best_choice[0]} for a profit of #{best_choice[1][1]} - #{best_choice[1][0]} == #{profit}"
end
 
stock_picker([17,3,6,9,15,8,6,1,10])