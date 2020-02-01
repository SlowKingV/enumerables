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

    def my_none?(pattern = nil, &block)
        !any_true = self.my_any?(pattern, &block)
    end

    def my_count(obj = nil)
        arr = to_a
        count = 0

        if obj
            arr.my_each { |val|
                count += 1 if val == obj
            }
        elsif block_given?
            arr.my_each { |val|
                count += 1 if yield(val)
            }
        else
            count = arr.length
        end
        return count
    end
    
    def my_map
        return to_enum unless block_given?
        arr = to_a
        new_arr = []
        arr.my_each_with_index { |v, i| new_arr[i] = yield(v) }
        return new_arr
    end

    def my_map!
        return to_enum unless block_given?
        raise NoMethodError if self.class != Array && self.class != Range

        self.my_each_with_index { |v, i| self[i] = yield(v) }
        return self
    end

    def my_inject(arg1 = nil, arg2 = nil)
        raise ArgumentError unless (arg1 && !block_given?) || (!arg2 && block_given?)

        if arg1 && !arg2 && !block_given?
            opr = arg1
            ini = nil
        else
            ini = arg1
            opr = arg2
        end

        arr = to_a
        ini ? ini_given = true : ini_given = false
        ini = arr[0] unless ini_given

        if opr
            arr.my_each_with_index { |val, i|
                met = ini.method(opr)
                ini = met.call(val) unless !ini_given && i == 0
            }
        else
            arr.my_each_with_index { |val, i| ini = yield(ini, val) unless !ini_given && i == 0 }
        end
        
        return ini
    end

end

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
p greet.my_map! { |obj| obj } #Should raise an exception as #map! isn't valid for Hashes

### TESTING my_inject
puts [1, 2, 3, 4, 5, 6].my_inject(:+) #Should return the sum of all numbers
puts [1, 2, 3, 4, 5, 6].my_inject(10, :+) #Should return the sum of all numbers starting with 10
puts [1, 2, 3, 4, 5, 6].my_inject { |memo, val| memo * 10 + val } #Should return an Integer which includes all the array numbers
puts [1, 2, 3, 4, 5, 6].my_inject(654321) { |memo, val| memo * 10 + val } #Should return an Integer which includes all the array numbers two times
puts [1, 2, 3, 4, 5, 6].my_inject(10, :+) { |memo, val| memo * 10 + val } #Should raise an Exception because this method can't have two operators (:op + &block)
puts [1, 2, 3, 4, 5, 6].my_inject #Should raise an Exception because this method need at least one argument (:op)