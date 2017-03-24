# 統計 CBETA 各經字數
# 校勘不列入統計

require 'cbeta'

XML = '/Users/ray/git-repos/cbeta-xml-p5a'
PUNCS = ' .[]　「」『』《》＜＞〈〉〔〕［］【】〖〗（）•．：，、；？！。'
PUNCS_REG = Regexp.escape(PUNCS)

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
  
  s.gsub! /[#{PUNCS_REG}]/, ''
  $counts_without_puncs[$work_id] += s.size
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
  puts "handle work #{path}"
  doc = File.open(path) { |f| Nokogiri::XML(f) }
  doc.remove_namespaces!()
  traverse(doc.root)
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
  write_to_folder(folder, canon, $counts_with_puncs)
  
  folder = File.join('..', 'without-puncs')
  write_to_folder(folder, canon, $counts_without_puncs)
end

def write_to_folder(folder, canon, data)
  Dir.mkdir(folder) unless Dir.exist? folder
  fn = File.join(folder, "#{canon}.csv")
  CSV.open(fn, "wb") do |csv|
    csv << ["work_id", "char_count"]
    data.each_pair do |k,v|
      csv << [k, v]
    end
  end
end

Dir.entries(XML).each do |canon|
  next if canon.start_with? '.'
  next if canon.size > 2
  handle_canon(canon)
end