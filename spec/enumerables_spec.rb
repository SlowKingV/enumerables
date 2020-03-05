require './enumerables.rb'

describe Enumerable do
  context '#my_each' do
    it 'Prints every value of the array' do
      expected = ''
      (0..9).each { |v| expected << "#{v}\n" }
      expect { (0..9).my_each { |v| p v } }.to output(expected).to_stdout
    end

    it 'Prints every key-value pair' do
      expected = ''
      actual = { shoes: 5, shirt: 5, pants: 4, tie: 3, smoking: 7 }
      actual.each { |v| expected << "#{v}\n" }
      expect { actual.my_each { |v| p v } }.to output(expected).to_stdout
    end
  end

  context '#my_each_with_index' do
    it 'Prints every value and index of the array' do
      expected = ''
      (0..9).each_with_index { |v, i| expected << "#{i}: #{v}\n" }
      expect { (0..9).my_each_with_index { |v, i| puts "#{i}: #{v}" } }.to output(expected).to_stdout
    end

    it 'Prints every key-value pair and index' do
      expected = ''
      actual = { shoes: 5, shirt: 5, pants: 4, tie: 3, smoking: 7 }
      actual.each_with_index { |h, i| expected << "#{i}: #{h}\n" }
      expect { actual.my_each_with_index { |h, i| puts "#{i}: #{h}" } }.to output(expected).to_stdout
    end
  end

  context '#my_select' do
    it 'Returns every value that is bigger than 3' do
      expect((0..9).my_select { |v| v > 3 }).to eql((0..9).select { |v| v > 3 })
    end

    it 'Returns every value that includes an \'i\'' do
      actual = %w[hi boys this is awesome]
      expect(actual.my_select { |v| /i/.match?(v) }).to eql(actual.select { |v| /i/.match?(v) })
    end

    actual = { hi: 2, boys: 4, this: 4, is: 2, awesome: 7 }
    it 'Returns every key-value pair where its key includes an \'i\'' do
      expect(actual.my_select { |k, _v| /i/.match?(k) }).to eql(actual.select { |k, _v| /i/.match?(k) })
    end

    it 'Returns every key-value pair where its value is bigger than 4' do
      expect(actual.my_select { |_k, v| v >= 4 }).to eql(actual.select { |_k, v| v >= 4 })
    end

    it 'Returns every key-value pair where its key includes and \'o\' and its value is bigger than 4' do
      eval = proc { |k, v| /o/.match?(k) && (v >= 4) }
      expect(actual.my_select(&eval)).to eql(actual.select(&eval))
    end
  end

  context '#my_all?' do
    it 'Should return true since all the values are lower than 10' do
      expect((1..9).my_all? { |v| v < 10 }).to eql((1..9).all? { |v| v < 10 })
    end

    it 'Should return false since not all the elements are truthy' do
      expect(['hello', 7, '', 0, nil].my_all?).to eql(['hello', 7, '', 0, nil].all?)
    end

    it 'Should return true since all the elements are zero' do
      expect([].fill(0, 0..9).my_all?(0)).to eql([].fill(0, 0..9).all?(0))
    end

    it 'Should return true since all the elements include an \'a\'' do
      expect(%w[cat rat hawk hamster].my_all?(/a/)).to eql(%w[cat rat hawk hamster].all?(/a/))
    end

    it 'Should return true since all the elements are Numbers' do
      expect((1..9).my_all?(Numeric)).to eql((1..9).all?(Numeric))
    end

    it 'Should return false because they aren\'t truthy elements' do
      expect([].fill(false, 0..9).my_all?).to eql([].fill(false, 0..9).all?)
    end

    it 'Should return true because they all are \'false\'' do
      expect([].fill(false, 0..9).my_all?(false)).to eql([].fill(false, 0..9).all?(false))
    end
  end

  context '#my_any' do
    it 'Should return false since none of the values is a multiple of 10' do
      expect((1..9).my_any? { |v| (v % 10).zero? }).to eql((1..9).any? { |v| (v % 10).zero? })
    end

    it 'Should return true since at least one of the values is truthy' do
      expect([nil, false, [], 0, ''].my_any?).to eql([nil, false, [], 0, ''].any?)
    end

    it 'Should return true since at least one of the values is 0' do
      expect([nil, false, [], 0, ''].my_any?(0)).to eql([nil, false, [], 0, ''].any?(0))
    end

    it 'Should return true since at least one of the values ends with \'r\'' do
      expect(%w[cat rat hawk hamster].my_any?(/r$/)).to eql(%w[cat rat hawk hamster].any?(/r$/))
    end

    it 'Should return false since none of the values is a Float' do
      expect([nil, false, [], 0, ''].my_any?(Float)).to eql([nil, false, [], 0, ''].any?(Float))
    end

    it 'Should return true since at least one of the values is \'false\'' do
      expect([].fill(false, 0..9).my_any?(false)).to eql([].fill(false, 0..9).any?(false))
    end
  end
end
