require 'nokogiri'
require 'open-uri'
module IllegalBoss
  # Your code goes here...
  module Web
    class Usalary
      # require 'illegal_boss' 
      # IllegalBoss::Web::Usalary
      attr_accessor  :file_url
      attr_reader :records

      def initialize(attributes = {})
        @file_url = attributes[:file_url] || 'http://www.ursalary.com/layoff_search.php?tag=1'
        @records = json_to_array
      end

      private

      def json_to_array
        @file_url = 'http://www.ursalary.com/layoff_search.php?tag=1'
        data_in_table = Nokogiri::HTML(open(@file_url)).css("tr").css("td")
        hash = {date: nil, name: nil, type: nil, guilts: nil}
        flag = 0
        records = []
        data_in_table.each_with_index do |data, index|
          next if index % 5 == 0 && index > 0
          next if index == 4
          hash[hash.keys[flag]] = data.text

          if flag == 3
            records << hash
            flag == 0
          else
            flag += 1
          end
        end
        return records
      rescue StandardError => e
        raise "出錯了，檢查你的url : #{@file_url}"
      end
      
    end
  end
end
