array = [4,3,78,2,0,2]

def bubble_sort(array)
  finished = false 
  sort_results = []
  while finished == false
    array.each_with_index do |number, index|
      unless array[index + 1] == nil
        if array[index] > array[index + 1]
            array[index], array[index + 1] = array[index + 1], array[index]
            sort_results << 1
        else 
            sort_results << -1
        end
      else
        if sort_results.all? { |num| num == -1 }
            finished = true
        end 
        # p 'sort results:'
        # p sort_results
        sort_results = []
      end
    end
  end
  p array
end
 
bubble_sort(array)