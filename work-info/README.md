# 典籍資訊

2022-10 起停用，請改用： https://github.com/DILA-edu/Authority-Databases/tree/master/authority_catalog

* 佛典編號：例如 T0001
* vol 冊號
  * 有可能跨冊，例如 A097..A098
* type
  * textbody: 本文
  * non-textbody: 非本文
    * 例如佛典編號 TXa001 編纂說明 不是佛典本文。
* orig_category 原書分類
  * 例如 T0001 大正藏 原書分類為：阿含部
* category 部類
  * 可能多值，例如： "寶積部類,淨土宗部類"
* title 題名
* alt 替代典籍
  * 與其他典籍全部或部分重複，CBETA 未重複收錄。
  * 例如 B0083 的 alt 欄位為： JB118
  * 參考 [docs/alternates.md](docs/alternates.md)
* juans 卷數
* byline 作譯者行
* dynasty 朝代
  * 如果 byline 有多個朝代，dynasty 欄位只記錄年代最晚的。
    * 把這個作品認為是後人將前人的作品，作了一次的確認與編修，所產生的符合當代人理解的作品。
    * 前人的朝代，把它們認為是底本參考來源資訊，而不必影響該文獻的朝代紀錄。
* time_from, time_to 成書年代
  * 如果不清楚具體年代，採用朝代的起迄年
  * 如果《法寶總目錄》有較具體的年代，就採用。
  * 有可能只有 time_from, 沒有 time_to.
* contributors 貢獻者
  * data type: array
    * name: 貢獻者 姓名
    * id: 貢獻者 Authority ID
