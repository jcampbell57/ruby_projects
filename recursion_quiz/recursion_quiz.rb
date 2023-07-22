def collatz(n, counter = 0)
  if n == 1
    puts "collatz steps to 1: #{counter}"
  elsif n.even?
    counter += 1
    collatz((n / 2), counter)
  else
    counter += 1
    collatz((n * 3 + 1), counter)
  end
end
collatz(27)  # 111

def factorial_of(n, counter = n)
  if counter == 1
    puts n
  else
    factorial_of(n * counter -= 1, counter)
  end
end
factorial_of(14) # 87178291200

# mine (not even recursive lol)
def palindrome?(str)
  str.downcase.reverse == str.downcase
end

def palindrome?(str)
  if str.length == 1 || str.length == 0
    true
  elsif str[0].downcase == str[-1].downcase
    palindrome?(str[1..-2])
  else
    false
  end
end
p palindrome?('Racecar') # true

def milk_bottles(n)
  if n == 0
    puts 'No more bottles of milk on the wall.'
  elsif n == 1
    puts "#{n} bottle of milk on the wall."
    milk_bottles(n - 1)
  else
    puts "#{n} bottles of milk on the wall."
    milk_bottles(n - 1)
  end
end
milk_bottles(10)

# mine
def fib(n, fib_array = [0, 1])
  if fib_array[n].nil?
    fib_array << fib_array[-2] + fib_array[-1]
    fib(n, fib_array)
  else
    fib_array[n]
  end
end

# better version
def fib(n)
  if n == 0
    0
  elsif n == 1
    1
  else
    fib(n - 1) + fib(n - 2)
  end
end
fib(6) # 8

def my_flatten(array)
  new_array = []
  array.each do |item|
    if item.is_a?(Array)
      my_flatten(item).each do |item|
        new_array << item
      end
    else
      new_array << item
    end
  end
  new_array
end
p my_flatten([[1, 2], [3, 4]]) # [1, 2, 3, 4]
p my_flatten([[1, [8, 9]], [3, 4]]) # [1, 8, 9, 3, 4]

roman_mapping = {
  1000 => 'M',
  900 => 'CM',
  500 => 'D',
  400 => 'CD',
  100 => 'C',
  90 => 'XC',
  50 => 'L',
  40 => 'XL',
  10 => 'X',
  9 => 'IX',
  5 => 'V',
  4 => 'IV',
  1 => 'I'
}

# my way
def integer_to_roman_numeral(integer, roman_mapping, conversion = '')
  roman_mapping.each do |k, v|
    next unless integer / k >= 1

    (integer / k).times { conversion << v }
    integer_to_roman_numeral(integer % k, roman_mapping, conversion)
    break
  end
  conversion
end
p integer_to_roman_numeral(1900, roman_mapping)

# my way
def roman_numeral_to_integer(numeral, roman_mapping, conversion = 0)
  if numeral.empty?
    conversion
  elsif numeral.split('').size == 1
    conversion += roman_mapping.key(numeral)
    conversion
  elsif roman_mapping.key(numeral[0]) < roman_mapping.key(numeral[1])
    conversion += roman_mapping.key(numeral[1]) - roman_mapping.key(numeral[0])
    roman_numeral_to_integer(numeral[2..-1], roman_mapping, conversion)
  else
    conversion += roman_mapping.key(numeral[0])
    roman_numeral_to_integer(numeral[1..-1], roman_mapping, conversion)
  end
end
p roman_numeral_to_integer('MCM', roman_mapping)

#  their way

def roman_to_integer(roman_mapping, str, result = 0)
  return result if str.empty?

  roman_mapping.keys.each do |roman|
    next unless str.start_with?(roman)

    result += roman_mapping[roman]
    str = str.slice(roman.length, str.length)
    return roman_to_integer(roman_mapping, str, result)
  end
end
