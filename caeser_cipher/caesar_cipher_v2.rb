def caeser_cipher(string, shift_factor = 5)
  split_string_array = string.split('')
  new_string_array = []

  split_string_array.each do |value|
    # handle lower case letters
    if value.ord.between?(97, 122)
      value = if value.ord + shift_factor > 122
                (value.ord + shift_factor - 26).chr
              else
                (value.ord + shift_factor).chr
              end
    # handle upper case letters
    elsif value.ord.between?(65, 90)
      value = if value.ord + shift_factor > 90
                (value.ord + shift_factor - 26).chr
              else
                (value.ord + shift_factor).chr
              end
    end
    new_string_array << value
  end
  new_string_array.join
end

p caeser_cipher('What a string!')
