# frozen_string_literal: true

require 'test_helper'

class BandwidthTest < Minitest::Test
  def normal_arr
    @normal_arr ||= [-20, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20]
  end

  def long_tail_arr
    @long_tail_arr ||= [2240, 2411, 2970, 3005, 3233, 4000, 6272, 9000, 10_000, 15_000, 100_000]
  end

  def test_normal_distribution_approximation
    assert_equal 2.656, Meicho::Bandwidth.normal_distribution_approximation(normal_arr)
  end

  def test_iterative_amise_against_normal
    assert_equal 2.666, Meicho::Bandwidth.iterative_amise(normal_arr)
  end

  def test_normal_distribution_approximation_against_non_normal
    assert_equal 2922.904, Meicho::Bandwidth.normal_distribution_approximation(long_tail_arr)
  end

  def test_interative_amise_against_non_normal
    assert_equal 704.196, Meicho::Bandwidth.iterative_amise(long_tail_arr)
  end
end
