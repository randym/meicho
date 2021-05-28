module Meicho
  class KernelDensityEstimator
    def initialize(members = [], kernel = Meicho::Kernel.gaussian)
      @member = members
      @kernel = kernel || Meicho::Kernel.gaussian
      @points = points || members.length
      @h = bandwidth || Meicho::Bandwidth.ste(members, members.min / 10)
    end

    def pdf
      @pdf ||= []
    end
  end
end
