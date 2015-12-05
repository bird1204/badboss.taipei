module IllegalBoss
  # Your code goes here...
  module Goverment
    class Sexsual
      include IllegalBoss::Goverment
      # IllegalBoss::Goverment::Sexsual
      attr_accessor  :file_url
      attr_reader :records

      def initialize(attributes = {})
        @file_url = attributes[:file_url] || 'http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a59be64e-7102-431c-85be-0888b8f84824'
        @records = json_to_array
      end

      private

      def hash record
        { date: record['處分日期'],
          owner: record['事業單位代表人'],
          name: record['事業單位名稱/自然人姓名'],
          guilts: (record['違反法規內容'].present?) ? record['違反法規內容'].split(';') : record['違反性別工作平等法條款'].split('及;')
          }
      end
    end
  end
end
