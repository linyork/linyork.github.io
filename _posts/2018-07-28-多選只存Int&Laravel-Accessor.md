---
layout: post
title: 多選只存 Int & Laravel Accessor
categories: backend
tags:
- php
- laravel
---
## 目的 ##

 - 為處理DB處理多選時只存一個int要轉2N次方 
 - 為處理DB處理多選時只存一個int要轉特定格式
 <!-- more -->
 
## 紀錄 ##

laravel elquent model


````php
<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    // 連線 DB
    protected $connection = 'mariadb';
    
    // 指定此 Model 的 Table
    protected $table = 'order';

    // 開放純取的 column
    protected $fillable = ['option'];

    // 特定 column 的 Accessor(訪問者)
    public function getOptionAttribute($value)
    {
        $value |= 0;
        $pad = 0;
        $arr = array();
        while ($value)
        {
            if ($value & 1) array_push($arr, 1 << $pad);
            $pad++;
            $value >>= 1;
        }
        return $arr;
    }
}
````

ps: 注意此雷只限定於 elquent model 為非集合狀態時可使用的 function
ps: 白話文就是 TMD 只能使用在 first() 或是 find(1) 之後