require 'cbeta'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'
OUT = '../titles-by-canon'

def handle_canon(canon)
  $result = {}
  path = File.join(IN, canon)
  Dir.entries(path).each do |f|
    next if f.start_with? '.'
    handle_vol(canon, f)
  end
  fn = File.join(OUT, canon+'.csv')
  File.open(fn, 'w') do |f|
    $result.keys.sort.each do |k|
      f.puts "#{k},#{$result[k]}"
    end
  end
end

def handle_file(fn)
  puts "handle file: #{fn}"
  doc = CBETA.open_xml(fn)
  title = doc.at('//title').text.split.last
  title.sub!(/^(.*?)\(第\d+卷\-第\d+卷\)$/, '\1')
  
  basename = File.basename(fn, '.xml')
  work = CBETA.get_work_id_from_file_basename(basename)
  $result[work] = title
  $count += 1
end

def handle_vol(canon, vol)
  path = File.join(IN, canon, vol)
  Dir.entries(path).each do |f|
    next if f.start_with? '.'
    file_path = File.join(path, f)
    handle_file(file_path)
  end
end

Dir.mkdir(OUT) unless Dir.exist?(OUT)

$count = 0
Dir.entries(IN).each do |f|
  next if f.start_with? '.'
  next if f.size > 2
  handle_canon(f)
end

puts "共 #{$count} 筆"