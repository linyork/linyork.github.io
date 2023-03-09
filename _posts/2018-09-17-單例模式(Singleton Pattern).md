---
layout: post
title: 單例模式(Singleton Pattern)
description: 拿取資料的 model 只實例化一次存於 runtime cache 中
categories: backend
tags:
- php
- design pattern
---
## 目的 ##

 - 拿取資料的 model 只實例化一次存於 runtime cache 中
 <!-- more -->
 
## 紀錄 ##

### 程式 ###

Singleton.php
```php
<?php
abstract class Singleton
{
    final protected function __construct(){}
    abstract protected function init( $initData );
    public static function getInstance( $initData )
    {
        static $object = array();

        // 子物件 ClassName
        $class = static::class;

        // 未建立 RuntimeObject
        if( !isset($object[$class]) )
        {
            $object[$class] = new $class();
        }

        // Runtime中有該物件則執行
        if( isset($initData) )
        {
            $object[$class]->init($initData);
        }

        // 返回該物件
        return $object[$class];
    }
}
```

UserInfo.php
```php
<?php
class UserInfo extends Singleton
{
    protected $userId;
    public function init( $userId )
    {
        $this->userId = $userId;
    }

    public function getUserData()
    {
        // cache
        // sqlData
        return $this->userId;
    }
}
```

實例化
```php
<?php
$userA = UserInfo::getInstance(123)->getUserId();
echo $userA;
```

### 結果 ###

```
123
```
