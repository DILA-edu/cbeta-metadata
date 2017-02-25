require 'json'
require 'set'

IN = '../creators-by-canon'
OUT = '../all-creators.txt'
OUT_JSON = '../all-creators.json'

def handle_file(fn)
  s = File.read(fn)
  creators = JSON.parse(s)
  creators.each do |k, v|
    if v.key? 'creators_with_id'
      v['creators_with_id'].split(';').each do |c|
        if c.match(/^(.*?)\((A\d{6})\)$/)
          $creators[$2]=$1 unless $creators.key? $2
        else
          puts "#{k} 格式錯誤：#{c}"
        end
      end
    else
      #puts "#{k} 缺 creator id"
    end
  end
end

$creators = {}
Dir["#{IN}/*.json"].each do |f|
  handle_file(f)
end

$creators = $creators.to_a.sort

fo = File.open(OUT, 'w')
$creators.each do |c|
  fo.puts c.join(',')
end
fo.close

s = JSON.pretty_generate($creators)
File.write(OUT_JSON, s)