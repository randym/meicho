module Meicho
  class KernelDensityEstimator
    def initialize(observations = [], step = 1)
      @observations = observations
      @step = step
    end

    attr_reader :observations, :step

    def pdf
      @pdf ||= estimate
    end

    private

    def bandwidth
      @bandwidth ||= Meicho::Bandwidth.iterative_amise(observations.dup.sort)
    end

    def kernel(value)
      Meicho::Kernel.gaussian(value)
    end

    def points
      @points ||= (observations.min..observations.max).step(step).to_a
    end

    def divisor
      @divisor ||= observations.length * bandwidth
    end

    def density_at(point)
      observations.map { |observation| kernel((point - observation) / bandwidth) }.reduce(:+) / divisor
    end

    def estimate
      points.map { |point| [point, density_at(point)] }
    end
  end
end
