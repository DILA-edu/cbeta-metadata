require 'json'
require 'set'

def chk_k2s(chars)
  chars.each do |c|
    return $k2s[c] if $k2s.key?(c)
  end
  nil
end

variants = JSON.parse(File.read('variants.json'))
$k2s = {}
all = []
variants.each do |h|
  next unless h['type'] == '完全同義'
  chars = h['chars'].split(',')
  vars = chk_k2s(chars)
  if vars.nil?
    vars = Set.new(chars)
    all << vars
    chars.each do |c|
      $k2s[c] = vars
    end
  else
    chars.each do |c|
      vars << c
    end
  end
end

File.open('completely-synonymous.txt', 'w') do |f|
  all.each do |vars|
    f.puts vars.to_a.join(',')
  end
end
