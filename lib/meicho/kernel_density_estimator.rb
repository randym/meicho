module Meicho
  class KernelDensityEstimator
    def initialize(members = [], step = nil)
      @members = members
      @step = step || downfactor10
      min = members.min - @step
      max = members.max + @step
      @points = (min..max).step(@step)
    end

    attr_reader :members, :step, :points

    def pdf
      @pdf ||= estimate
    end

    private

    def downfactor10
      @downfactor10 ||= (10.0**([Math.log10(Meicho.median(members)), 0.01].max.floor - 1))
    end

    def bandwidth
      @bandwidth ||= Meicho::Bandwidth.iterative_amise(members.dup.sort) || 0.1
    end

    def kernel(value)
      Meicho::Kernel.gaussian(value)
    end

    def divisor
      @divisor ||= members.length * bandwidth
    end

    def density_at(point)
      members.map do |member|
        kernel((point - member) / bandwidth)
      end.reduce(:+) / divisor
    end

    def estimate
      points.map { |point| [point, density_at(point)] }
    end
  end
end
