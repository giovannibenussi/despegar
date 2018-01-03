class DespegarResponse
  def initialize(response)
    require 'pry'
    @response = response
  end

  def success?
    true
  end

  def content(as: nil)
    content!(as: as)
  rescue JSON::ParserError => e
    if  e.message =~ /^[0-9]+: unexpected token at ''$/
      puts "Error, maybe you need to complete a captcha in #{getURL}"
      exit
    end
  end

  def content!(as: nil)
    return @response.body if as.nil?

    JSON.parse(@response.body, object_class: as)
  end
end
