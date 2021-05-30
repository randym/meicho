require 'test_helper'

class KernelDensityEstimatorTest < Minitest::Test
  def arr
    @arr ||= [1, 3, 1, 2, 1]
  end

  def test_pdf
    standard = [
      [1, 0.3918771391296802],
      [2, 0.27685046544191405],
      [3, 0.1616112607528291]
    ]

    assert_equal standard, Meicho::KernelDensityEstimator.new(arr).pdf
  end

  def test_pdf_with_step
    stepped = [
      [1.0, 0.3918771391296802],
      [1.5, 0.3678372191915956],
      [2.0, 0.27685046544191405],
      [2.5, 0.2101704875429851],
      [3.0, 0.1616112607528291]
    ]

    assert_equal stepped, Meicho::KernelDensityEstimator.new(arr, 0.5).pdf
  end

  def test_pdf_ms_with_step
    data = [2240, 2411, 2970, 3005, 3233, 3272]

    stepped = [
      [2240, 0.0004767615614508628],
      [2740, 0.000546551317645814],
      [3240, 0.0008407198158310984]
    ]

    assert_equal stepped, Meicho::KernelDensityEstimator.new(data, 500).pdf
  end

  def test_pdf_normalized
    data = [2240, 2411, 2970, 3005, 3233, 3272]
    data = data.map { |v| (v - data.min * 1.0) / (data.max - data.min * 1.0) }
    stepped = [
      [0.0, 0.41219324443408645],
      [0.25, 0.5266435621903967],
      [0.5, 0.6459548113947067],
      [0.75, 0.7501231515740054],
      [1.0, 0.6717203246436635]
    ]

    assert_equal stepped, Meicho::KernelDensityEstimator.new(data, 0.25).pdf
  end
end
