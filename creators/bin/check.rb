# 列出缺少「作譯者資訊」或「作譯者ID」的典籍

require 'csv'
require 'json'

WORKS = '../../work-id'
CREATORS = '../creators-by-canon'
OUT = '../out'

def chk_canon(canon)
  work_id_file = File.join(WORKS, "#{canon}.csv")
  
  creators_file = File.join(CREATORS, "#{canon}.json")
  s = File.read(creators_file)
  creators = JSON.parse(s)
  
  CSV.foreach(work_id_file, headers: true) do |row|
    work_id = row['work']
    if creators.key? work_id
      unless creators[work_id].key? 'creators_with_id'
        $fo.puts "#{work_id} 缺作譯者ID"
      end
    else
      $fo.puts "#{work_id} 缺作譯者資訊"
    end
  end
end

Dir.mkdir(OUT) unless Dir.exist? (OUT)
$fo = File.open("#{OUT}/check.txt", 'w')

Dir.entries(WORKS).each do |f|
  next unless f.end_with? '.csv'
  canon = File.basename(f, '.csv')
  chk_canon(canon)
end