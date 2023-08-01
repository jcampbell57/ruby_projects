# frozen_string_literal: true

# node class logic
class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(d)
    self.data = d
    self.left = nil
    self.right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    self.root = build_tree(array.sort.uniq)
    pretty_print
  end

  def build_tree(array)
    p array
    if array.length == 0
      nil
    elsif array.length == 1
      node = Node.new(array[0])
    else
      mid = (array.length - 1) / 2
      node = Node.new(array[mid])
      node.left = build_tree(array[0..(mid - 1)]) unless mid == 0
      node.right = build_tree(array[(mid + 1)..-1])
      node
    end
  end

  def insert(value); end

  def delete(value); end

  def find(value); end

  def level_order(block); end

  def inorder(block); end

  def preorder(block); end

  def postorder(block); end

  def height(node); end

  def depth(node); end

  def balanced?(tree); end

  def rebalance(tree); end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
Tree.new(test_array)
