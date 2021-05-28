module Meicho
  module Bandwidth
    # https://www.di.ubi.pt/~lfbaa/pubs/tecrep2008.pdf
    # plug-in estimator in the optimal AMISE estimator and an iterative algorithm

    def self.ste(arr = [], epsilon = 1)  # rubocop:disable Metrics/MethodLength
      n = arr.length
      h0 = nda1(arr)
      h1 = h0 + epsilon

      first_integral = lambda { |xi, xj|
        distance = xi - xj
        squared_distance = distance**2
        (squared_distance - 6 * h0**2)**2 - 24 * h0**4 * Math.exp(-1 * (distance / (2 * h0))**2)
      }

      k4acc = lambda { |v, i|
        i.times.reduce(0) do |sum, j|
          sum + first_integral.call(v, arr[j])
        end
      }

      while (h1 - h0).abs >= epsilon
        h0 = h1
        integral_sum = arr.each_with_index.reduce(0) do |acc, (v, i)|
          acc + k4acc.call(v, i)
        end
        k4 = 3 * n * h0 + (1 / (2 * h0**3)) * integral_sum
        h1 = (4 * n * h0**6 / k4)**(1 / 5.0)
        h1 = (h0 + h1) / 2
      end
      h1.round(3)
    end

    def self.nda0(arr = [])
      std = Meicho.std(arr)
      n = arr.length
      (1.06 * std * n**(-1 / 5.0)).round(3)
    end

    def self.nda1(arr = [])
      std = Meicho.std(arr)
      range = Meicho::InterquartileRange.new(arr).range / 1.34
      n = arr.length
      (0.9 * [std, range].min * (n**(-1 / 5.0))).round(3)
    end
  end
end
