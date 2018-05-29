---
title: 為了取得class內function的參數數量
categories: Github
tags:
- jekyll
- hexo
---
## 目的 ##

 - 為了取得class內function的參數數量
 
## 紀錄 ##

### 程式 ###

```php
class door
{
    function open( string $one, array $two)
    {
        echo 'open';
    }
    function close( string $one)
    {
        echo 'close';
    }

}
```

```php
$r = new ReflectionMethod ( 'door', 'open' );
print_r($r->getNumberOfParameters());
```

### 結果 ###

```
2
```