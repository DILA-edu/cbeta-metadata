# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案性質

CBETA 漢文佛典「本文以外」的資料庫（經錄、缺字、異體字等），以資料檔為主，沒有 build / lint / test。少數 Ruby 小程式用來產生資料檔。Ruby 版本見 `.tool-versions`（ruby 3.4.4），相依套件在 `Gemfile`（`cbeta`、`rest-client`、`unihan2`），以 `bundle install` 安裝。

## 哪些資料夾仍在維護

多數資料夾已停用，README 有標註停用日期與替代來源；修改前先看該資料夾的 README.md。

仍在更新（依近期 git 紀錄）：

- `variants/vars-for-cbdata.json`：給 CBETA API (cbdata) 用的異體字表，key 為字或 CBETA 缺字碼（如 `CB00001`），value 為半形逗號分隔的異體字。產生它的程式不在本 repo。
- `textref/cbeta.csv`：給 TextRef / DocuSky 用的書目，GitHub raw URL 被外部直接引用（見 `textref/cbeta-meta.csv`），欄位格式不可任意變動。
- `canons.yml`：藏經代碼 → 中英文名稱、簡稱、略符，供 `textref/convert.rb` 等程式使用。

已停用（請勿再當作權威資料來源更新）：

- `catalog/`（2026-05-21 起）→ 改用 heavenchou/cbwork-bin 的 `bulei.txt`、`advance_nav.txt`
- `work-info/`、`work-id/`、`alternates/`、`special-works/` → 改用 DILA-edu/Authority-Databases 的 `authority_catalog`
- `creators/`、`orig-category/` → 已併入 `work-info/`（亦已停用）
- `gaiji/` → 最新缺字資料在 heavenchou/cbwork-bin 的 `gaiji-m_u8.txt`

## 常用指令

程式皆以相對路徑讀寫，需在其所在資料夾內執行：

```sh
# 重新產生 textref/cbeta.csv（讀取本機 Authority-Databases 的 authority_catalog/json，路徑寫死在 convert.rb 的 IN 常數）
cd textref && ruby convert.rb

# 由 variants.json 取出「完全同義」群組，輸出 completely-synonymous.txt
cd variants && ruby completely-synonymous.rb
```

## 資料慣例

- 典籍編號（經號）格式如 `T0001`、`JB277`；行號格式如 `T16n0663_p0340a07`。範圍以 `..` 表示（如 `T1745..T1748`、跨冊 `T05..T07`），列舉以半形逗號分隔。
- 藏經代碼見 `canons.yml` 與 http://www.cbeta.org/format/id.php 。
- 文件以繁體中文撰寫。
