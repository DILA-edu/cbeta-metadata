# 根據典籍的朝代，查表得到起迄公元年，以此概估典籍成立的年代

require 'csv'
require 'json'

IN = '../dynasty-by-canon'
DYNASTY_TO_YEAR = '../dynasty-year.csv'
OUT = '../out'

def handle_file(fn)
  canon = File.basename(fn, '.json')
  s = File.read(fn)
  works = JSON.parse(s)
  works.each_pair do |k,v|
    if 'X0343,X0451,X0582'.include? k
      works[k][:time_from] = 549
      works[k][:time_to] = 623
      next
    end
    
    next unless v.key? 'dynasty'
    d = v['dynasty']
    
    if $d2y.key? d
      works[k][:time_from] = $d2y[d][:from]
      works[k][:time_to] = $d2y[d][:to]
    else
      puts "#{k} 朝代沒有西元年：#{d}"
    end
  end
  s = JSON.pretty_generate(works)
  out_fn = File.join(OUT, "#{canon}.json")
  File.write(out_fn, s)
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

$d2y = read_d2y

Dir.mkdir(OUT) unless Dir.exist? OUT

Dir["#{IN}/*.json"].each do |fn|
  handle_file(fn)
end