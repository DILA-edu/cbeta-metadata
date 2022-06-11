# 統計 CBETA 各經字數
# 校勘不列入統計

require 'cbeta'

XML = '/Users/ray/git-repos/cbeta-xml-p5a'
PUNCS = /[ ,\.\(\)\[\]'"　。‧．，、；？！：︰（）「」『』《》＜＞〈〉〔〕［］【】〖〗〃…—─～│┬▆＊＋－＝]/

def handle_canon(canon)
  canon_folder = File.join(XML, canon)
  Dir.entries(canon_folder).each do |vol|
    next if vol.start_with? '.'
    vol_folder = File.join(canon_folder, vol)
    handle_vol(vol_folder)
  end
end

def handle_text(e)
  s = e.content().gsub(/[\t\r\n]/, '')  
  s.gsub! PUNCS, ''
  s.each_char { |c| $char_freq[c] += 1 }
end

def handle_vol(folder)
  Dir.entries(folder).each do |work|
    next if work.start_with? '.'
    basename = File.basename(work, '.xml')
    $work_id = CBETA.get_work_id_from_file_basename(basename)
    
    path = File.join(folder, work)
    handle_work(path)
  end
end

def handle_work(path)
  print File.basename(path, '.xml') + ' '
  doc = File.open(path) { |f| Nokogiri::XML(f) }
  doc.remove_namespaces!()
  traverse(doc.root)
end

def thousand_seperator(i)
  i.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
end

def traverse(e)
  e.children.each { |c| 
    next if c.comment?
    if c.text?
      handle_text(c)
      next
    end
    case c.name
    when 'foreign', 'mulu', 'rdg', 'reg', 'sic', 'teiHeader'
    when 'note'
      traverse(c) if c['place'] == 'inline'
    when 'g'
      id = c['ref'].sub(/^#/, '')
      $char_freq[id] += 1
    when 't'
      if c.key? 'place'
        traverse(c) unless c['place'].include? 'foot'
      else
        traverse(c)
      end
    else
      traverse(c)
    end
  }
end

$char_freq = Hash.new(0)

puts "read xml files"
Dir.entries(XML).sort.each do |canon|
  next if canon.start_with? '.'
  next if canon.size > 2
  handle_canon(canon)
end

puts "字頻排序"
chars = $char_freq.sort_by { |_k, v| -v }

puts "write ../char-freq.csv"
File.open('../char-freq.csv', 'w') do |f|
  f.puts "char,count"
  chars.each { |c, i| f.puts "#{c},#{i}"}
end
