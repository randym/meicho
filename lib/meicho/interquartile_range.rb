require 'bigdecimal'

module Meicho
  class InterquartileRange
    def initialize(members = [])
      @members = members
    end

    def self.tukey(members = [], tails = :both)
      InterquartileRange.new(members).tukey(tails)
    end

    def tukey(tails = :both)
      return filter(left) if tails == :left
      return filter(right) if tails == :right

      filter(both)
    end

    def q1
      @q1 ||= Meicho.percentile(members, 25)
    end

    def q3
      @q3 ||= Meicho.percentile(members, 75)
    end

    def range
      @range ||= q3 - q1
    end

    attr_reader :members

    private

    def filter(lam)
      members.each_with_object([]) do |v, acc|
        acc.push(v) if lam.call(v)
      end
    end

    def min
      @min ||= q1 - 1.5 * range
    end

    def max
      @max ||= q3 + 1.5 * range
    end

    def left
      ->(v) { v > min }
    end

    def right
      ->(v) { v < max }
    end

    def both
      ->(v) { left.call(v) && right.call(v) }
    end
  end
end
