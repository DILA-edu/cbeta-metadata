# 全部藏經典籍的 ID

本資料夾停用，請改用： 
https://github.com/DILA-edu/Authority-Databases/tree/master/authority_catalog

本資料夾列出全部的作品 ID (經號) 列表，一部藏經一個 CSV 檔。

藏經 ID 請參考：[CBETA 電子佛典集成代碼](http://www.cbeta.org/format/id.php)

CSV 檔中除了列出作品編號，也記錄該部作品所在冊別：

    work,vol
    T0001,T01

以上資料表示大正藏 No. 1 在第一冊。

作品跨冊的話，資料會像這樣：

    T0220,T05..T07

表示大正藏 No. 220 經（T0220) 跨第五冊至第七冊。

## work

work 欄位可能多值，例如 `ZWa001..ZWa006` 表示 ZWa001, ZWa002...依此類推至 ZWa006.

又如 `ZW0031a..ZW0031e` 表示 ZW0031a, ZW0031b...依此類推至 ZW0031e.

## type

type 欄位如果是 `non-textbody`，表示是非正文、藏經編輯者或 CBETA 加的文件。
例 ZW.csv:

    work,vol,type
    ZWa069,ZW10,non-textbody
