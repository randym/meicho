# frozen_string_literal: true

require 'test_helper'

class KernelDensityEstimatorTest < Minitest::Test
  def arr
    @arr ||= [-20, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20]
  end

  def test_pdf
    assert_equal [], Meicho::KernelDensityEstimator.new(arr)
  end
end
