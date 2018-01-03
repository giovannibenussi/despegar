require_relative 'despegar_response'

module Despegar
  def self.get(url)
    response = open(url, allow_redirections: :safe).read
    DespegarResponse.new(OpenStruct.new(body:response))
  end
end
