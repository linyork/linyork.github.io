---
title: 為了解決快速測試簡單的php程式
categories: Github
tags:
- jekyll
- hexo
---
## 目的 ##

 - 為了解決快速測試簡單的php程式
 
## 操作 ##

### sublime設定 ###

1.   啟動sublime, 選擇Tools -> Build System -> New Build System，會新建一個untitled.sublime-build 文件。

2.   刪除untitled.sublime-build原有內容，添加如下內容：

```
{ 
    "cmd": ["php", "$file"],
    "file_regex": "php$", 
    "selector": "source.php" 
}
```

3.   ctrl+s保存為php.sublime-build

### 執行 phgp 文件 ###

1.   在sublime中打開的php文件，按 ```` ⌘ + B ````  即可運行。
