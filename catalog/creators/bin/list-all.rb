require 'json'
require 'set'

IN = '../creators-by-canon'
OUT = '../all-creators.txt'
OUT_JSON = '../all-creators.json'

def handle_file(fn)
  s = File.read(fn)
  creators = JSON.parse(s)
  creators.each_value do |v|
    next unless v.key? 'creators'
    v['creators'].split(',').each do |c|
      $creators << c
    end
  end
end

$creators = Set.new
Dir["#{IN}/*.json"].each do |f|
  handle_file(f)
end

$creators = $creators.to_a.sort

fo = File.open(OUT, 'w')
$creators.each do |c|
  fo.puts c
end
fo.close

s = JSON.pretty_generate($creators)
File.write(OUT_JSON, s)