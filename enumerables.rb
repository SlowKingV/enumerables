module Enumerable
    
    def my_each
        return to_enum unless block_given?
        incr = 0

        arr_kind = self.class
        if arr_kind == Hash
            arr = self.flatten
            incr = 2;
        else
            arr = self
            incr = 1;
        end

        i = 0
        while i < arr.length
            arr_kind == Hash ? yield(arr[i], arr[i + 1]) : yield(arr[i])
            i += incr
        end
    end

    def my_each_with_index
        return to_enum unless block_given?
        arr = to_a

        for i in 0...arr.length
            yield(arr[i], i)
        end
    end

end

# [1, 2, 3, 4, 5, 6].my_each { |k, v| puts "#{k} tiene #{v} letras!" }
# {zapato: 6, hoja: 4, canica: 6, cal: 3, tormenta: 8}.my_each { |k, v| puts "#{k} tiene #{v} letras!" }

### TESTING
["cat", "dog", "bunny", "hamster"].my_each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.my_each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}
["cat", "dog", "bunny", "hamster"].each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}
