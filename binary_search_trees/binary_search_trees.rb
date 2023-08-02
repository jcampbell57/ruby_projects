# frozen_string_literal: true

# node class
class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data)
    self.data = data
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

  def find(value, root = self.root)
    if root.data > value
      find(value, root.left)
    elsif root.data < value
      find(value, root.right)
    else
      root
    end
  end

  def level_order
    queue = [root]
    result = []
    until queue.empty?
      current_node = queue.shift
      block_given? ? yield(current_node) : result << current_node.data
      queue << current_node.left unless current_node.left.nil?
      queue << current_node.right unless current_node.right.nil?
    end
    result unless block_given?
  end

  def inorder; end

  def preorder
    queue = [@root]
    result = []
    until queue.empty?
      node = queue.pop
      block_given? ? yield(node) : result << node.data
      queue.push(node.right) unless node.right.nil?
      queue.push(node.left) unless node.left.nil?
    end
    result
  end

  def postorder(node); end

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
p test_tree.level_order
test_tree.delete(4)
test_tree.pretty_print
p test_tree.find(324)
p test_tree.level_order
p test_tree.preorder
