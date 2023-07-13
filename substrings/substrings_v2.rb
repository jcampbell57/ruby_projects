dictionary = %w[below down go going horn how howdy it i low own part partner sit]

def substrings(string, dictionary)
  substrings = Hash.new(0)
  split_string = string.split(' ')
  split_string.each do |user_word|
    dictionary.each do |dictionary_word|
      substrings[dictionary_word] += 1 if user_word.include?(dictionary_word)
    end
  end
  substrings
end

puts substrings('below', dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
