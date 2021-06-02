module Meicho
  class MannWhitneyU
    def initialize(first = [], second = [])
      @first = first
      @second = second
      @ties = {}
    end

    attr_reader :ties, :first, :second

    def u_score
      @u_score ||= calculate.round(3)
    end

    def z_score
      @z_score ||= ((u_score - (length_product / 2.0)) / u_std).to_f.round(2).abs
    end

    # FZ(z)=12π‾‾‾√∫z−∞exp{−u22}du
    def p
      cumulative = integral = z_score * Math.exp(-0.5 * z_score**2) / Math.sqrt(2 * Math::PI)
      last = 0
      iteration = 2
      while cumulative > last
        last = cumulative
        integral *= z_score**2 / iteration += 1
        cumulative += integral
      end

      0.5 + cumulative
    end

    private

    def length_total
      @length_total ||= first.length + second.length
    end

    def length_product
      @length_product ||= first.length * second.length
    end

    def tie_adjustment
      return 0 unless ties.size

      ties.values.reduce(0) do |tie_count, sum|
        sum + (tie_count**3 - tie_count) / (length_total * (length_total - 1.0))
      end
    end

    def u_std
      return Math.sqrt((length_product * (length_total + 1)) / 12.0) unless ties.size

      Math.sqrt((length_product / 12.0) * (length_total + 1 - tie_adjustment))
    end

    def kernel(first_value, second_value)
      sign = first_value <=> second_value

      if sign.zero?
        ties[first_value] = (ties[first_value] || 0) + 1
        return 0.5
      end

      return 0 if sign == -1

      1.0
    end

    def calculate
      total = 0
      first.each do |first_value|
        second.each do |second_value|
          total += kernel(first_value, second_value)
        end
      end
      [total, length_product - total].min
    end
  end
end
