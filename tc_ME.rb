require 'test/unit'

def me file, input = []
  `ruby ME.rb #{file} #{input.join(' ')}`.split.map(&:to_i)
end

class TestExamples < Test::Unit::TestCase
  def test_H3
    out = me 'examples/H3', [22, 34]
    assert_equal out, [56, -12, 748, 0]
  end

  def test_H4
    out = me 'examples/H4', [3, 23, 2, 12]
    assert_equal out, [37, 552]
  end

  def test_H5
    out = me 'examples/H5', [413, 23, 13, -3, -2, 0]
    assert_equal out, [2, 3]
  end

  def test_H7ss
    out = me 'examples/H7ss', [3, 543, 12, 234]
    assert_equal out, [12, 234, 543]
    out = me 'examples/H7ss', [0]
    assert_equal out, []
  end

  def test_H7bb
    out = me 'examples/H7bb', [3, 543, 12, 234]
    assert_equal out, [12, 234, 543]
    out = me 'examples/H7bb', [0]
    assert_equal out, []
  end

  def test_subroutines
    out = me 'examples/subroutines'
    assert_equal out, [100, 400]
  end
end
