# CBETA 典籍名稱 列表

CBETA 經名列表按各部藏經區分，每部藏經一個 CSV 檔。
列如大正藏的列表在 titles-by-canon/T.csv.

產生經名列表的 ruby 程式在 bin/get-titles.rb,
它從 CBETA XML P5a 讀取 title、extent 元素。
