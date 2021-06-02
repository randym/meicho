require 'test_helper'

class ProbabilityDensityFunctionTest < Minitest::Test
  def arr
    @arr ||= [1, 3, 1, 2, 1]
  end

  def test_pdf
    expected = [[0, 0.06327762748696006], [1, 0.5037156144958304], [2, 0.24517078151890154], [3, 0.1820827821591916],
                [4, 0.021124151759715937]]
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
    expected = [[0, 0.7571151579199427], [1, 1.0], [2, 0.5705185271781708], [3, 0.271345473759828], [4, 0.0]]
    assert_equal expected, Meicho::ProbabilityDensityFunction.new(arr, 1).integrate
  end
end
