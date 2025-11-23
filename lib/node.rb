# frozen_string_literal: true

# Class that manages a single node
class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    self.data = data
    self.left = left
    self.right = right
  end
end
