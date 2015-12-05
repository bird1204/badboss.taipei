require 'open-uri'
require 'json'
require 'illegal_boss/goverment/standard'
require 'illegal_boss/goverment/sexsual'
require 'illegal_boss/goverment/safety'

module IllegalBoss
  # Your code goes here...
  module Goverment
    private

    def get_json
      JSON.parse(open(@file_url).read)['result']['results']
    rescue StandardError => e
      raise "出錯了，檢查你的url : #{@file_url}"
    end

    def json_to_array
      get_json.collect { |record| hash(record) }
    end
  end
end
