require 'rest-client'
require 'json'
require 'nokogiri'

# https://github.com/DILA-edu/Authority-Databases
AUTHORITY = '/Users/ray/git-repos/Authority-Databases'

OUT = '../creators-by-canon/T.json'

def check_person_exist(works)
  puts "check person id exist in authority database"
  puts "待檢查筆數: #{works.size}"
  fn = File.join(AUTHORITY, 'authority_person', 'Buddhist_Studies_Person_Authority.xml')
  doc = File.open(fn) { |f| Nokogiri::XML(f) }
  doc.remove_namespaces!
  checked = Set.new
  errors = []
  i = 0
  works.each_value do |w|
    i += 1
    next unless w.key?('creators_with_id')
    w["creators_with_id"].split(';').each do |s|
      s.match(/\((A\d+)\)/) do
        id = $1
        next if checked.include?(id)
        checked << id
        print "#{i} #{id} \r"
        unless doc.at_xpath("//person[@id='#{id}']")
          errors << id
        end
      end
    end
  end
  puts
  if errors.empty?
    puts "success."
  else
    puts "person id not exist: " + errors.join(', ')
  end
end

old = JSON.parse(File.read(OUT))

url = 'http://authority-dev.dila.edu.tw/catalog/tools/t.php'
r = RestClient.get(url)
authority_creators = JSON.parse(r)

old.each_key do |k|
  if authority_creators.key?(k)
    old[k]['creators_with_id'] = authority_creators[k]['creators_with_id']
  end
end

check_person_exist(old)

s = JSON.pretty_generate(old)
File.write(OUT, s)