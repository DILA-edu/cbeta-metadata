# Metadata for TextRef

參考：<https://textref.org/data-model>

## cbeta-meta.csv

Metadata file for TextRef: cbeta-meta.csv

## cbeta.csv

Data file for TextRef: cbeta.csv

DocuSky 的作業流程：

1. 會先透過 [TextRef](https://textref.org/) 登錄的 [metadata](https://raw.githubusercontent.com/DILA-edu/cbeta-metadata/master/textref/cbeta.csv) 取得 CBETA 所有文本書目的 metadata。
2. 將 metadata 的書目顯示給使用者看，讓使用者選擇要下載哪些經書。
3. 透過 CBETA API 下載經書的 DocuXml

## convert.rb

convert.rb 是用來產生 cbeta.csv 的程式
