# 統計列出各個朝代的典籍數

require 'csv'
require 'json'

OUT = '../dynasty-all.csv'
OUT_WORKS = '../dynasty-works.json'

def combine_and_sort(all)
  # 朝代順序依據 dynasty-year.csv
  CSV.foreach("../dynasty-year.csv") do |row|
    dynasties = row[0]
    y1 = row[1].to_i
    y2 = row[2].to_i
    
    works = []
    dynasties.split('/').each do |dynasty|
      next unless all.key? dynasty
      next if all[dynasty].empty?      
      works += all[dynasty]
      all.delete dynasty
    end
    
    unless works.empty?
      $dynasty_works_count << [dynasties, y1, y2, works.size]
      
      dynasty_h = { key: dynasties }
      title = "#{dynasties} #{y1} "
      title += y1<0 ? 'BCE' : 'CE'
      title += " ~ #{y2} "
      title += y2<0 ? 'BCE' : 'CE'
      dynasty_h[:title] = title
      dynasty_h[:children] = works
      $dynasty_works << dynasty_h   
    end
  end
  $dynasty_works << {
    key: 'unknown',
    title: '朝代未知',
    children: $unknown
  }
end

def read_works_dynasty
  r = {}
  Dir["../year-by-canon/*.json"].each do |f|
    s = File.read(f)
    data = JSON.parse(s)
    data.each_pair do |work_id,v|
      work_h = {
        key: work_id,
        title: v['title']
      }
      if v.key? 'dynasty'
        d = v['dynasty']
        r[d] = [] unless r.key? d
        r[d] << work_h
      else
        $unknown << work_h
      end
    end
  end
  r
end

def write_count
  CSV.open(OUT, "wb") do |csv|
     csv << %w(朝代 起始年 結束年 典籍數)
     $dynasty_works_count.each do |a|
       csv << a
     end
  end
end

def write_works
  r = [
    {
      title: '選擇全部',
      children: $dynasty_works
    }
  ]
  s = JSON.pretty_generate(r)
  File.write(OUT_WORKS, s)
end

$unknown = []
all = read_works_dynasty

$dynasty_works = []
$dynasty_works_count = []
combine_and_sort(all)

write_count
write_works

unless all.empty?
  puts "未列到的朝代"
  all.each_pair do |k,v|
    puts k
  end
end