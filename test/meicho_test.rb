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
end
