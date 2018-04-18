# 根據典籍的朝代，查表得到起迄公元年，以此概估典籍成立的年代

require 'csv'
require 'json'
require 'nokogiri'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'
DYNASTY_TO_YEAR = '../dynasty-year.csv'
OUT = '../out'

def handle_canon(canon)
  puts "handle canon: #{canon}"
  $canon = canon
  $works = {}
  canon_folder = File.join(IN, canon)
  Dir.entries(canon_folder).sort.each do |vol|
    next if vol.start_with? '.'
    handle_vol(vol)
  end
  
  s = JSON.pretty_generate($works)
  fn = File.join(OUT, "#{canon}.json")
  puts "write #{fn}"
  File.write(fn, s)
end

def handle_vol(vol)
  vol_folder = File.join(IN, $canon, vol)
  Dir.entries(vol_folder).sort.each do |f|
    next if f.start_with? '.'
    fn = File.join(vol_folder, f)
    handle_file(fn)
  end
end

def handle_file(fn)
  basename = File.basename(fn, '.xml')
  print basename + ' '
  work = basename.sub /^([A-Z]{1,2})\d+n(.*)$/, '\1\2'
  return if $works.include? work  
  
  if 'X0343,X0451,X0582'.include? work
    $works[work] = {}
    $works[work][:time_from] = 549
    $works[work][:time_to] = 623
    return
  end
  
  doc = File.open(fn) { |f| Nokogiri::XML(f) }
  doc.remove_namespaces!
  
  $works[work] = {}
  w = $works[work]
  
  e = doc.at_xpath('//title')
  w[:title] = e.text.split.last unless e.nil?
  
  author = doc.at_xpath('//author')
  if author.nil?
    $log.puts "#{__LINE__} #{fn} 找不到 author 元素" unless $canon=='B'
    return
  end
  
  byline = author.text
  w[:byline] = byline
    
  d = byline.split[0]
  w[:dynasty] = d
    
  if $d2y.key? d
    w[:time_from] = $d2y[d][:from]
    w[:time_to]   = $d2y[d][:to]
  else
    $log.puts "#{work} 朝代沒有西元年：#{d}" unless $canon=='B'
  end
  
  extent = doc.at_xpath('//extent')
  if extent.nil?
    $log.puts "#{__LINE__} #{fn} 找不到 extent 元素"
    return
  end
  w[:extent] = extent.text
end

def read_d2y
  r = {}
  CSV.foreach(DYNASTY_TO_YEAR) do |row|
    d = row[0]
    f = row[1]
    t = row[2]
    r[d] = {
      from: f.to_i,
      to: t.to_i
    }
  end
  r
end

puts "log: year.log"
$log = File.open('year.log', 'w')

$d2y = read_d2y

Dir.mkdir(OUT) unless Dir.exist? OUT

if ARGV.size > 0
  handle_canon(ARGV[0].upcase)
else
  Dir.entries(IN).sort.each do |canon|
    next if canon.start_with? '.'
    next if canon.size > 2
    handle_canon(canon)
  end
end