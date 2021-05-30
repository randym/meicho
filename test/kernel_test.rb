require 'test_helper'

class KernelTest < Minitest::Test
  def arr
    @arr ||= [1, 2, 3]
  end

  def test_gausian
    actual = arr.map do |v|
      Meicho::Kernel.gaussian(v)
    end

    assert_equal [0.3989422804014327, 0.05399096651318806, 0.007306882745280776], actual
  end
end
