module TestPackage
  require 'json'

  def load
    file = File.read('lib/test/responses/packages.json')
    @response = JSON.parse(file).with_indifferent_access
  end
end
