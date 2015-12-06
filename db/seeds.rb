# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "建立20筆company"

create_company = for i in 1..20 do
              Company.create!([name: "company.#{i}", owner: "boss#{i}", no: "#{i}", reg_date:"2015/12/#{i}",
                good_counter:"#{i}", bad_counter: "#{i}", website: "http://test#{i}.taipei")
            end
          end
