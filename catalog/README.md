# 目錄清單

## 綜合目錄

* cbeta.xml: CBETA 部類目錄
* modern.xml: 近代新編文獻
* others.xml: 歷代藏經補輯

## 各藏 部別目錄

* cat-n.xml: 南傳大藏經 部別目錄
* cat-t.xml: 大正藏 部別目錄
* cat-x.xml: 卍續藏 部別目錄

## 各藏 冊別目錄

* vol-a.xml: 趙城金藏
* vol-b.xml: 大藏經補編
* vol-c.xml: 中華大藏經-中華書局版
* vol-d.xml: 國圖善本
* vol-f.xml: 房山石經
* vol-g.xml: 佛教大藏經
* vol-ga.xml: 中國佛寺史志彙刊
* vol-gb.xml: 中國佛寺志叢刊
* vol-h.xml: 正史佛教資料類編
* vol-i.xml: 北朝佛教石刻拓片百品
* vol-j.xml: 嘉興藏
* vol-k.xml: 高麗大藏經-新文豐版
* vol-l.xml: 乾隆大藏經-新文豐版
* vol-m.xml: 卍正藏經-新文豐版
* vol-n.xml: 南傳大藏經
* vol-p.xml: 永樂北藏
* vol-s.xml: 宋藏遺珍-新文豐版
* vol-t.xml: 大正藏
* vol-u.xml: 洪武南藏
* vol-w.xml: 藏外佛教文獻
* vol-x.xml: 卍續藏
* vol-y.xml: 印順法師佛學著作集

# XML 標記說明

tree 元素表示整個樹狀目錄，id 屬性是該目錄的 ID。

node 元素表示樹狀目錄中的一個節點

work 屬性：典籍經號（經號）

跨冊的典籍只記錄一個典籍編號 (JB277 跨 J32~33)

    <node work="JB277"/>

該節點下只有一部典籍

    <node name="T1957 南北朝著作" work="T1957"/>

典籍編號 起迄

    <node work="T1745..T1748"/>

指出該節點下 典籍編號 起迄

<node name="T1749-54 觀無量壽經疏 T37" work="T1749..T1754"/>

典籍編號：列舉、範圍 並用：

<node name="中篇" work="Y0008..Y0012,Y0040,Y0013"/>

juan 屬性：指到某部典籍的部份卷數

<node name="T0310(5) 無量壽如來會 2 菩提流志" work="T0310" juan="17..18"/>

file 屬性：指出對應典籍的 XML 檔主檔名

<node work="T0220" file="T05n0220a" juan="1..200"/>

## 典籍跨冊

例如 JB271 跨 J31..J32:

    <node name="J31 嘉興藏 (B262~B271 經)">
      <node work="JB262..JB270"/>
      <node work="JB271" file="J31nB271"/>
    </node>
    <node name="J32 嘉興藏 (B271~B277 經)">
      <node work="JB271" file="J32nB271" juan="6"/>
      <node work="JB272..JB276"/>
      <node work="JB277" file="J32nB277"/>
    </node>

## 卷跨冊

例如 L1557 卷17 跨 L130, L131 兩冊，
這一卷雖然跨兩冊，但回傳卷17的 HTML 時會包含跨冊的全部卷17,
所以在 L131 的冊目錄要跳到卷17時要指定行號:

    <node name="L130 乾隆藏 (L1557: 1-17卷)">
      <node work="L1557" file="L130n1557" juan="1..17"/>
    </node>
    <node name="L131 乾隆藏 (L1557: 17-34卷)">
      <node work="L1557" file="L131n1557" juan="17..34" lb="L131n1557_p0001a01"/>
    </node>