# 作譯者資料

資料來源：CBETA XML P5a (2015-12-18) teiHeader 裡的 author 元素。

檔案名稱使用 CBETA [藏經代碼](http://www.cbeta.org/format/id.php)

# 檔案

* all-creators.json: 有 ID 的全部作譯者列表，使用 bin/list-all.rb 程式轉出。
* all-creators.txt
* all-title-byline.csv: 典籍編號、標題、作譯者 全部列表。(如果 CBETA XML 裡沒有作譯者資訊，就整部典籍都不列出)
* creators-by-strokes.json
  * 全部作譯者依首字筆劃分群，供 Web UI 全文檢索選擇範圍。
* creators-by-strokes-with-works.json
  * 同上，並列出該作譯者之作品典籍
* stat.md: 列出「一人多名」及「多人同名」，使用 bin/stat.rb 程式轉出。

# 資料夾

* bin: 轉檔程式
* creators-by-canon: JSON 格式的作譯者資料
* csv: 由 JSON 檔轉出的 csv 檔。使用 bin/json2csv.rb 程式轉出。

# 類別

比較重要的貢獻者資訊可能有這些類別 (2016-01-14 maha 提供)：

* 著、述、撰、說
* 譯
* 疏、註
* 記、錄
* 校、訂
* 編、輯、集
* 刪定
* 刻

但目前未對這些類別做整理區分。
