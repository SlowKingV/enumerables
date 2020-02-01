require 'enumerables.rb'

### TESTING my_each
[1, 2, 3, 4, 5, 6].my_each { |v| print v.to_s + " " } #Should print every number next to the other
puts
{shoes: 5, shirt: 5, pants: 4, tie: 3, smoking: 7}.my_each { |k, v| puts "#{k} has #{v} letters!" } #Should print the each key name and it's value

### TESTING my_each_with_index
["cat", "dog", "bunny", "hamster"].my_each_with_index { |o, i| puts "#{o} is number #{i}"} #Should print each value and it's index
{cat: 3, dog: 3, bunny: 5, hamster: 7}.my_each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"} #Should print each key-value pair and their index

### TESTING my_select
p [1, 2, 3, 4, 5, 6].my_select { |v| v > 3 } #Should print every number bigger than 3
p ["hi", "boys", "this", "is", "awesome"].my_select { |v| v =~ /i/ } #Should print every string with an 'i' within
phrase = {hi: 2, boys: 4, this: 4, is: 2, awesome: 7}
p phrase.my_select { |k, v| k =~ /i/ } #Should print every key-value pair whose key includes an 'i'
p phrase.my_select { |k, v| v >= 4 } #Should print every key-value pair whose value is equal or bigger than 4
p phrase.my_select { |k, v| (k =~ /o/) && (v >= 4)} #Should print every key-value pair whose key includes an 'o' and it's value is bigger than 4

### TESTING my_all?
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_all? { |obj| obj < 10 } #Should print 'true' since all the values are lower than 10
puts ["hello", 7, "", 0, nil].my_all? #Should print 'false' since not all the elements are 'truthy' objects
puts ["cat", "rat", "hawk", "hamster"].my_all?(/a/) #Should print 'true' since all the elements include an 'a'
puts {normal: "hello", question: "hello?", shout: "hi!!"}.my_all? { |obj| (obj[0].is_a? Symbol) && (obj[1] =~ /^h/) } #Should print 'true' since every key is a Symbol and every value starts with an 'h'

### TESTING my_any?
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_any? { |obj| obj % 10 == 0 } #Should print 'false' since none of its values is a multiple of 10
puts [nil, false, [], 0, ""].my_any? #Should print 'true' since at least one of its values is 'truthy'
puts ["cat", "rat", "hawk", "hamster"].my_any?(/r$/) #Should print 'true' since at least one of its values ends with 'r'
puts {normal: "hello", question: "hello?", shout: "hi!!"}.my_any? { |obj| (obj[0] == :question) && (obj[1] =~ /\?$/) } #Should print 'true' since at least one of its keys is called :question and its value ends with '?'

### TESTING my_none?
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_none? { |obj| obj % 10 == 0 } #Should print 'true' since none of its values is a multiple of 10
puts ["", 0, [], nil, false].my_none? #Should print 'false' since at least one of its values is 'truthy'
puts ["cat", "rat", "hawk", "hamster"].my_none?(/(^a|a$)/) #Should print 'true' since none of its values starts or ends with 'a'
puts {normal: "hello", question: "hello?", shout: "hi!!"}.my_none? { |obj| (obj[0].length > 5) && (obj[1] =~ /[^\!\?]$/) } #Should print 'false' since at least one of its key names is longer than 5 and ends without '!' or '?'

### TESTING my_count
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_count #Should print the length of the array
puts [1, "hi", :prefix, 2.345, :count, true, nil, ["string"], :incr].my_count(2.345) #Should print '1' since there's only one '2.345'
puts [1, "hi", :prefix, 2.345, :count, true, nil, ["string"], :incr].my_count { |val| val.is_a? Symbol} #Should print '3' since there's three symbols inside

# ### TESTING my_map
arr = [1, 2, 3, 4, 5, 6]
p arr.my_map { |v| v * v } #Should return an Array with every number multiplied by itself
p arr #Should print the original Array
p arr.my_map! { |v| v * v } #Should replace every value in the Array with its number multiplied by itself
p arr #Should print the modified Array
p greet.my_map { |obj| obj } #Should return every key-value pair from the Hash into it's own array
# p greet.my_map! { |obj| obj } #Should raise an exception as #map! isn't valid for Hashes

### TESTING my_inject
puts [1, 2, 3, 4, 5, 6].my_inject(:+) #Should return the sum of all numbers
puts [1, 2, 3, 4, 5, 6].my_inject(10, :+) #Should return the sum of all numbers starting with 10
puts [1, 2, 3, 4, 5, 6].my_inject { |memo, val| memo * 10 + val } #Should return an Integer which includes all the array numbers
puts [1, 2, 3, 4, 5, 6].my_inject(654321) { |memo, val| memo * 10 + val } #Should return an Integer which includes all the array numbers two times
# puts [1, 2, 3, 4, 5, 6].my_inject(10, :+) { |memo, val| memo * 10 + val } #Should raise an Exception because this method can't have two operators (:op + &block)
# puts [1, 2, 3, 4, 5, 6].my_inject #Should raise an Exception because this method need at least one argument (:op)