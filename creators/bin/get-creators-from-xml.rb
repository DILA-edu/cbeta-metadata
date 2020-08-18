require 'cbeta'
require 'json'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'

def handle_canon(canon)
  fn = File.join('../creators-by-canon', "#{canon}.json")
  $works = JSON.parse(File.read(fn))

  folder = File.join(IN, canon)
  $dirty = false
  Dir.entries(folder).sort.each do |vol|
    next if vol.start_with?('.')
    path = File.join(folder, vol)
    handle_vol(path)
  end

  if $dirty
    s = JSON.pretty_generate($works)
    File.write(fn, s)
  end
end

def handle_vol(folder)
  Dir.entries(folder).sort.each do |f|
    next if f.start_with?('.')
    basename = File.basename(f, '.xml')
    work_id = CBETA.get_work_id_from_file_basename(basename)
    next if $works.key?(work_id)

    path1 = File.join(folder, f)
    new_work1(path1, work_id)
  end
end

def new_work1(fn, work_id)
  doc = CBETA.open_xml(fn)
  title = doc.at("//sourceDesc/bibl/title[@level='m']").text
  title.sub!(/^(.*?)\(第\d+卷\-第\d+卷\)$/, '\1')

  node = doc.at("titleStmt/author")
  return if node.nil?

  byline = node.text
  return if byline.empty?
  
  puts "new #{fn}"
  $dirty = true

  $works[work_id] = { title: title }
  unless byline.nil?
    $works[work_id][:byline]  = byline
    $works[work_id][:creator] = byline
  end
end

Dir.entries(IN).sort.each do |canon|
  next if canon.start_with?('.')
  next if canon.size > 2
  handle_canon(canon)
end