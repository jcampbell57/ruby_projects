# frozen_string_literal: true

# node class logic
class Node
  include Comparable

  attr_accessor :data :left_children :right_children

  def initialize(d)
    self.data = d 
    self.left = nil
    self.right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    self.root = build_tree(array)
  end

  def build_tree(array); end

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
