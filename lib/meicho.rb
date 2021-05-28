require 'meicho/version'
require 'meicho/interquartile_range'
require 'meicho/kernel'
require 'meicho/bandwidth'
require 'meicho/kernel_density_estimator'
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

  # erm.. median
  def self.median(arr = [])
    n = arr.length
    mid = n / 2
    return quickselect(arr, mid.floor) if n.odd?

    (quickselect(arr, mid - 1) + quickselect(arr, mid)) / 2
  end

  def self.mean(arr = [], biased: true)
    n = arr.length
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
end
