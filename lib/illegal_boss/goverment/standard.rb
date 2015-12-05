module IllegalBoss
  # Your code goes here...
  class Goverment::Standard
    attr_accessor  :file_url
    attr_reader :name, :owner, :date, :guilts

    def initialize(attributes = {})
      @file_url = attributes[:file_url]
      get_json(@file_url)
    end

    private

    def get_json url
      json_object = JSON.parse(open(url).read)
    end
  end
end
