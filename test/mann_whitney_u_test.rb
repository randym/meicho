require 'test_helper'

class MannWhitneyUTestH0 < Minitest::Test
  def subject
    first = [7500, 8000, 2000, 550, 1250, 1000, 2250, 6800, 3400, 6300, 9100, 970, 1040, 670, 400]
    second = [400, 250, 800, 1400, 8000, 7400, 1020, 6000, 920, 1420, 2700, 4200, 5200, 4100]
    Meicho::MannWhitneyU.new(first, second)
  end

  def test_u_score
    assert_equal 100.0, subject.u_score
  end

  def test_z_score
    assert_equal(-0.22, subject.z_score)
  end

  def test_p_value
    assert_equal 0.826, subject.p_value
  end
end

class MannWhitneyUTestH1 < Minitest::Test
  def subject
    first = [8, 7, 6, 2, 5, 8, 7, 3]
    second = [9, 8, 7, 8, 10, 9, 6]
    Meicho::MannWhitneyU.new(first, second)
  end

  def test_u_score
    assert_equal 9.5, subject.u_score
  end

  def test_z_score
    assert_equal(-2.21, subject.z_score)
  end

  def test_p_value
    assert_equal 0.027, subject.p_value
  end

  def test_p_value_single_tail
    assert_equal 0.014, subject.p_value(1)
  end
end
