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