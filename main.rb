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
tree << 5
puts
puts tree.pretty_print
puts '-----'

puts tree.find(29).inspect
puts tree.find(1).inspect
puts tree.find(-11).inspect

tree.level_order_iterative { |node| puts node }
puts '-----'
tree.pretty_print
puts "9:: d#{tree.depth(9)} | h#{tree.height(9)}"
puts "1:: d#{tree.depth 1} | h#{tree.height(1)}"
puts "-7:: d#{tree.depth(-7)} | h#{tree.height(-7)}"
puts "-3:: d#{tree.depth(-3)} | h#{tree.height(-3)}"
puts "19:: d#{tree.depth(19)} | h#{tree.height(19)}"
puts "21:: d#{tree.depth(21)} | h#{tree.height(21)}"
puts "23:: d#{tree.depth(23)} | h#{tree.height(23)}"
puts "29:: d#{tree.depth(29)} | h#{tree.height(29)}"

puts tree.balanced? ? 'yes' : 'no'
tree << 6
tree << 8
tree << 4
tree << 0
tree << -1
tree << -2
tree << -4
tree << -5
tree << -6
tree.delete(-6)
tree.delete(-1)
tree.delete 0
tree.delete 8
puts tree.pretty_print

# 50.times do |n|
#   n -= 20
#   puts "##{n}\n-------\n"
#   tree.delete(n) || next
#   puts tree.pretty_print
# end
