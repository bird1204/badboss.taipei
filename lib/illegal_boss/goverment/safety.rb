module IllegalBoss
  # Your code goes here...
  module Goverment
    class Safety
      include IllegalBoss::Goverment
      # IllegalBoss::Goverment::Safety
      attr_accessor  :file_url
      attr_reader :records

      def initialize(attributes = {})
        @file_url = attributes[:file_url] || 'http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=6cf496a9-7c84-4670-90ca-c329c828ea7f'
        @records = json_to_array
      end

      private

      def hash record
        { date: record['處分日期'],
          owner: record['負責人'],
          name: record['事業單位名稱/自然人姓名'],
          guilts: (record['違反法規內容'].present?) ? record['違反法規內容'].split(';') : record['違反職業安全衛生法條款'].split('及;')
          }
      end
    end
  end
end
