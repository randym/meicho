require 'meicho/version'
require 'meicho/interquartile_range'
require 'meicho/kernel'
require 'meicho/bandwidth'
require 'meicho/kernel_density_estimator'
require 'meicho/probability_density_function'
require 'meicho/mann_whitney_u'
module Meicho
  class Error < StandardError; end

  def self.quickselect(arr = [], position = 0)
    members = arr.dup
    loop do
      pivot = members.delete_at(rand(members.length))
      left, right = members.partition { |i| i < pivot }

      return pivot if position == left.length

      members = position < left.length ? left : right
      members == right && position = position - left.length - 1
    end
  end

  def self.p_value(z_score)
    n = 1
    direction = z_score <=> 0
    z = z_score.to_f * direction
    distance = item = z * Meicho::Kernel.gaussian(z)
    while item.positive?
      item *= z**2 / (n += 2)
      distance += item
    end
    (0.5 + distance * direction).round(4)
  end

  def self.median(arr = [])
    n = arr.length
    mid = n / 2
    return quickselect(arr, mid.floor) if n.odd?

    (quickselect(arr, mid - 1) + quickselect(arr, mid)) / 2.0
  end

  def self.mean(arr = [], biased: true)
    n = arr.length.to_f
    return arr[0] if n == 1

    arr.reduce(:+) / (biased ? n : n - 1)
  end

  def self.variance(arr = [])
    m = mean(arr)
    square_error = ->(a) { (a - m)**2 }
    mean(arr.map(&square_error), biased: false)
  end

  def self.std(arr = [])
    Math.sqrt(variance(arr))
  end

  #  https://www.itl.nist.gov/div898/handbook/prc/section2/prc262.htm
  def self.percentile(arr = [], value = 50)
    members = arr.sort
    n = members.length

    p = value / 100.0
    x = p * (n + 1)
    k = x.truncate
    d = x % 1

    return members.first if k.zero?
    return members.last if k >= n

    members[k - 1] + d * (members[k] - members[k - 1])
  end
end
