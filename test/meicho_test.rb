require 'test_helper'

class MeichoTest < Minitest::Test
  def test_it_is_alive
    refute_nil ::Meicho
  end

  def test_quickselect
    arr = [10, 20, 1, 4, 5, 2, 7, 10]
    assert_equal 1, Meicho.quickselect(arr, 0)
    assert_equal 5, Meicho.quickselect(arr, 3)
    assert_equal 20, Meicho.quickselect(arr, arr.length - 1)
  end

  def test_median
    assert_equal 3, Meicho.median([1, 4, 2, 5, 3])
    assert_equal 3, Meicho.median([1, 4, 5, 2])
  end

  def test_mean
    assert_equal 1.5, Meicho.mean([1, 2])
    assert_equal 3, Meicho.mean([2, 4])
  end

  def test_std
    assert_equal 0.8944271909999159, Meicho.std([1, 3, 1, 2, 1])
  end
end
