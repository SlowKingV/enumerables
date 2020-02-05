module Enumerable
  def my_each
    return to_enum unless block_given?

    incr = 0
    arr_kind = self.class
    if arr_kind == Hash
      arr = flatten
      incr = 2
    else
      arr = to_a
      incr = 1
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
    else
      match = []
      (0...arr.length).my_each do |v|
        found = yield(v)
        match << v if found
      end
    end
    match
  end

  def my_all?(pattern = nil)
    arr = to_a
    all_true = true

    (0...arr.length).my_each do |v|
      all_true = if pattern
                   !!(v =~ pattern)
                 else
                   block_given? ? !!yield(v) : !!v
                 end
      break unless all_true
    end

    all_true
  end

  def my_any?(pattern = nil)
    arr = to_a
    any_true = false

    (0...arr.length).my_each do |v|
      any_true = if pattern
                   !!(v =~ pattern)
                 else
                   block_given? ? !!yield(v) : !!v
                 end
      break unless all_true
    end

    any_true
  end

  def my_none?(pattern = nil, &block)
    !my_any?(pattern, &block)
  end

  def my_count(obj = nil)
    arr = to_a
    count = 0

    if obj
      arr.my_each do |val|
        count += 1 if val == obj
      end
    elsif block_given?
      arr.my_each do |val|
        count += 1 if yield(val)
      end
    else
      count = arr.length
    end
    count
  end

  def my_map
    return to_enum unless block_given?

    arr = to_a
    new_arr = []
    arr.my_each_with_index { |v, i| new_arr[i] = yield(v) }
    new_arr
  end

  def my_map!
    return to_enum unless block_given?
    raise NoMethodError if self.class != Array && self.class != Range

    my_each_with_index { |v, i| self[i] = yield(v) }
    self
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
    ini_given = ini ? true : false
    ini = arr[0] unless ini_given
    arr.my_each_with_index do |val, i|
      if opr
        met = ini.method(opr)
        ini = met.call(val) unless !ini_given && i.zero?
      else
        ini = yield(ini, val) unless !ini_given && i.zero?
      end
    end

    ini
  end
end
