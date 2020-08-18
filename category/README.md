# CBETA 部類

## 主檔

categories.json 內容是「部類編號」與「部類名稱」的對照表。

work_categories.json 內容是「典籍編號」與「部類編號」、「部類名稱」的對照表。

一部典籍可能屬於多個部類，例如：

    "T2732": {
      "category_ids": "3,20",
      "category_names": "般若部類,敦煌寫本部類"
    }

典籍編號可能使用範圍：

    "Y0001..Y0042": {
      "category_ids": "23",
      "category_names": "新編部類"
    }

## 來源檔

CBReader

* [部類目錄](https://github.com/cbeta-git/CBReader2X/blob/master/Bookcase/CBETA/bulei_nav.xhtml)
* [進階原書目錄](https://github.com/cbeta-git/CBReader2X/blob/master/Bookcase/CBETA/advance_nav.xhtml)
* [簡易原書目錄](https://github.com/cbeta-git/CBReader2X/blob/master/Bookcase/CBETA/simple_nav.xhtml)
