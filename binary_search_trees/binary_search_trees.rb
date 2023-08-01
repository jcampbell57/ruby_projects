# frozen_string_literal: true

# node class
class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(d)
    self.data = d
    self.left = nil
    self.right = nil
  end
end

# tree class
class Tree
  attr_accessor :root

  def initialize(array)
    self.root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    if array.empty?
      nil
    elsif array.length == 1
      Node.new(array[0])
    else
      mid = (array.length - 1) / 2
      node = Node.new(array[mid])
      node.left = build_tree(array[0..(mid - 1)]) unless mid.zero?
      node.right = build_tree(array[(mid + 1)..])
      node
    end
  end

  def insert(value, root = self.root)
    if root.nil?
      root = Node.new(value)
    elsif value < root.data
      root.left = insert(value, root.left)
    elsif value > root.data
      root.right = insert(value, root.right)
    else
      puts 'This is strange'
      exit
    end
    root
  end

  def delete(value, root = self.root)
    if root.nil?
      root
    # find node to be deleted
    elsif root.data > value
      root.left = delete(value, root.left)
      root
    elsif root.data < value
      root.right = delete(value, root.right)
      root
    # handle one child
    elsif root.left.nil?
      root.right
    elsif root.right.nil?
      root.left
    # handle both children
    else
      old_node = root
      # find successor node
      new_node = root.right
      until new_node.left.nil?
        old_node = new_node
        new_node = old_node.left
      end

      if old_node != root
        old_node.left = new_node.right
      else
        old_node.right = new_node.right
      end

      root.data = new_node.data
      root
    end
  end

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
test_tree = Tree.new(test_array)
test_tree.insert(660)
test_tree.pretty_print
test_tree.delete(67)
test_tree.pretty_print
