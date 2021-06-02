# frozen_string_literal: true

module Meicho
  class InterquartileRange
    def initialize(members = [])
      @members = members
    end

    def self.tukey(members = [], tails = :both)
      InterquartileRange.new(members).tukey(tails)
    end

    def tukey(tails = :both)
      case tails
      when :left
        filter(left)
      when :right
        filter(right)
      else
        filter(both)
      end
    end

    def q1
      @q1 ||= Meicho.median(members[0..mid.floor - 1])
    end

    def q3
      @q3 ||= Meicho.median(members[mid.floor..-1])
    end

    def range
      @range ||= q3 - q1
    end

    attr_reader :members

    private

    def mid
      @mid ||= members.length / 2.0
    end

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
