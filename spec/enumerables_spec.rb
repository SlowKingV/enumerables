require './enumerables.rb'

describe Enumerable do
  let(:arr_num) { (0..9).to_a }
  let(:hash_clo) { { shoes: 5, shirt: 5, pants: 4, tie: 3, smoking: 7 } }
  let(:arr_word) { %w[hi boys this is awesome] }
  let(:hash_word) { { hi: 2, boys: 4, this: 4, is: 2, awesome: 7 } }
  let(:arr_obj) { ['hello', 7, '', 0, nil] }
  let(:arr_animals) { %w[cat rat hawk hamster] }
  let(:arr_zero) { [].fill(0, 0..9) }
  let(:arr_false) { [].fill(false, 0..9) }
  let(:arr_empty) { [nil, false, [], 0, ''] }
  let(:arr_types) { [1, 'hi', :prefix, 2.345, :count, true, nil, ['string'], :incr] }

  context '#my_each' do
    it 'Prints every value of the array' do
      expected = ''
      arr_num.each { |v| expected << "#{v}\n" }
      expect { arr_num.my_each { |v| p v } }.to output(expected).to_stdout
    end

    it 'Prints every key-value pair' do
      expected = ''
      hash_clo.each { |v| expected << "#{v}\n" }
      expect { hash_clo.my_each { |v| p v } }.to output(expected).to_stdout
    end

    it 'Returns an \'Enumerator\' if no block is given' do
      expect(arr_num.my_each.to_a).to eq(arr_num.each.to_a)
    end
  end

  context '#my_each_with_index' do
    it 'Prints every value and index of the array' do
      expected = ''
      arr_num.each_with_index { |v, i| expected << "#{i}: #{v}\n" }
      expect { arr_num.my_each_with_index { |v, i| puts "#{i}: #{v}" } }.to output(expected).to_stdout
    end

    it 'Prints every key-value pair and index' do
      expected = ''
      hash_clo.each_with_index { |h, i| expected << "#{i}: #{h}\n" }
      expect { hash_clo.my_each_with_index { |h, i| puts "#{i}: #{h}" } }.to output(expected).to_stdout
    end

    it 'Returns an \'Enumerator\' if no block is given' do
      expect(arr_num.my_each_with_index.to_a).to eq(arr_num.each_with_index.to_a)
    end
  end

  context '#my_select' do
    it 'Returns every value that is bigger than 3' do
      expect(arr_num.my_select { |v| v > 3 }).to eql(arr_num.select { |v| v > 3 })
    end

    it 'Returns every value that includes an \'i\'' do
      expect(arr_word.my_select { |v| /i/.match?(v) }).to eql(arr_word.select { |v| /i/.match?(v) })
    end

    it 'Returns every key-value pair where its key includes an \'i\'' do
      expect(hash_word.my_select { |k, _v| /i/.match?(k) }).to eql(hash_word.select { |k, _v| /i/.match?(k) })
    end

    it 'Returns every key-value pair where its value is bigger than 4' do
      expect(hash_word.my_select { |_k, v| v >= 4 }).to eql(hash_word.select { |_k, v| v >= 4 })
    end

    it 'Returns every key-value pair where its key includes and \'o\' and its value is bigger than 4' do
      eval = proc { |k, v| /o/.match?(k) && (v >= 4) }
      expect(hash_word.my_select(&eval)).to eql(hash_word.select(&eval))
    end

    it 'Returns an \'Enumerator\' if no block is given' do
      expect(arr_num.my_select.to_a).to eq(arr_num.select.to_a)
    end
  end

  context '#my_all?' do
    it 'Should return true if all the values return true from the block' do
      expect(arr_num.my_all? { |v| v < 10 }).to eql(arr_num.all? { |v| v < 10 })
    end

    it 'Should return false if not all the elements are truthy objects' do
      expect(arr_obj.my_all?).to eql(arr_obj.all?)
    end

    it 'Should return true if all the elements are the same as the passed value' do
      expect(arr_zero.my_all?(0)).to eql(arr_zero.all?(0))
    end

    it 'Should return true if all the elements match with the given RegExp pattern' do
      expect(arr_animals.my_all?(/a/)).to eql(arr_animals.all?(/a/))
    end

    it 'Should return true if all the elements are instances of the given class' do
      expect(arr_num.my_all?(Numeric)).to eql(arr_num.all?(Numeric))
    end

    it 'Should return false if any element is \'false\' or \'nil\'' do
      expect(arr_false.my_all?).to eql(arr_false.all?)
    end

    it 'Should return true for \'false\' elements if you pass them as values' do
      expect(arr_false.my_all?(false)).to eql(arr_false.all?(false))
    end
  end

  context '#my_any' do
    it 'Should return false if none of the values returns true from the block' do
      expect(arr_num.my_any? { |v| (v % 10).zero? }).to eql(arr_num.any? { |v| (v % 10).zero? })
    end

    it 'Should return true if any of the values is a truthy object' do
      expect(arr_empty.my_any?).to eql(arr_empty.any?)
    end

    it 'Should return true if any of the values is equal as the given value' do
      expect(arr_empty.my_any?(0)).to eql(arr_empty.any?(0))
    end

    it 'Should return true if any element match the given RegExp pattern' do
      expect(arr_animals.my_any?(/r$/)).to eql(arr_animals.any?(/r$/))
    end

    it 'Should return false if none of the elements is an instance of the given class' do
      expect(arr_empty.my_any?(Float)).to eql(arr_empty.any?(Float))
    end

    it 'Should return true for any \'false\' elements if you give it as a value' do
      expect(arr_false.my_any?(false)).to eql(arr_false.any?(false))
    end
  end

  context '#my_none?' do
    it 'Should return \'true\' if none of its values returns true from the block' do
      expect(arr_num.my_none? { |obj| (obj % 10).zero? }).to eql(arr_num.none? { |obj| (obj % 10).zero? })
    end

    it 'Should return \'false\' if any of its values is truthy' do
      expect(arr_empty.my_none?).to eql(arr_empty.none?)
    end

    it 'Should return \'false\' if any of the values is equal to the argument' do
      expect(arr_num.my_none?(4)).to eql(arr_num.none?(4))
    end

    it 'Should return \'true\' if none of the values match with the RegExp pattern' do
      expect(arr_animals.my_none?(/(^a|a$)/)).to eql(arr_animals.none?(/(^a|a$)/))
    end

    it 'Should return \'true\' if none of the values is an instance of the given class' do
      expect(arr_empty.my_none?(Float)).to eql(arr_empty.none?(Float))
    end

    it 'Should return \'false\' if any of its values returns true from the block' do
      eval = proc { |obj| (obj[0].length > 5) && (obj[1] =~ /[^\!\?]$/) }
      expect(hash_word.my_none?(&eval)).to eql(hash_word.none?(&eval))
    end

    it 'Should return true if there are no truthy values' do
      expect(arr_false.my_none?).to eql(arr_false.none?)
    end
  end

  context '#my_count' do
    it 'Should return the length of the array' do
      expect(arr_num.my_count).to eql(arr_num.count)
    end

    it 'Should return the number of elements equal to the argument' do
      expect(arr_types.my_count(2.345)).to eql(arr_types.count(2.345))
    end

    it 'Should return the number of elements that return true from the block' do
      expect(arr_types.my_count { |v| v.is_a? Symbol }).to eql(arr_types.count { |v| v.is_a? Symbol })
    end
  end

  context '#my_map' do
    it 'Should return an Array with every number replaced by the return value of the block' do
      expect(arr_num.my_map { |v| v * v }).to eql(arr_num.map { |v| v * v })
    end

    it 'Should use the \'proc\' and do the same' do
      block = proc { |w| w[0] }
      expect(arr_word.my_map(&block)).to eql(arr_word.map(&block))
    end
  end

  context '#my_inject' do
    it 'Should return a single value defined by the argument method' do
      expect(arr_num.my_inject(:+)).to eql(arr_num.inject(:+))
    end

    it 'Should return a single value defined by the initial value and the argument method' do
      expect(arr_num.my_inject(10, :+)).to eql(arr_num.inject(10, :+))
    end

    it 'Should return a single value defined by the given block' do
      expect(arr_num.my_inject { |memo, val| memo * 10 + val }).to eql(arr_num.inject { |memo, val| memo * 10 + val })
    end

    it 'Should return a single value defined by the initial value and the block' do
      block = proc { |memo, val| memo * 10 + val }
      expect(arr_num.my_inject(9_876_543_210, &block)).to eql(arr_num.inject(9_876_543_210, &block))
    end
  end

  context '#multiply_els' do
    it 'Should return the product of multiply all the array elements' do
      expect(multiply_els(arr_num.map { |v| v + 1 })).to eql 3_628_800
    end
  end
end
