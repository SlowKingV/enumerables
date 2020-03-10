module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    arr = to_a
    while i < arr.length
      yield(arr[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = to_a
    i = 0
    i.upto(arr.length - 1) do
      yield(arr[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    match = []
    if is_a? Hash
      my_each { |obj| match << [obj[0], obj[1]] if yield(obj[0], obj[1]) }
      match.to_h
    else
      my_each { |val| match << val if yield(val) }
      match
    end
  end

  def pattern_match(pattern, val, block)
    if !pattern.nil?
      if pattern.is_a? Class then val.is_a? pattern
      elsif pattern.is_a? Regexp then pattern.match?(val)
      else val == pattern
      end
    elsif block then block.call(val)
    else val
    end
  end

  def my_all?(pattern = nil, &block)
    all = true
    arr = to_a
    arr.my_each do |val|
      all = pattern_match(pattern, val, block)
      break unless all
    end
    all ? true : false
  end

  def my_any?(pattern = nil, &block)
    arr = to_a
    any = false
    arr.my_each do |val|
      any = pattern_match(pattern, val, block)
      break if any
    end
    any ? true : false
  end

  def my_none?(pattern = nil, &block)
    !my_any?(pattern, &block)
  end

  def my_count(obj = nil)
    arr = to_a
    count = 0
    arr.my_each do |val|
      if obj then count += 1 if val == obj
      elsif block_given? then count += 1 if yield(val)
      else count = arr.length
      end
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

  def my_inject(*args)
    arr = to_a

    case args.size
    when 1
      if block_given? then arr.unshift(args[0])
      else opr = args[0]
      end
    when 2
      opr = args[1]
      arr.unshift(args[0])
    else
      raise ArgumentError unless block_given?
    end

    memo = arr[0]
    arr.shift
    arr.my_each do |val|
      memo = opr ? memo.method(opr).call(val) : yield(memo, val)
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
