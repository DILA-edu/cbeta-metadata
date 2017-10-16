require 'json'
require 'set'

IN1 = '00All.toc'
IN2 = 'BuleiList.txt'
OUT1 = 'categories.json'
OUT2 = 'work_categories.json'

def read_categories
  r = {}
  File.foreach(IN1) do |line|
    line.match(/^<sub>(\d\d) (\S+) /) do
      id = $1.to_i
      name = $2
      r[id] = name
    end
  end
  return r
end

categories = read_categories
s = JSON.pretty_generate(categories)
File.write(OUT1, s)

r = {}
category = ''
File.foreach(IN2) do |line|
  line.strip!
  
  a = line.split(',')
  
  # 檔案中的 #16,T0310(5) 要特別處理
  cat_id = a[0].sub(/^#/, '').to_i
  work_id = a[1].sub(/\(\d+\)$/, '')
  
  unless r.key? work_id
    r[work_id] = {
      category_ids: Set.new,
      category_names: Set.new
    }
  end
  r[work_id][:category_ids]   << cat_id
  r[work_id][:category_names] << categories[cat_id]
  
end

r.each_pair do |k,v|
  r[k][:category_ids]   = v[:category_ids].to_a.join(',')
  r[k][:category_names] = v[:category_names].to_a.join(',')
end

s = JSON.pretty_generate(r)
File.write(OUT2, s)