words = "Howdy partner, sit down! How's it going?"
 
dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
 
def substrings (words, dictionary)
  matches = Hash.new
  dictionary.each do |dictionary_word|
    count = 0
    words.downcase.split(' ').each do |given_word|
      if given_word.include?(dictionary_word)
        count += 1
        matches[dictionary_word] = count
      end
    end
  end
  p matches
end
 
substrings("below", dictionary)
substrings(words, dictionary)