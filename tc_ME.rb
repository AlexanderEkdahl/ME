require 'test/unit'

def me file, input = []
  `ruby ME.rb #{file} #{input.join(' ')}`.split.map(&:to_i)
end

class TestExamples < Test::Unit::TestCase
  @@sorted_array   =  (-10..10).to_a
  @@shuffled_array = @@sorted_array.shuffle(random: Random.new(0))

  def test_simple
    out = me 'examples/simple', [22, 34]
    assert_equal out, [56, -12, 748, 0]
  end

  def test_sum_product
    out = me 'examples/sum_product', [3, 23, 2, 12]
    assert_equal out, [37, 552]
  end

  def test_selection_sort
    out = me 'examples/selection_sort', [@@shuffled_array.length, *@@shuffled_array]
    assert_equal out, @@sorted_array
    out = me 'examples/selection_sort', [0]
    assert_equal out, []
  end

  def test_bubble_sort
    out = me 'examples/bubble_sort', [@@shuffled_array.length, *@@shuffled_array]
    assert_equal out, @@sorted_array
    out = me 'examples/bubble_sort', [0]
    assert_equal out, []
  end

  def test_subroutines
    out = me 'examples/subroutines'
    assert_equal out, [100, 400]
  end
end
