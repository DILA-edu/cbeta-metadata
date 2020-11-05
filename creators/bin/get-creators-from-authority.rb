require 'rest-client'
require 'json'

OUT = '../creators-by-canon/T.json'
old = JSON.parse(File.read(OUT))

url = 'http://authority-dev.dila.edu.tw/catalog/tools/t.php'
r = RestClient.get(url)
authority_creators = JSON.parse(r)

old.each_key do |k|
  if authority_creators.key?(k)
    old[k]['creators_with_id'] = authority_creators[k]['creators_with_id']
  end
end

s = JSON.pretty_generate(old)
File.write(OUT, s)