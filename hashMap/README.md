# Ruby Implementation of HashMap

I had a difficult time with this assignment, so I looked at a lot of examples while putting together my solution. I tried to create the best solution I could from the examples to use as a reference moving forward. 

Project description can be found here:
- https://www.theodinproject.com/lessons/ruby-hashmap

I found this example especially helpful to review:
- https://github.com/odilsoncode/hashmap/blob/main/hashmap.rb#L49-L64

## Usage Example 

```
# Create a new HashMap
test_hash_map = HashMap.new

# Set key-value pairs
test_hash_map.set('year', 2021)
test_hash_map.set('make', 'Subaru')
test_hash_map.set('model', 'WRX')

# Retrieve values
puts "year: #{test_hash_map.get('year')}"
puts "make: #{test_hash_map.get('make')}"
puts "model: #{test_hash_map.get('model')}"

# Display all keys, values, and entries
puts "All Keys: #{test_hash_map.keys}"
puts "All Values: #{test_hash_map.values}"
puts "All Entries: #{test_hash_map.entries}"

# Returns true or false based on whether or not the key is in the hash map
puts "Hash has key 'year'?: #{test_hash_map.has('year')}"
puts "Hash has key 'make'?: #{test_hash_map.has('make')}"
puts "Hash has key 'model'?: #{test_hash_map.has('model')}"
puts "Hash has key 'modifications'?: #{test_hash_map.has('modifications')}"

# Returns the number of stored keys in the hash map
puts "Current length is #{test_hash_map.length}"

test_hash_map.remove('year')
puts "After removing one, the length is #{test_hash_map.length}"
puts "test_hash_map.get('year'): #{test_hash_map.get('year')}"
puts "test_hash_map.has('year'): #{test_hash_map.has('year')}"
puts "Keys: #{test_hash_map.keys}"

# removes all entries in the hash map.
test_hash_map.clear

puts "After clearing the hash, the length is #{test_hash_map.length}"
puts "Keys: #{test_hash_map.keys}"
```