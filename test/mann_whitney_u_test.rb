require 'test_helper'

class MannWhitneyUTest < Minitest::Test
  def first
    @first ||= %w[7500 8000 2000 550 1250 1000 2250 6800 3400 6300 9100 970 1040 670 400]
    # [8, 7, 6, 2, 5, 8, 7, 3]
  end

  def second
    @second ||= %w[400 250 800 1400 8000 7400 1020 6000 920 1420 2700 4200 5200 4100] #  [9, 8, 7, 8, 10, 9, 6]
  end

  def test_u_score
    puts Meicho::MannWhitneyU.new(first, second).u_score
    puts Meicho::MannWhitneyU.new(first, second).z_score
    puts Meicho::MannWhitneyU.new(first, second).p

    assert_equal 9.5, Meicho::MannWhitneyU.new(first, second).u_score
  end
end
