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

end

[1, 2, 3, 4, 5, 6].my_each { |k, v| puts "#{k} tiene #{v} letras!" }
{zapato: 6, hoja: 4, canica: 6, cal: 3, tormenta: 8}.my_each { |k, v| puts "#{k} tiene #{v} letras!" }
