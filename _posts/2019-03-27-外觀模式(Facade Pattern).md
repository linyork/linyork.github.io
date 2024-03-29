---
layout: post
title: 外觀模式(Facade Pattern)
description: 往多個社交媒體同步消息的流程
categories: backend
tags:
- php
- design pattern
---
## 目的 ##

- 往多個社交媒體同步消息的流程
<!-- more -->

## 紀錄 ##

### 程式 ###
xxxController.php
```php
<?php
// 發Twitter消息
class CodeTwit
{
    function tweet($status, $url)
    {
        var_dump('Tweeted:'.$status.' from:'.$url);
    }
}
 
 // 分享到Google plus上
class Googlize
{
    function share($url)
    {
        var_dump('Shared on Google plus:'.$url);
    }
}
 
 // 分享到Line
class Reddiator
{
    function reddit($url, $title)
    {
        var_dump('Reddit! url:'.$url.' title:'.$title);
    }
}
 ```
 
 shareFacade.php
 ```php
<?php
class shareFacade
{

    protected $twitter;    
    protected $google;   
    protected $reddit;    

    function __construct($twitterObj, $gooleObj, $redditObj)
    {
        $this->twitter = $twitterObj;
        $this->google  = $gooleObj;
        $this->reddit  = $redditObj;
    }  

    function share($url, $title, $status)
    {
        $this->twitter->tweet($status, $url);
        $this->google->share($url);
        $this->reddit->reddit($url, $title);
    }
}
```
 
實例化
```php
<?php
$shareObj = new shareFacade($twitterObj,$gooleObj,$redditObj);
$shareObj->share('//myBlog.com/post-awsome','My greatest post','Read my greatest post ever.');
```
