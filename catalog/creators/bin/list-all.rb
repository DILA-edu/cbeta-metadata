require 'json'
require 'set'

IN = '../creators-by-canon'
OUT = '../all-creators.txt'

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

fo = File.open(OUT, 'w')
$creators.to_a.sort.each do |c|
  fo.puts c
end
fo.close