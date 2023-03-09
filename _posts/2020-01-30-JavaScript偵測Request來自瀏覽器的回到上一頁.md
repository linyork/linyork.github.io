---
layout: post
title: Javascript偵測Request來自瀏覽器的回到上一頁
description: Javascript performance navigation type, 偵測Request來自瀏覽器的回到上一頁
categories: frontend
tags:
- javascript
- 技巧觀念
---
## 目的 ##

 - 偵測Request來自瀏覽器的回到上一頁

 <!-- more -->
   
## 紀錄 ##

### 程式碼 ###

```javascript
$(function () {
    if (!!window.performance && window.performance.navigation.type === 2) {
        //!! 用來檢查 window.performance 是否存在
        //window.performance.navigation.type ===2 表示使用 back or forward
        console.log('Reloading');
        //window.location.reload();//或是其他動作
    }
})
```

### 其他可用 Type ###

 - TYPE_NAVIGATE (0)

> 透過 連結、書籤、表單操作、script、直接輸入 url 開啟 存取

 - TYPE_RELOAD (1)

> 透過 重新整理 或是 Location.reload() 方法存取

 - TYPE_BACK_FORWARD (2)

> 透過 瀏覽紀錄 存取

 - TYPE_RESERVED (255)

> 任何其他方式

### 實際使用 ###

```javascript
$(function () {
    if (!!window.performance && window.performance.navigation.type === 0) {
        console.log('Navigate');
        //window.location.reload();
    }
    if (!!window.performance && window.performance.navigation.type === 1) {
        console.log('Reloading');
        //window.location.reload();
    }
    if (!!window.performance && window.performance.navigation.type === 2) {
        console.log('backforward');
        //window.location.reload();
    }
    
})
```
