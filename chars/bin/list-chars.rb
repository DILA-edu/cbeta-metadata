require 'nokogiri'
require 'csv'
require 'set'
require 'unihan2'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'
OUT = '../cbeta-all-uni-chars.csv'

def handle_folder(folder)
  Dir.entries(folder).sort.each do |f|
    next if f.start_with? '.'
    path = File.join(folder, f)
    if Dir.exist?(path)
      handle_folder(path)
    elsif f.end_with?('.xml')
      print f, ' '
      handle_file(path)
    end
  end
end

def handle_file(fn)
  doc = File.open(fn) { |f| Nokogiri::XML(f) }
  doc.content.codepoints.each do |i|
    $r[i] += 1
  end
end

$r = Set.new
$r = Hash.new(0)
handle_folder(IN)

unihan = Unihan2.new
CSV.open(OUT, "wb") do |csv|
  csv << %w[unicode char ver frequence]
  $r.keys.sort.each do |i|
    u = "U+%04X" % i
    c = [i].pack("U")
    csv << [u, c, unihan.ver(i), $r[i]]
  end
end