# ruby 2.5.0

require 'csv'
require 'json'

IN = '../titles/titles-by-canon'

def handle_file(f)
  canon = File.basename(f, '.csv')
  edition = $canons_name[canon]
  
  work_dynasty = read_dynasty(canon)
  work_author = read_creator(canon)
  
  CSV.foreach(f, headers: true) do |row|
    work = row['典籍編號']
    title = row['典籍名稱']

    unless work_dynasty.key?(work)
      if row['type'] == 'editor'
        next
      else
        abort "#{__LINE__} 典籍編號 #{work} 不存在於 time/year-by-canon"
      end
    end

    dynasty = work_dynasty[work]['dynasty']
    
    begin
      author = work_author[work]['creators']
    rescue
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

def read_creator(canon)
  f = File.join("..", "creators", "creators-by-canon", "#{canon}.json")
  s = File.read(f)
  JSON.parse(s)
end

def read_dynasty(canon)
  f = File.join("..", "time", "year-by-canon", "#{canon}.json")
  s = File.read(f)
  JSON.parse(s)
end

$csv = CSV.open('cbeta.csv', 'wb')
$csv << %w(primary_id title dynasty author edition fulltext_read fulltext_search fulltext_download image)

$canons_name = read_canons_name
Dir["#{IN}/*.csv"].sort.each do |f|
  handle_file(f)
end