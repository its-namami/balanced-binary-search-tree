# frozen_string_literal: true

require 'debug'

require_relative 'node'

# Class that manages a BST, removes duplication in array and sorts it
class Tree
  attr_reader :root

  def initialize(array)
    self.root = build_tree(array.uniq.sort)
  end

  # Tree will become unbalanced over time with this
  def insert(data, node = root)
    return if data.eql?(node.data)

    case data <=> node.data
    when -1, 0
      return insert(data, node.left) unless node.left.nil?

      node.left = Node.new(data)
    when 1
      return insert(data, node.right) unless node.right.nil?

      node.right = Node.new(data)
    end
  end

  alias << insert

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def preorder(tree = root, result = [], &block)
    return if tree.nil?

    result << yield(tree.data)
    preorder(tree.left, result, &block)
    preorder(tree.right, result, &block)

    result
  end

  def inorder(tree = root, result = [], &block)
    return if tree.nil?

    inorder(tree.left, result, &block)
    result << yield(tree.data)
    inorder(tree.right, result, &block)

    result
  end

  def postorder(tree = root, result = [], &block)
    return if tree.nil?

    postorder(tree.left, result, &block)
    postorder(tree.right, result, &block)
    result << yield(tree.data)

    result
  end

  private

  attr_writer :root

  def build_tree(sorted_array, array_segment = sorted_array.dup)
    return if array_segment.empty?

    half = (array_segment.size - 1) / 2

    root = array_segment[half]
    left = build_tree(sorted_array, array_segment.take(half))
    right = build_tree(sorted_array, array_segment.drop(half + 1))

    Node.new(root, left, right)
  end
end
