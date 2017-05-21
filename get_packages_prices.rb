require 'tty'
require 'tty-table'
require_relative 'get_packages_prices_params.rb'
require_relative 'package.rb'
require_relative 'lib/extensions.rb'

# prompt = TTY::Prompt.new

options = DespegarPackages.params

start_date = Date.new(2017, 8, 6)
end_date   = Date.new(2017, 8, 16)
duration = 10
range = 2

threads = []
results = Hash.new{ |hash, key| hash[key] = {}}
start_date.upto(end_date).each do |departure|
  back_end = departure + duration
  back_end.upto(back_end + range).each do |back|
    package = Package.new(options, debug: true)
    package.departure = departure
    package.back = back
    # puts package.url
    threads << Thread.new(package, departure, back) do |package, departure, back|
      package.load
      results[ departure.to_s ] ||= []
      results[ departure.to_s ][ back.to_s ] = package
    end
    threads.each(&:join) if threads.count == 5
    # puts package.lowest_price.to_clp
  end
end
threads.each(&:join)

table = TTY::Table.new
table << ['-'] + (start_date+1).upto(end_date).to_a.map(&:to_s)

# puts results.keys.to_s
dates = start_date.upto(end_date).to_a.each(&:to_s)
results.keys.each do |departure|
  partial = []
  dates.each do |date|
    # puts "From #{departure} to #{date}"
    if results[departure][date]
      partial << results[departure][date].lowest_price.to_clp
    else
      partial << '-'
    end
  end
  table << partial
end
puts table
# results.keys.each do |departure|
#   partial = [departure]
#   results[departure].keys.each do | back |
#     package = results[departure][back]
#     puts "From: #{departure} to #{back}: #{package.lowest_price.to_clp}"
#     partial.push(package.lowest_price.to_clp)
#   end
#   table << partial
#   puts
# end
#
# puts table
