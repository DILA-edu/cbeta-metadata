require 'json'
require 'set'

IN = '../creators-by-canon'
OUT = '../out/stat.md'

def handle_file(fn)
  s = File.read(fn)
  creators = JSON.parse(s)
  creators.each do |k, v|
    if v.key? 'creators_with_id'
      s = v['creators_with_id']
      if s.include? ','
        puts fn
        puts "creators_with_id 欄位不應有逗點: #{s}" 
        puts "如果是多個作譯者，應以半形分號隔開"
        abort
      end
      s.split(';').each do |c|
        if c.match(/^(.*?)\((A\d{6})\)$/)
          record($1, $2)
        else
          puts "#{k} 格式錯誤：#{c}"
        end
      end
    else
      #puts "#{k} 缺 creator id"
    end
  end
end

def record(name, id)
  $id2name[id]   = Set.new unless $id2name.key? id
  $name2id[name] = Set.new unless $name2id.key? name
  
  $id2name[id]   << name
  $name2id[name] << id
end

$id2name = {}
$name2id = {}
Dir["#{IN}/*.json"].each do |f|
  handle_file(f)
end


folder = File.dirname(OUT)
Dir.mkdir(folder) unless Dir.exists? folder
puts "write to #{OUT}"
File.open(OUT, 'w') do |f|
  f.puts "# 一人多名\n"
  $id2name.each_pair do |k,v|
    next unless v.size > 1
    f.puts "#{k}: " + v.to_a.join(',')
  end

  f.puts "\n# 多人同名\n"
  $name2id.each_pair do |k,v|
    next unless v.size > 1
    f.puts "#{k}: " + v.to_a.join(',')
  end
end