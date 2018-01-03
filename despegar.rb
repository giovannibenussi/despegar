module Despegar
  def self.get(url)
    response = open(getURL, allow_redirections: :safe).read
    DespegarResponse.new(response)
  end
end
