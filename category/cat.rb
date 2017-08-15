require 'json'
require 'set'

IN1 = '00All.toc'
IN2 = 'BuleiList.txt'
OUT = 'categories.json'

def read_categories
  r = {}
  File.foreach(IN1) do |line|
    line.match(/^<sub>(\d\d) (\S+) /) do
      id = $1
      name = $2
      r[id] = name
    end
  end
  return r
end

categories = read_categories
r = {}
category = ''
File.foreach(IN2) do |line|
  line.strip!
  
  a = line.split(',')
  
  # 檔案中的 #16,T0310(5) 要特別處理
  cat_id = a[0].sub(/^#/, '')
  work_id = a[1].sub(/\(\d+\)$/, '')
  
  r[work_id] = Set.new unless r.key? work_id
  r[work_id] << categories[cat_id]
end

r.each_pair do |k,v|
  r[k] = v.to_a.join(',')
end

s = JSON.pretty_generate(r)
File.write(OUT, s)