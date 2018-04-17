require 'csv'
require 'json'
require 'pp'
require 'set'
require 'unihan2'

IN = '../creators-by-canon'
OUT = '../all-creators.txt'
OUT_JSON = '../all-creators.json'
OUT_STROKE = '../creators-by-strokes-with-works.json'
OUT_STROKE2 = '../creators-by-strokes.json'

def handle_file(fn)
  s = File.read(fn)
  creators = JSON.parse(s)
  creators.each do |work_id, v|
    title = v['title'].sub(/\(第\d+卷\-第\d+卷\)$/, '')
    title.sub!(/\(第\d+卷\)$/, '')
    v['long_title'] = "#{work_id} #{title} (#{$juans[work_id]}卷)"
    v['long_title'] += "【#{v['byline']}】" if v.key? 'byline'
    
    if v.key? 'creators_with_id'
      s = v['creators_with_id']
      if s.include? ','
        puts fn
        puts "creators_with_id 欄位不應有逗點: #{s}" 
        puts "如果是多個作譯者，應以半形分號隔開"
        abort
      end
      
      s.split(';').each do |c|
        if c.match(/^(.*?)\((A\d{6})\)$/)
          name = $1
          k = $2
          $creators[k]=name unless $creators.key? k
          record_by_stroke(k, name, work_id, v)
        else
          puts "#{k} 格式錯誤：#{c}"
        end
      end
    else
      $unknown << {
        key: work_id,
        title: v['long_title']
      }
    end
  end
end

def output_by_strokes
  r = [
    { 
      title: '選擇全部', children: []
    }
  ]
  all_strokes = $strokes.to_a.sort
  s = JSON.pretty_generate(all_strokes)
  File.write('temp.json', s)
  
  all_strokes.each do |stroke_a|
    stroke = stroke_a[0]
    chars_h = stroke_a[1]
    
    stroke_children = []
    r.first[:children] << {
      title: "#{stroke}劃(stroke)",
      children: stroke_children
    }
    
    chars_h.each_pair do |char, creators_h|
      char_children = []
      stroke_children << {
        title: char,
        children: char_children
      }
      creators_h.each_pair do |creator_key, creator_h|
        char_children << {
          key: creator_key,
          title: creator_h[:title],
          children: creator_h[:children]
        }
      end
    end    
  end
  
  r.first[:children] << {
    title: "缺作譯者 ID",
    children: $unknown
  }
  
  s = JSON.pretty_generate(r)
  puts "write #{OUT_STROKE}"
  File.write(OUT_STROKE, s)
  
  r.first[:children].pop
  
  r.first[:children].each do |stroke|
    stroke[:children].each do |char|
      char[:children].each do |creator|
        creator.delete(:children)
      end
    end
  end
  
  s = JSON.pretty_generate(r)
  puts "write #{OUT_STROKE2}"
  File.write(OUT_STROKE2, s)
end

def read_extent(folder)
  r = {}
  Dir.entries(folder).each do |f|
    next if f.start_with? '.'
    path = File.join(folder, f)
    CSV.foreach(path, headers: true) do |row|
      r[row['典籍編號']] = row['卷數']
    end
  end
  r
end

def record_by_stroke(creator_key, name, work_id, work_hash)
  char = name[0]
  stroke = $unihan.strokes(char)
  $strokes[stroke]={} unless $strokes.key? stroke
  
  h = $strokes[stroke]
  h[char]={} unless h.key? char
  
  h = $strokes[stroke][char]
  unless h.key? creator_key
    h[creator_key] = { 
      title: name,
      children: []
    }
  end
  
  a = $strokes[stroke][char][creator_key][:children]
  a << {
    key: work_id,
    title: work_hash['long_title']
  }
end

$juans = read_extent('../../titles/titles-by-canon')

$creators = {}
$strokes = {}
$unihan = Unihan2.new
$unknown = []

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
puts "write #{OUT_JSON}"
File.write(OUT_JSON, s)

output_by_strokes