---
layout: post
title: echo物件class的方法
categories: backend
tags:
- php
---
## 目的 ##

 - 為了製作模板引擎印出View物件
 <!-- more -->
 
## 紀錄 ##

### 程式 ###

```php
class view
{
    protected $__content = '';
    
    public function __construct(string $viewPath)
    {
        #Code...
    }
    
    public function __toString() : string
    {
         $this->__content = '<div>test<div>';
         return $this->__content;
    }
}
```

```php
$view = new view();
echo $view
```

### 結果 ###

```html
<div>test<div>
```