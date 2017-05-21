require 'active_support/all'

duration = 10
margin = 1

start_date = Date.current - 2.week
end_date   = Date.current

puts "Getting prices from: #{start_date} to #{end_date}"

class DateRange < Range
  # def initialize(from:, to:, exclude_end: false)
  #   super(from, to, exclude_end)
  # end
end

evaluation_range = DateRange.new(start_date + margin,
                                 end_date - duration - margin)
evaluation_range.each do |start_at|
  end_at = start_at + duration
  start_range = DateRange.new(start_at - margin, start_at + margin)
  end_range = DateRange.new(end_at - margin, end_at + margin)

  start_range.each do |start_at|
    end_range.each do |end_at|
      puts "From #{start_at} to #{end_at}"
    end
    puts
  end
end
