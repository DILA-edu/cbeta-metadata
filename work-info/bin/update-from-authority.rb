require 'rest-client'
require 'json'
require 'nokogiri'

# https://github.com/DILA-edu/Authority-Databases
AUTHORITY = '/Users/ray/git-repos/Authority-Databases'

OUT = '../T.json'

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

puts "read #{OUT}"
old = JSON.parse(File.read(OUT))
puts "大正藏 佛典筆數: #{old.size}"

url = 'https://authority-dev.dila.edu.tw/catalog/tools/t.php'
puts "get #{url}"
r = RestClient.get(url)
authority_creators = JSON.parse(r)
puts "Authority 有作譯者的佛典筆數: #{authority_creators.size}"

old.each_key do |k|
  # 有作譯者的佛典，authority 那邊才會匯出
  next unless authority_creators.key?(k)

  contributors = authority_creators[k]['creators_with_id'].split(';')
  contributors.map! do |x|
    x.match(/^(.*?)\((A\d+)\)$/) do
      { name: $1, id: $2}
    end
  end
  old[k]['contributors'] = contributors
end
check_person_exist(old)

puts "write #{OUT}"
s = JSON.pretty_generate(old)
File.write(OUT, s)  
