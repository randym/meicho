module Meicho
  module Kernel
    def self.gaussian(value = 0)
      (1 / Math.sqrt(2 * Math::PI)) / Math.exp(-1 * (value**2 / 2))
    end
  end
end
