# ruby 2.5.0

require 'csv'
require 'json'

IN = '../titles/titles-by-canon'

def handle_file(f)
  canon = File.basename(f, '.csv')
  edition = $canons_name[canon]
  work_info = read_info(canon)
  
  CSV.foreach(f, headers: true) do |row|
    next if row['type'] == 'editor'
    work = row['典籍編號']
    title = row['典籍名稱']

    info = work_info[work]
    abort "典籍編號不存在於 work-info" if info.nil?

    dynasty = info['dynasty']

    if info.key?('contributors')
      a = []
      info['contributors'].each { |x| a << x['name'] }
      author = a.join(',')
    else
      author = nil
    end
    
    $csv << [work, title, dynasty, author, edition, 'y', 'y', 'y', 'n']
  end
end

def read_canons_name
  r = {}
  CSV.foreach('../canons.csv', headers: true) do |row|
    r[row['id']] = row['title']
  end
  r
end

def read_info(canon)
  f = File.join("..", "work-info","#{canon}.json")
  s = File.read(f)
  JSON.parse(s)
end

$csv = CSV.open('cbeta.csv', 'wb')
$csv << %w(primary_id title dynasty author edition fulltext_read fulltext_search fulltext_download image)

$canons_name = read_canons_name
Dir["#{IN}/*.csv"].sort.each do |f|
  handle_file(f)
end