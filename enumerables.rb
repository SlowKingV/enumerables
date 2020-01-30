module Enumerable
    
    def my_each
        return to_enum unless block_given?
        incr = 0

        arr_kind = self.class
        if arr_kind == Hash
            arr = self.flatten
            incr = 2;
        else
            arr = self.to_a
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

    def my_select
        return to_enum unless block_given?

        kind = self.class
        arr = to_a

        if kind == Hash
            match = {}
            flat = arr.flatten
            i = 0
            while i < flat.length
                found = yield(flat[i], flat[i + 1])
                match[flat[i]] = flat[i + 1] if found
                i += 2
            end
            return match
        else
            match = []
            for i in 0...(arr.length)
                found = yield(arr[i])
                match << arr[i] if found
            end
            return match
        end
    end

    def my_all?(pattern = nil)
        arr = to_a
        all_true = true

        for i in (0...arr.length)
            if all_true == true
                if pattern
                    all_true = !!(arr[i] =~ pattern)
                else
                    block_given? ? all_true = !!(yield(arr[i])) : all_true = !!arr[i]
                end
            else
                break
            end
        end

        return all_true
    end

    def my_any?(pattern = nil)
        arr = to_a
        any_true = false

        for i in (0...arr.length)
            if any_true == false
                if pattern
                    any_true = !!(arr[i] =~ pattern)
                else
                    block_given? ? any_true = !!(yield(arr[i])) : any_true = !!arr[i]
                end
            else
                break
            end
        end

        return any_true
    end

end

### TESTING my_each
[1, 2, 3, 4, 5, 6].my_each { |k, v| puts "#{k} tiene #{v} letras!" }
{zapato: 6, hoja: 4, canica: 6, cal: 3, tormenta: 8}.my_each { |k, v| puts "#{k} tiene #{v} letras!" }

### TESTING my_each_with_index
["cat", "dog", "bunny", "hamster"].my_each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.my_each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}
["cat", "dog", "bunny", "hamster"].each_with_index { |o, i| puts "#{o} is number #{i}"}
{cat: 3, dog: 3, bunny: 5, hamster: 7}.each_with_index { |o, i| puts "#{o[0].to_s} has #{o[1]} characters and is number #{i}"}

### TESTING my_select
p [1, 2, 3, 4, 5, 6].my_select { |v| v > 3 }
p ["hi", "boys", "this", "is", "awesome"].my_select { |v| v =~ /i/ }

hash = {hi: 2, boys: 4, this: 4, is: 2, awesome: 7}
p hash.my_select { |k, v| k =~ /i/ }
p hash.my_select { |k, v| v >= 4 }

### TESTING my_all
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_all? { |obj| obj < 10 }
puts ["hello", 7, "", 0, nil].my_all?
puts ["cat", "rat", "hawk", "hamster"].my_all?(/a/)
hash = {normal: "hello", question: "hello?", shout: "hi!!"}
puts hash.my_all? { |obj| (obj[0].is_a? Symbol) && (obj[1] =~ /^h/) }

### TESTING my_any
puts [1, 2, 3, 4, 5, 6, 7, 8, 9].my_any? { |obj| obj % 10 == 0 }
puts [nil, false, [], 0, nil].my_any?
puts ["cat", "rat", "hawk", "hamster"].my_any?(/r$/)
hash = {normal: "hello", question: "hello?", shout: "hi!!"}
puts hash.my_any? { |obj| (obj[0] == :question) && (obj[1] =~ /\?$/) }
