# frozen_string_literal: true

require 'test_helper'

class BandwidthTest < Minitest::Test
  def arr
    @arr ||= [-20, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20]
  end

  def test_nda0
    assert_equal 5.945, Meicho::Bandwidth.nda0(arr)
  end

  def test_nda1
    assert_equal 2.043, Meicho::Bandwidth.nda1(arr)
  end

  def test_ste
    assert_equal 0.105, Meicho::Bandwidth.ste(arr, 0.1)
  end
end
