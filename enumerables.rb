module Enumerable
    
    def my_each_with_index
        return to_enum unless block_given?
        arr = to_a

        for i in 0...arr.length
            yield(arr[i], i)
        end
    end

end

### TESTING
["cat", "dog", "bunny", "hamster"].my_each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.my_each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}
["cat", "dog", "bunny", "hamster"].each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}