# 同義字表

## variants.json

2020-03-23 資料筆數: 17,086

### 資料欄位說明

#### type

兩種類別：完全同義、部分同義

#### chars

* 字元列表，半形逗點區隔
* CBETA 缺字使用 Unicode PUA

#### source

* 資訊來源列表
* 可能有多個來源，半形逗點區隔
* 目前三種可能來源：Uniocode, CText, CBETA

## completely-synonymous.rb

從 variants.json 取出完全同義的部分，輸出 completely-synonymous.txt

## completely-synonymous.txt

完全同義字表。
