require 'colorize'
require 'open-uri'
require 'open_uri_redirections'
require 'active_support'
require 'active_support/core_ext/object/to_query'
require_relative 'despegar_response'

class Trip
    def initialize(number, price_ranges)
        @number = number
        @price_ranges = price_ranges
    end

    def getLowestPriceWithColor

        # return lowest_price.formatWithPoints if @price_ranges.nil?

        # output = lowest_price.formatWithPoints
        output = @number.to_s
        if @number >= @price_ranges[:excessive]
            output = output.red
        elsif @number >= @price_ranges[:expensive]
            output = output.light_red
        elsif @number >= @price_ranges[:moderate]
            output = output.yellow
        elsif @number >= @price_ranges[:moderate_to_cheap]
            output = output.light_yellow
        elsif @number >= @price_ranges[:cheap]
            output = output.green
        else
            output = output.light_green
        end
        output
    end
end

class Trip
    attr_accessor :base_url, :start_date, :end_date, :debug
    attr_reader :response

    def initialize(origin_city = nil, destination_city = nil)
        @origin_city = origin_city
        @destination_city = destination_city
    end

    def details
        "City code: #{@origin_city} | from: #{@start_date} to #{@end_date}"
    end

    def getURL
      "https://www.despegar.cl/shop/flights-busquets/api/v1/web/search?" + params.to_query
    end

    def params
      start_date_str = @start_date.strftime('%F')
      end_date_str = @end_date.strftime('%F')
      {
        adults: 1,
        children: 0,
        infants: 0,
        offset: 0,
        limit: 10,
        site: 'CL',
        channel: 'SITE',
        from: @origin_city,
        to: @destination_city,
        departureDate: start_date_str,
        returnDate: end_date_str,
        groupBy: 'default',
        orderBy: 'total_price_ascending',
        currency: 'CLP',
        viewMode: 'CLUSTER',
        language: 'es_CL',
        streaming: true,
        airlineSummary: false,
        user: '6a8418ad-1da5-41df-8418-ad1da5d1df2a',
        _: 1514678611138
      }
    end

    def getLowestPrice
      highlights = @response.map { |r| r.arg.highlights }.compact
      highlights.map { |h| h.cheapestItinerary.price.amount }.min
    end

    def getData
        if @debug
          response = File.read('lib/test/responses/flights.json')
          response = DespegarResponse.new(OpenStruct.new(body: response))
        else
          response = Despegar.get(getURL)
        end
        begin
          @response = response.content(as: OpenStruct)
        rescue JSON::ParserError => e
          if  e.message =~ /^[0-9]+: unexpected token at ''$/
            puts "Error, maybe you need to complete a captcha in #{getURL}"
            exit
          end
        end
    end

    def setRanges(price_ranges)
        @price_ranges = price_ranges
    end

    def getLowestPriceWithColor
        lowest_price = getLowestPrice

        return lowest_price.formatWithPoints if @price_ranges.nil?

        price_output = lowest_price.formatWithPoints
        if lowest_price >= @price_ranges['excessive']
            price_output = price_output.red
        elsif lowest_price >= @price_ranges['expensive']
            price_output = price_output.light_red
        elsif lowest_price >= @price_ranges['moderate']
            price_output = price_output.yellow
        elsif lowest_price >= @price_ranges['moderate_to_cheap']
            price_output = price_output.light_yellow
        elsif lowest_price >= @price_ranges['cheap']
            price_output = price_output.green
        else
            price_output = price_output.light_green
        end
        price_output
    end

    def to_s
        date_format = '%d %b'
        "Trip to #{@origin_city} from #{@start_date.strftime(date_format)} to #{@end_date.strftime(date_format)}: #{getLowestPriceWithColor}"
    end
end
