require 'json'
require 'csv'

IN = '../creators-by-canon'
OUT = '../out'

def convert(f)
  puts f
  src = File.join(IN, f)
  s = File.read(src)
  data = JSON.parse(s)
  
  basename = File.basename(f, '.json')
  dest = File.join(OUT, basename+'.csv')
  CSV.open(dest, "wb") do |csv|
    csv << %w(work_id title byline creators creators_with_id)
    data.each_pair do |k,v|
      csv << [k, v['title'], v['byline'], v['creators'], v['creators_with_id']]
    end
  end
end

Dir.entries(IN).each do |f|
  next if f.start_with? '.'
  convert(f)
end