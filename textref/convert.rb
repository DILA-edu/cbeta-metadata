require 'csv'
require 'json'
require 'yaml'

# DILA Authority: 
#   https://github.com/DILA-edu/Authority-Databases/tree/master/authority_catalog/json
IN = '/Users/ray/git-repos/Authority-Databases/authority_catalog/json'

def handle_file(f)
  canon = File.basename(f, '.json')
  edition = $canons[canon]['zh']
  work_info = read_info(canon)

  work_info.each do |work, info|
    next if info['type'] == "non-textbody"
    title = info['title']
    dynasty = info['dynasty']

    if info.key?('contributors')
      a = info['contributors'].map { |x| x['name'] }
      author = a.join(',')
    else
      author = nil
    end
    
    $csv << [work, title, dynasty, author, edition, 'y', 'y', 'y', 'n']
  end
end

def read_info(canon)
  f = File.join(IN, "#{canon}.json")
  s = File.read(f)
  JSON.parse(s)
end

$csv = CSV.open('cbeta.csv', 'wb')
$csv << %w(primary_id title dynasty author edition fulltext_read fulltext_search fulltext_download image)

$canons = YAML.load_file('../canons.yml')

Dir["#{IN}/*.json"].sort.each do |f|
  handle_file(f)
end
