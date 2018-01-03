class DespegarResponse
  def initialize(response)
    @response = response
  end

  def success?
    true
  end

  def content(as: nil)
    return @response.body if as.nil?

    JSON.parse(@response.body, object_class: as)
  end
end
