require 'test_helper'

class ProbabilityDensityFunctionTest < Minitest::Test
  def arr
    @arr ||= [1, 3, 1, 2, 1]
  end

  def test_pdf
    expected = [[0, 0.09815222250665767], [1, 0.4359985405470501], [2, 0.2645745881205178], [3, 0.16827832656717218],
                [4, 0.03302770525881512]]
    assert_equal expected, Meicho::ProbabilityDensityFunction.new(arr, 1).pdf
  end

  def test_transform
    transform = ->(v) { Math.log(v) }
    subject = Meicho::ProbabilityDensityFunction.from(arr) do |pdf|
      pdf.transform = transform
    end

    assert_equal Meicho::KernelDensityEstimator.new(arr.map(&transform)).pdf, subject.pdf
  end

  def test_integrate
    expected = [[0, 0.76], [1, 1.0], [2, 0.62], [3, 0.29], [4, 0.0]]
    assert_equal expected, Meicho::ProbabilityDensityFunction.new(arr, 1).integrate
  end
end
