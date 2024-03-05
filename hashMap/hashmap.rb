# frozen_string_literal: true

require_relative '../linked_list/lib/linked_list'

class HashMap
  attr_accessor :buckets

  def initialize(initial_size = 16, load_factor = 0.75)
    @buckets = Array.new(initial_size) { LinkedList.new }
    @load_factor = load_factor
    @initial_size = initial_size
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def capacity
    @buckets.length
  end

  def load_factor_exceeded?
    (length / capacity) >= @load_factor
  end

  def rehash
    current_entries = entries
    @buckets = Array.new(capacity * 2) { LinkedList.new }
    current_entries.each { |entry| set(entry[0], entry[1]) }
  end

  def set(key, value)
    index = hash(key) % capacity
    @buckets[index].append([key, value])
    rehash if load_factor_exceeded?
  end

  def get(key)
    index = hash(key) % capacity
    return nil if @buckets[index].head.nil?

    node = @buckets[index].head
    while node
      return node.value[1] if node.value[0] == key

      node = node.next_node
    end
  end

  def has(key)
    index = hash(key) % capacity
    return false if @buckets[index].head.nil?

    node = @buckets[index].head
    while node
      return true if node.value[0] == key

      node = node.next_node
    end
    false
  end

  def remove(key)
    index = hash(key) % capacity
    return nil if @buckets[index].head.nil?

    node = @buckets[index].head
    i = 0

    while node
      if node.value[0] == key
        @buckets[index].remove_at(i)
        break
      else
        i += 1
        node = node.next_node
      end
    end
  end

  def length
    count = 0
    @buckets.each do |x|
      current_node = x.head
      next if current_node.nil?

      count += 1
      while current_node.next_node
        count += 1
        current_node = current_node.next_node
      end
    end
    count
  end

  def clear
    @buckets = Array.new(@initial_size) { LinkedList.new }
  end

  def keys
    all_keys = []
    @buckets.each do |bucket|
      next if bucket.head.nil?

      current_node = bucket.head
      while current_node
        all_keys << current_node.value[0]
        current_node = current_node.next_node
      end
    end
    all_keys
  end

  def values
    all_values = []
    @buckets.each do |bucket|
      next if bucket.head.nil?

      current_node = bucket.head
      while current_node
        all_values << current_node.value[1]
        current_node = current_node.next_node
      end
    end
    all_values
  end

  def entries
    all_entries = []
    @buckets.each do |bucket|
      next if bucket.head.nil?

      current_node = bucket.head
      while current_node
        all_entries << current_node.value
        current_node = current_node.next_node
      end
    end
    all_entries
  end
end
