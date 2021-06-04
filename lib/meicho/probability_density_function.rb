module Meicho
  class ProbabilityDensityFunction
    def self.from(members = [])
      pdf = ProbabilityDensityFunction.new(members)
      yield pdf if block_given?
      pdf
    end

    def initialize(members = [], granularity = nil)
      @granularity = granularity
      @members = members
      yield self if block_given?
    end

    attr_accessor :granularity

    attr_writer :transform, :members

    def transform
      @transform ||= ->(v) { v }
    end

    def members
      @members ||= []
    end

    def pdf
      @pdf ||= generate_density_function
    end

    def integrate(every = 1, scaled: true)
      integrals = (0..(pdf.length - 1)).step(every).map do |i|
        integrate_at(pdf[i], pdf[i + 1])
      end
      scaling_factor = scaled ? 1 / integrals.map { |_x, y| y }.max : 1
      scale = ->(value) { value * scaling_factor }

      integrals.map { |x, y| [(x / every).round, scale.call(y).round(2)] }
    end

    private

    def integrate_at(first_point, second_point)
      x1, y1 = first_point
      x2, y2 = (second_point || first_point)
      [x1, ((x2 - x1) * (y1 + y2)) / 2]
    end

    def generate_density_function
      data = members.map(&transform)
      Meicho::KernelDensityEstimator.new(data, granularity).pdf
    end
  end
end
