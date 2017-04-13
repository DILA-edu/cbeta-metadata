# 統計 CBETA 各經字數
# 校勘不列入統計

require 'cbeta'

XML = '/Users/ray/git-repos/cbeta-xml-p5a'
PUNCS = /[ \.\[\]　「」『』《》＜＞〈〉〔〕［］【】〖〗（）•．：，、；？！。]/

def add_char_freq(c)
  if $char_freq.key? c
    $char_freq[c] += 1
  else
    $char_freq[c] = 1
  end
end

def handle_canon(canon)
  canon_folder = File.join(XML, canon)
  $counts_with_puncs = {}
  $counts_without_puncs = {}
  Dir.entries(canon_folder).each do |vol|
    next if vol.start_with? '.'
    vol_folder = File.join(canon_folder, vol)
    handle_vol(vol_folder)
  end
  write_char_counts(canon)
end

def handle_text(e)
  s = e.content().gsub(/[\t\r\n]/, '')
  $counts_with_puncs[$work_id] += s.size
  
  s.gsub! PUNCS, ''
  $counts_without_puncs[$work_id] += s.size
  s.each_char { |c| add_char_freq(c) }
end

def handle_vol(folder)
  Dir.entries(folder).each do |work|
    next if work.start_with? '.'
    basename = File.basename(work, '.xml')
    $work_id = CBETA.get_work_id_from_file_basename(basename)
    
    $counts_with_puncs[$work_id]    = 0 unless $counts_with_puncs.include? $work_id
    $counts_without_puncs[$work_id] = 0 unless $counts_without_puncs.include? $work_id
    
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
      $counts_with_puncs[$work_id]    += 1
      $counts_without_puncs[$work_id] += 1
      add_char_freq(c['ref'][1..-1])
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

def write_char_counts(canon)
  folder = File.join('..', 'with-puncs')
  write_to_folder(folder, canon, $counts_with_puncs, true)
  
  folder = File.join('..', 'without-puncs')
  write_to_folder(folder, canon, $counts_without_puncs, false)
end

def write_to_folder(folder, canon, data, puncs)
  Dir.mkdir(folder) unless Dir.exist? folder
  fn = File.join(folder, "#{canon}.csv")
  CSV.open(fn, "wb") do |csv|
    csv << ["work_id", "char_count"]
    data.each_pair do |k,v|
      csv << [k, v]
      if puncs
        $total_with_puncs += v
      else
        $total_without_puncs += v
      end
    end
  end
end

$char_freq = {}
$total_with_puncs = 0
$total_without_puncs = 0

puts "read xml files"
Dir.entries(XML).each do |canon|
  next if canon.start_with? '.'
  next if canon.size > 2
  handle_canon(canon)
end

puts "write ../summary.txt"
File.open('../summary.txt', 'w') do |f|
  f.puts "含標點總字數：%s" % thousand_seperator($total_with_puncs)
  f.puts "不含標點總字數：%s" % thousand_seperator($total_without_puncs)
end

puts "字頻排序"
chars = $char_freq.to_a
chars.sort! { |x,y| y[1] <=> x[1] }

puts "write ../char-freq.csv"
File.open('../char-freq.csv', 'w') do |f|
  f.puts "char,count"
  chars.each { |a| f.puts "#{a[0]},#{a[1]}"}
end