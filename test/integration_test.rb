require 'test_helper'
require 'json'
require 'benchmark'

class IntegrationTest < Minitest::Test
  def data
    @data ||= load
  end

  def load
    file = File.read(File.join(File.dirname(__FILE__), 'data.json.txt'))
    raw_data = JSON.parse(file)

    hard_filter(raw_data).map do |record|
      { time: record['time_to_answer'], u: record['u'], theta: record['theta'] }
    end
  end

  def hard_filter(records)
    @hard_filter ||= records.filter do |record|
      record['time_to_answer'] >= 1500 && record['time_to_answer'] < 60_000
    end
  end

  def group_by(arr, key)
    arr.group_by do |r|
      r[key]
    end
  end

  def u_times(set)
    group_by(set, :u).transform_values do |records|
      times = records.map { |record| record[:time] }
      Meicho::InterquartileRange.new(times).tukey(:right)
    end
  end

  def engagement_for(times = [])
    Meicho::ProbabilityDensityFunction.new(times).integrate.map do |x, y|
      [(x / 1000.0).round, (y * 100).round]
    end
  end

  def significant_difference?(first_set, second_set)
    Meicho::MannWhitneyU.new(first_set, second_set).p_value(1) < 0.1
  end

  def process_set(set = [])
    u_times = u_times(set)
    if significant_difference?(*u_times.values)
      u_times.map do |u, times|
        Hash["u-#{u}", engagement_for(times)]
      end
    else
      [{ all: engagement_for(u_times.values.flatten) }]
    end
  end

  def test_breaking_down_response_times_per_theta_per_u_into_engagement_distributions
    sets = { all: process_set(data).reduce({}, :merge) }
    group_by(data, :theta).each do |theta, set|
      next if set.size < 40

      sets["theta-#{theta}"] = process_set(set).reduce({}, :merge)
    end

    assert_equal expected, sets
  end

  def expected # rubocop:disable Metrics/MethodLength
    {
      :all => {
        all: [[1, 27], [2, 50], [3, 59], [4, 57], [5, 64], [6, 75], [7, 78], [8, 78], [9, 87], [10, 100], [11, 96],
              [12, 74], [13, 57], [14, 54], [15, 54], [16, 46], [17, 32], [18, 22], [19, 28], [20, 39], [21, 44],
              [22, 44], [23, 42], [24, 38], [25, 30], [26, 20], [27, 10], [28, 4], [29, 4], [30, 8], [31, 13],
              [32, 16], [33, 15], [34, 12], [35, 8], [36, 3], [37, 1], [38, 1], [39, 3], [40, 4], [41, 0]]
      },
      'theta-0' => {
        'u-0' => [[1, 27], [2, 43], [3, 41], [4, 32], [5, 40], [6, 56], [7, 63], [8, 68], [9, 83], [10, 99], [11, 100],
                  [12, 79], [13, 57], [14, 53], [15, 53], [16, 46], [17, 34], [18, 25], [19, 27], [20, 35], [21, 40],
                  [22, 40], [23, 40], [24, 37], [25, 28], [26, 17], [27, 8], [28, 3], [29, 5], [30, 11], [31, 15],
                  [32, 15], [33, 11], [34, 8], [35, 5], [36, 2], [37, 1], [38, 1], [39, 4], [40, 5], [41, 0]],
        'u-1' => [[1, 47], [2, 65], [3, 82], [4, 93], [5, 99], [6, 100], [7, 98], [8, 93], [9, 87], [10, 80], [11, 71],
                  [12, 63], [13, 56], [14, 49], [15, 43], [16, 38], [17, 35], [18, 35], [19, 38], [20, 41], [21, 42],
                  [22, 41], [23, 38], [24, 32], [25, 26], [26, 19], [27, 12], [28, 7], [29, 4], [30, 3], [31, 3],
                  [32, 4], [33, 5], [34, 5], [35, 0]]
      }
    }
  end
end
