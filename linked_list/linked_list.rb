# frozen_string_literal: true

# node class
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    self.value = value
    self.next_node = next_node
  end
end

# linkedlist class
class LinkedList
  attr_accessor :head, :tail, :size

  def initialize(head = nil, tail = nil)
    self.head = head
    self.tail = tail
    self.size = 0
  end

  def append(value)
    # if empty, make head
    if head.nil?
      tail.next_node = node
    else
      node = Node.new(value)
      tail.next_node = node
      self.tail = node
    end
    self.size += 1
  end

  def prepend(value)
    node = Node.new(value, head)
    # if empty, make tail
    self.tail = node if head.nil?
    self.head = node
    self.size += 1
  end

  def at(index)
    current = head
    # handle negative
    if index.negative?
      (self.size + index).times { current = current.next_node }
    else
      (index - 1).times { current = current.next_node }
    end
    current.value
  end

  def pop
    old_value = tail.value
    current = head
    (self.size - 2).times { current = current.next_node }
    current.next_node = nil
    self.tail = current
    self.size -= 1
    old_value
  end

  def contains?(value)
    current = head
    size.times do
      return true if current.value == value

      current = current.next_node
    end
    false
  end

  def find(value)
    current = head
    size.times do
      return current if current.value == value

      current = current.next_node
    end
    nil
  end

  def to_s
    current = head
    new_string = ''
    size.times do
      new_string += "#{current.value}"
      new_string += ' -> '
      current = current.next_node.nil? ? nil : current.next_node
    end
    new_string += 'nil'
  end

  # extra credit

  def insert_at(value, index)
    # handle index 0
    if index.zero?
      prepend(value)
    # if at end, add to tail
    elsif index == (self.size)
      append(value)
    # cancel if out of range
    elsif index > self.size || (index * 1) > self.size
    # do nothing
    # handle new index
    else
      insert_node(value, index)
    end
  end

  def insert_node(value, index)
    node = Node.new(value)
    current = head
    # handle negative
    if index.negative?
      (self.size + index).times { current = current.next_node }
    else
      (index - 1).times { current = current.next_node }
    end
    node.next_node = current.next_node
    current.next_node = node
    self.size += 1
  end

  def remove_at(index)
    # handle index 0
    if index.zero?
      self.head = head.next_node
      self.size -= 1
    # if at end, change tail
    elsif index == (self.size - 1)
      pop
    # cancel if out of range
    elsif index > self.size || (index * 1) > self.size
    # do nothing
    # handle middle index
    else
      remove_node(index)
    end
  end

  def remove_node(index)
    current = head
    # handle negative
    if index.negative?
      (self.size + index).times { current = current.next_node }
    else
      (index - 1).times { current = current.next_node }
    end
    current.next_node = current.next_node.next_node
    self.size -= 1
  end
end

ll = LinkedList.new
ll.prepend(200)
ll.prepend(100)
ll.append(400)
ll.insert_at(300, 2)
ll.insert_at(350, -2)
p ll.pop
ll.at(3)
ll.insert_at(400, 4)
ll.insert_at(50, 0)
p ll.contains?(400)
ll.insert_at(500, 100)
p ll.contains?(500)
p ll.size
ll.remove_at(5)
ll.remove_at(0)
ll.remove_at(2)
ll.remove_at(10)
p ll.to_s
p ll
