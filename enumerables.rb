module Enumerable

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

end

p [1, 2, 3, 4, 5, 6].my_select { |v| v > 3 }
p ["hi", "boys", "this", "is", "awesome"].my_select { |v| v =~ /i/ }

hash = {hi: 2, boys: 4, this: 4, is: 2, awesome: 7}
p hash.my_select { |k, v| k =~ /i/ }
p hash.my_select { |k, v| v >= 4 }
