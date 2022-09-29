string = "What a string!"

def caesar_cipher(string, shift = 5)

  new_string = []
  a = string.split('')

  b = a.each do |letter|
    if letter.ord.between?(97, 122)
      if letter.ord + shift > 122
        new_letter = (((letter.ord + shift) % 122) + 97).chr
        new_string << new_letter
        p new_string
      else
        new_letter = (letter.ord + shift).chr
        new_string << new_letter
        p new_string
      end

    elsif letter.ord.between?(65, 90)
      if letter.ord + shift > 90
        new_letter = (((letter.ord + shift) % 90) + 64).chr
        new_string << new_letter
        p new_string
      else
        new_letter = (letter.ord + shift).chr
        new_string << new_letter
       p new_string
      end

    else
      new_string << letter
    end
  end

  new_string.join
end

p caesar_cipher(string)

# p 'a'.ord
# p 'z'.ord
# p 'A'.ord
# p 'Z'.ord