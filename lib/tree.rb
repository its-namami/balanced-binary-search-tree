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
    return if data == node.data

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

  def delete(value)
    parent, half = find_parent(value)

    unless parent
      return unless value == root.data

      root_val = root.data

      if root.left && root.right
        next_highest_parent = smallest_node_parent(root.right)
        data = next_highest_parent&.left&.data

        if data
          root.data = next_highest_parent.left.data
          next_highest_parent.left = nil
        else
          root.right.left = root.left.dup
          self.root = root.right
        end
      elsif root.left || root.right
        self.root = root.left || root.right
      else
        self.root = nil
      end

      return root_val

    end

    node = parent.public_send(half)
    node_val = node.data

    if node.left && node.right
      next_highest_parent = smallest_node_parent(node.right)
      data = next_highest_parent&.left&.data

      if data
        parent.public_send(half).data = next_highest_parent.left.data
        next_highest_parent.left = nil
      else
        parent.public_send(half).right.left = node.left.dup
        parent.public_send("#{half}=", node.right)
      end
    elsif node.left || node.right
      parent.public_send("#{half}=", node.left || node.right)
    else
      parent.public_send("#{half}=", nil)
    end

    node_val
  end

  def find(value, node = root)
    return unless node
    return node if value == node.data

    find(value, node.left) || find(value, node.right)
  end

  def level_order(node = root, queue = [], &block)
    return if node.nil?

    queue << node.left if node.left
    queue << node.right if node.right

    yield node.data

    level_order(queue.shift, queue, &block)
  end

  def level_order_iterative
    queue = []
    node = root

    until node.nil?
      yield node.data

      queue << node.left if node.left
      queue << node.right if node.right

      node = queue.shift
    end
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    return '<empty>' if root.nil?

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

  def height(node_value = root.data)
    node = find(node_value) || return

    calculate_height(node)
  end

  def depth(search = root.data, current_node = root, depth = 0)
    return -1 if current_node.nil?
    return depth if current_node.data == search

    if search < current_node.data
      depth(search, current_node.left, depth + 1)
    else
      depth(search, current_node.right, depth + 1)
    end
  end

  private

  attr_writer :root

  def calculate_height(node)
    return -1 if node.nil?

    [calculate_height(node.left), calculate_height(node.right)].max + 1
  end

  def build_tree(sorted_array, array_segment = sorted_array.dup)
    return if array_segment.empty?

    half = (array_segment.size - 1) / 2

    root = array_segment[half]
    left = build_tree(sorted_array, array_segment.take(half))
    right = build_tree(sorted_array, array_segment.drop(half + 1))

    Node.new(root, left, right)
  end

  def smallest_node_parent(node = root)
    if node.left&.left.nil?
      return node
    elsif node && node.left.nil?
      return nil
    end

    smallest_node_parent(node.left)
  end

  def find_parent(value, node = root)
    return if node.nil?
    return [node, :left] if node&.left&.data == value
    return [node, :right] if node&.right&.data == value

    if value < node.data
      find_parent(value, node.left)
    elsif value > node.data
      find_parent(value, node.right)
    end
  end
end
