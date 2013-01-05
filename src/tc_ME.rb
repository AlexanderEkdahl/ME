require_relative 'ME'
require 'test/unit'

class TestExamples < Test::Unit::TestCase
  def test_H3
    inp = [22, 34]
    out = []

    ME.new(File.read '../examples/H3').run do |output|
      unless output
        next inp.shift
      end
      out.push output
    end

    assert_equal [56, -12, 748, 0], out
  end

  def test_H4
    inp = [3, 23, 2, 12]
    out = []

    ME.new(File.read '../examples/H4').run do |output|
      unless output
        next inp.shift
      end
      out.push output
    end

    assert_equal [37, 552], out
  end

  def test_H5
    inp = [413, 23, 13, -3, -2, 0]
    out = []

    ME.new(File.read '../examples/H5').run do |output|
      unless output
        next inp.shift
      end
      out.push output
    end

    assert_equal [2, 3], out
  end

  def test_H7ss
    inp = [3, 543, 12, 234]
    out = []

    ME.new(File.read '../examples/H7ss').run do |output|
      unless output
        next inp.shift
      end
      out.push output
    end

    assert_equal [12, 234, 543], out
  end

  def test_H7bb
    inp = [3, 543, 12, 234]
    out = []

    ME.new(File.read '../examples/H7bb').run do |output|
      unless output
        next inp.shift
      end
      out.push output
    end

    assert_equal [12, 234, 543].reverse, out
  end

  def test_subroutines
    out = []

    ME.new(File.read '../examples/subroutines').run do |output|
      out.push output
    end

    assert_equal [100, 400], out
  end
end
