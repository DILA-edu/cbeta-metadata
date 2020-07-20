require 'nokogiri'
require 'set'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'
OUT = '../cbeta-all-uni-chars.txt'

def handle_folder(folder)
  Dir.entries(folder).sort.each do |f|
    next if f.start_with? '.'
    print f + ' '
    path = File.join(folder, f)
    if Dir.exist?(path)
      handle_folder(path)
    elsif f.end_with?('.xml')
      handle_file(path)
    end
  end
end

def handle_file(fn)
  doc = File.open(fn) { |f| Nokogiri::XML(f) }
  doc.content.codepoints.each do |i|
    $r << i
  end
end

$r = Set.new
handle_folder(IN)

File.open('list-chars.txt', 'w') do |f|
  $r.to_a.sort.each do |i|
    f.puts "U+%04X %s" % [i, [i].pack("U")]
  end
end