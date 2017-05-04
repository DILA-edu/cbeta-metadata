# 統計列出各個朝代的典籍數

require 'csv'
require 'json'

OUT = '../dynasty-all.csv'

all = {}
Dir["../year-by-canon/*.json"].each do |f|
  s = File.read(f)
  data = JSON.parse(s)
  data.each_value do |v|
    next unless v.key? 'dynasty'
    d = v['dynasty']
    if all.key? d
      all[d] += 1
    else
      all[d] = 1
    end
  end
end

r = "朝代,起始年,結束年,典籍數\n"
CSV.foreach("../dynasty-year.csv") do |row|
  dynasties = row[0]
  y1 = row[1]
  y2 = row[2]
  count = 0
  dynasties.split('/').each do |dynasty|
    if all.key? dynasty
      count += all[dynasty]
      all.delete dynasty
    end
  end
  unless count == 0
    r += "#{dynasties},#{y1},#{y2},#{count}\n"
  end
end

unless all.empty?
  puts "未列到的朝代"
  all.each_pair do |k,v|
    puts k
  end
end

File.write(OUT, r)