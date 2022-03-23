# CBETA 典籍名稱 列表

本資料夾自 2022-03-23 起停用，資料合併至 ../work-info.

## titles-by-canon

CBETA 經名列表按各部藏經區分，每部藏經一個 CSV 檔。
列如大正藏的列表在 titles-by-canon/T.csv.

### type

type 欄位如果是 `editor`，表示是非正文、藏經編輯者或 CBETA 加的文件。
例 ZW.csv:

    典籍編號,典籍名稱,卷數,作譯者,type
    ZWa071,錄文校勘體例,1,"",editor

## bin

產生經名列表的 ruby 程式在 bin/get-titles.rb,
它從 CBETA XML P5a 讀取 title、extent 元素。
