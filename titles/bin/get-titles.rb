require 'cbeta'
require 'csv'

IN = '/Users/ray/git-repos/cbeta-xml-p5a'
OUT = '../titles-by-canon'
OUT_ALL = '../all-title-byline.csv'
BYLINES = {
  'N0007' => '第1卷-第3卷：葉慶春譯；第4卷：關世謙譯；第5卷-第12卷：郭哲彰譯'
}

def handle_canon(canon)
  $result = {}
  $extent = {}
  path = File.join(IN, canon)
  Dir.entries(path).sort.each do |f|
    next if f.start_with? '.'
    handle_vol(canon, f)
  end
  fn = File.join(OUT, canon+'.csv')
  CSV.open(fn, "wb") do |csv|
    csv << %w(典籍編號 典籍名稱 卷數 作譯者 type)
    $result.keys.sort.each do |k|
      if k.match(/^(#{CBETA::CANON})[a-z]/)
        type = 'editor'
      else
        type = 'text'
      end

      v = $result[k]
      row = [k, v[:title], $extent[k], v[:byline], type]
      csv << row
      $csv_all << row
    end
  end
end

def handle_file(fn)
  $count += 1
  basename = File.basename(fn, '.xml')
  print basename + ' '
  work = CBETA.get_work_id_from_file_basename(basename)

  doc = CBETA.open_xml(fn)
  title = doc.at("//sourceDesc/bibl/title[@level='m']").text

  # 去掉後面的卷
  # 例：A097n1267 大唐開元釋教廣品歷章(第3卷-第4卷)
  title.sub!(/^(.*?)\(第\d+卷\-第\d+卷\)$/, '\1')

  # N0018,本生經(第26卷),26,悟醒譯,text
  # P1612,諸佛世尊如來菩薩尊者名稱歌曲(第51卷)
  title.sub!(/\(第\d+卷\)$/, '')

  # 去掉後面的 （下），例： B0088, LC0007, Y0030
  title.sub!(/（下）$/, '')

  $result[work] = {} unless $result.key? work
  $result[work][:title] = title

  if BYLINES.key?(work)
    $result[work][:byline] = BYLINES[work]
  else
    node = doc.at('//titleStmt/author')
    unless node.nil?
      $result[work][:byline] = node.text
    end
  end
  
  node = doc.at('//extent')
  abort '找不到 extent 元素' if node.nil?
  juans = node.text.sub(/^(\d+)卷$/, '\1').to_i
  if $extent.key? work
    $extent[work] += juans
  else
    $extent[work] = juans
  end
end

def handle_vol(canon, vol)
  path = File.join(IN, canon, vol)
  Dir.entries(path).sort.each do |f|
    next if f.start_with? '.'
    file_path = File.join(path, f)
    handle_file(file_path)
  end
end

Dir.mkdir(OUT) unless Dir.exist?(OUT)

$count = 0
$csv_all = CSV.open(OUT_ALL, "wb")
$csv_all << %w(典籍編號 典籍名稱 卷數 作譯者 type)

Dir.entries(IN).sort.each do |f|
  next if f.start_with? '.'
  next if f.size > 2
  handle_canon(f)
end

puts "共 #{$count} 筆"