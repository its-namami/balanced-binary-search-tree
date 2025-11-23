# frozen_string_literal: true

require_relative 'lib/tree'

array = [3, 7, 9, -7, 11, 1, 29, 27, -3, 21, 23, 13, 5, 2, 19, 17, -11]

tree = Tree.new(array)

puts 'preorder:'
tree.preorder { |data| print "#{data} " }
puts "\nInorder:"
tree.inorder { |data| print "#{data} " }
puts "\nPostorder:"
tree.postorder { |data| print "#{data} " }
puts tree.pretty_print
