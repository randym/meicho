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
      @z_score ||= ((u_score - (length_product / 2.0)) / u_std).to_f.round(2)
    end

    def p_value(tails = 2)
      ((1 - Meicho.p_value(z_score.abs)) * tails).round(3)
    end

    private

    def length_sum
      @length_sum ||= first.length + second.length
    end

    def length_product
      @length_product ||= first.length * second.length
    end

    def tie_adjustment
      return 0 unless ties.size

      ties.values.reduce(0) do |tie_count, sum|
        sum + (tie_count**3 - tie_count) / (length_sum * (length_sum - 1.0))
      end
    end

    def u_std
      return Math.sqrt((length_product * (length_sum + 1)) / 12.0) unless ties.size

      Math.sqrt((length_product / 12.0) * (length_sum + 1 - tie_adjustment))
    end

    def kernel(first_value, second_value)
      sign = first_value <=> second_value

      return 0 if sign == -1
      return 1 if sign == 1

      ties[first_value] = (ties[first_value] || 0) + 1
      0.5
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
