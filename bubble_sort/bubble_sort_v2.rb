def bubble_sort(array)
  (array.size - 1).times do
    array.each_with_index do |number, index|
      next if array[index + 1].nil?

      if number > array[index + 1]
        array[index] = array[index + 1]
        array[index + 1] = number
      end
    end
  end
  array
end

bubble_sort([4, 3, 78, 2, 0, 2])
