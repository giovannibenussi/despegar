module DespegarPackages
  def self.params
    require 'optparse'
    options = default_params
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'

      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        options[:verbose] = v
      end
    end.parse!
    options
  end

  private_class_method

  def self.default_params
    {
      departure:    '2017-08-06',
      back:      '2017-08-16',
      distribution: 1,
      from: 'AIR_197776',
      locale: 'es-CL',
      to:   'AIR_197343'
    }
  end

end
