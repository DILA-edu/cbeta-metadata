# CBETA 字數統計

分為「含標點」、「不含標點」兩類，
分別放在 with-puncs, without-puncs 兩個資料夾下。

每個資料夾下，一部藏經一個 csv 檔，
csv 檔之中有 `work_id`, `char_count` 兩個欄位:

* work_id: 典籍編號
* char_count: 字數

校勘欄中的文字不列入計算。

summary.txt 裡面有總字數合計。

bin/count.rb 是做字數統計的 ruby 程式，統計根據的是 CBETA XML P5a.
