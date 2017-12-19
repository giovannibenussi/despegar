class Package
  require 'http'
  require 'active_support/all'

  require_relative 'test_package.rb'

  def test
  end

  def initialize(options, debug: false)
    @options = options
    extend TestPackage if debug
  end

  def url
    'https://www.despegar.cl/shapi/packages?' + @options.to_query
  end

  def load
    res = HTTP.get(url)
    return nil unless res.code.between?(200, 299)
    @response = JSON.parse(res.body).with_indifferent_access
  end

  def prices
    @response['items'].each_with_object([]) do |item, result|
      item['prices'].each do |price|
        next unless price['currency']['code'] == 'CLP'
        result << price['total']['total']
      end
    end
  end

  def formatted_prices
    prices.map(&:to_clp)
  end

  def lowest_price
    prices.min
  end

  def departure=(value)
    @options[:departure] = value
  end
  def back=(value)
    @options[:back] = value
  end
  def departure
    @options[:departure]
  end
  def back
    @options[:back]
  end
end
