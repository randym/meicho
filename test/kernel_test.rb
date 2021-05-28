# frozen_string_literal: true

require 'test_helper'

class KernelTest < Minitest::Test
  def arr
    @arr ||= [1, 2, 3]
  end

  def test_gausian
    assert_equal [0.3989422804014327, 2.9478068901215075, 21.781510479922122], arr.map { |v|
                                                                                 Meicho::Kernel.gaussian(v)
                                                                               }
  end
end
