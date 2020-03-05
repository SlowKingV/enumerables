require './enumerables.rb'

puts 'TESTING my_each'
[1, 2, 3, 4, 5, 6].my_each { |v| print v.to_s + ' ' }
# => Should print every number next to the other
puts
{ shoes: 5, shirt: 5, pants: 4, tie: 3, smoking: 7 }.to_a.my_each { |val| p val }
# => Should print all the keys and values
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_each_with_index'
%w[cat dog bunny hamster].my_each_with_index { |o, i| puts "#{o} is number #{i}" }
# => Should print each value and it's index
{ cat: 3, dog: 3, bunny: 5, hamster: 7 }.my_each_with_index { |o, i| puts "Key: #{o[0]} |Value: #{o[1]} |Index: #{i}" }
# => Should print each key-value pair and their index
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_select'
p([1, 2, 3, 4, 5, 6].my_select { |v| v > 3 })
# => Should print every number bigger than 3
p(%w[hi boys this is awesome].my_select { |v| /i/.match?(v) })
# => Should print every string with an 'i' within
phrase = { hi: 2, boys: 4, this: 4, is: 2, awesome: 7 }
p(phrase.my_select { |k, _v| /i/.match?(k) })
# => Should print every key-value pair whose key includes an 'i'
p(phrase.my_select { |_k, v| v >= 4 })
# => Should print every key-value pair whose value is equal or bigger than 4
p(phrase.my_select { |k, v| /o/.match?(k) && (v >= 4) })
# => Should print every key-value pair whose key includes an 'o' and it's value is bigger than 4
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

greet = { normal: 'hello', question: 'hello?', shout: 'hi!!' }
puts 'TESTING my_all?'
puts([1, 2, 3, 4, 5, 6, 7, 8, 9].my_all? { |obj| obj < 10 })
# => Should print 'true' since all the values are lower than 10
puts ['hello', 7, '', 0, nil].my_all?
# => Should print 'false' since not all the elements are 'truthy' objects
puts [0, 0, 0, 0, 0, 0, 0, 0].my_all?(0)
# => Should print 'true' since all the elements are 0
puts %w[cat rat hawk hamster].my_all?(/a/)
# => Should print 'true' since all the elements include an 'a'
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_all?(Numeric)
# => Should print 'true' since every element is a number
puts(greet.my_all? { |obj| (obj[0].is_a? Symbol) && /^h/.match?(obj[1]) })
# => Should print 'true' since every key is a Symbol and every value starts with an 'h'
puts [false, false, false, false, false, false].my_all?
# => Should print false because they aren't truthy objects
puts [false, false, false, false, false, false].my_all?(false)
# => Should print true because they all are 'false'
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_any?'
puts([1, 2, 3, 4, 5, 6, 7, 8, 9].my_any? { |obj| (obj % 10).zero? })
# => Should print 'false' since none of its values is a multiple of 10
puts [nil, false, [], 0, ''].my_any?
# => Should print 'true' since at least one of its values is 'truthy'
puts [nil, false, [], 0, ''].my_any?(0)
# => Should print 'true' since at least one of its values is 0
puts %w[cat rat hawk hamster].my_any?(/r$/)
# => Should print 'true' since at least one of its values ends with 'r'
puts [nil, false, [], 0, ''].my_any?(Float)
# => Should print 'false' since none of its values is a Float
puts(greet.my_any? { |obj| (obj[0] == :question) && /\?$/.match?(obj[1]) })
# => Should print 'true' since at least one of its keys is called :question and its value ends with '?'
puts [false, false, false, false, false, false].my_any?
# => Should print false because even if they are all the same object they aren't truthy objects
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_none?'
puts([1, 2, 3, 4, 5, 6, 7, 8, 9].my_none? { |obj| (obj % 10).zero? })
# => Should print 'true' since none of its values is a multiple of 10
puts ['', 0, [], nil, false].my_none?
# => Should print 'false' since at least one of its values is 'truthy'
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_none?(4)
# => Should print 'false' since at least one of its values is 4
puts %w[cat rat hawk hamster].my_none?(/(^a|a$)/)
# => Should print 'true' since none of its values starts or ends with 'a'
puts [nil, false, [], 0, ''].my_none?(Float)
# => Should print 'true' since none of its values is a Float
puts(greet.my_none? { |obj| (obj[0].length > 5) && (obj[1] =~ /[^\!\?]$/) })
# => Should print 'false' since at least one of its key names is longer than 5 and ends without '!' or '?'
puts [false, false, false, false, false, false].my_all?
# => Should print true because even if they are all the same object they aren't truthy objects
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_count'
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_count
# => Should print the length of the array
puts [1, 'hi', :prefix, 2.345, :count, true, nil, ['string'], :incr].my_count(2.345)
# => Should print '1' since there's only one '2.345'
puts([1, 'hi', :prefix, 2.345, :count, true, nil, ['string'], :incr].my_count { |val| val.is_a? Symbol })
# => Should print '3' since there's three symbols inside
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_map'
arr = [1, 2, 3, 4, 5, 6]
p(arr.my_map { |v| v * v })
# => Should return an Array with every number multiplied by itself
puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

puts 'TESTING my_inject'
puts [1, 2, 3, 4, 5, 6].my_inject(:+)
# => Should return the sum of all numbers
puts [1, 2, 3, 4, 5, 6].my_inject(10, :+)
# => Should return the sum of all numbers starting with 10
puts([1, 2, 3, 4, 5, 6].my_inject { |memo, val| memo * 10 + val })
# => Should return an Integer which includes all the array numbers
puts [1, 2, 3, 4, 5, 6].my_inject(654_321) { |memo, val| memo * 10 + val }
# => Should return the Integer '654321123456'

def multiply_els(arr)
  arr.my_inject(:*)
end
puts multiply_els([1, 2, 3, 4, 5, 6])
# => Should return the product of multiply all the array elements
