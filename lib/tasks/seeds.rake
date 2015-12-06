require 'illegal_boss'
namespace :seeds do
  desc "make fake data"
  task goverment_standard: :environment do
    IllegalBoss::Goverment::Standard.new.records.each do |data|
      c = Company.new(name: data[:name], owner: data[:owner])
      data[:guilts].each do |g_name|
        c.guilts.build(name: g_name)
      end
      c.alias.build(keyword: data[:name])
      c.scores.build(good_or_bad: false)
      c.save!
      p "#{data[:name]}=========儲存完成"
    end
    p "goverment_standard=========完成"
  end

  task goverment_safety: :environment do
    IllegalBoss::Goverment::Safety.new.records.each do |data|
      c = Company.new(name: data[:name], owner: data[:owner])
      data[:guilts].each do |g_name|
        c.guilts.build(name: g_name)
      end
      c.alias.build(keyword: data[:name])
      c.scores.build(good_or_bad: false)
      c.save!
      p "#{data[:name]}=========儲存完成"
    end
    p "goverment_safety=========完成"
  end

  task goverment_sexsual: :environment do
    IllegalBoss::Goverment::Sexsual.new.records.each do |data|
      c = Company.new(name: data[:name], owner: data[:owner])
      data[:guilts].each do |g_name|
        c.guilts.build(name: g_name)
      end
      c.alias.build(keyword: data[:name])
      c.scores.build(good_or_bad: false)
      c.save!
      p "#{data[:name]}=========儲存完成"
    end
    p "goverment_sexsual=========完成"
  end

  desc "rebuild table"
  task rebuild_table: [:clear_data, "db:migrate", "db:seed"]
end