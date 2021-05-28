# frozen_string_literal: true

require 'test_helper'

class InterquartileRangeTest < Minitest::Test
  def arr
    @arr ||= [-20, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20]
  end

  def iqr
    @iqr ||= Meicho::InterquartileRange.new(arr)
  end

  def test_q1
    assert_equal 3, iqr.q1
  end

  def test_q3
    assert_equal 8, iqr.q3
  end

  def test_range
    assert_equal 5, iqr.range
  end

  def test_tukey_both
    assert_equal arr[1..-2], Meicho::InterquartileRange.tukey(arr)
  end

  def test_tukey_right
    assert_equal arr[0..-2], Meicho::InterquartileRange.tukey(arr, :right)
  end

  def test_tukey_left
    assert_equal arr[1..-1], Meicho::InterquartileRange.tukey(arr, :left)
  end
end
