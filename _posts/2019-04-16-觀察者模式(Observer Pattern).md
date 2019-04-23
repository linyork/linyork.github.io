---
layout: post
title: 觀察者模式(Observer Pattern)
categories: backend
tags:
- php
- design pattern
---
## 目的 ##

- 使用者註冊後寄送通知
<!-- more -->

## 紀錄 ##

### 程式 ###
PHP 內置了

SplSubject 抽象主題 Interface

SplObserver 抽象觀察者 Interface

ps: 這兩個 interface 不必實作
```php
<?php
// 主題 被觀察者
interface SplSubject
{
	//註冊觀察者到當前主題
    public function attach(SplObserver $observer);
    //從當前主題刪除觀察者
    public function detach(SplObserver $observer);
    //主題狀態更新時通知所有的觀察者做相應的處理
    public function notify(); 
}

// 觀察者
interface SplObserver
{
	//註冊觀察者到當前主題
    public function update(SplSubject $subject);
}
 ```
 
 UserRegister.php
 ```php
<?php
/**
 * 主題類（被觀察者相當於一個主題，觀察者訂閱這個主題）
 * 當我們註冊用戶成功的時候想發送 email 和 sms 通知用戶註冊成功
 * 則 可以將 SendEmail 和 SendSms 作為觀察者
 * 註冊到 User 的觀察者中
 * 當 User register 成功時 notify 給 observers
 * 各 observe 通過約定的 update 接口進行相應的處理 發郵件或發簡訊
 */
class UserRegister implements SplSubject
{
    public $name;
    public $email;
    public $mobile;

    /**
     * 當前主題下的觀察者集合
     * @var array
     */
    private $observers = [];

    /**
     * 模擬註冊
     * @param  [type] $name   [description]
     * @param  [type] $email  [description]
     * @param  [type] $mobile [description]
     * @return [type]         [description]
     */
    public function register($name, $email, $mobile)
    {
        $this->name   = $name;
        $this->email  = $email;
        $this->mobile = $mobile;

        //business handle and register success
        $reg_result = true;
        if ($reg_result)
        {
        	//註冊成功 所有的觀察者將會收到此主題的通知
            $this->notify();
            return true;
        }

        return false;
    }

    /**
     * 當前主題註冊新的觀察者
     * @param  SplObserver $observer [description]
     * @return [type]                [description]
     */
    public function attach(SplObserver $observer)
    {
        return array_push($this->observers, $observer);
    }

    /**
     * 當前主題刪除已註冊的觀察者
     * @param  SplObserver $observer [description]
     * @return [type]                [description]
     */
    public function detach(SplObserver $observer)
    {
        $key = array_search($observer, $this->observers, true);

        if (false !== $key)
        {
            unset($this->observers[$key]);
            return true;
        }

        return false;
    }

    /**
     * 狀態更新 通知所有的觀察者
     * @return [type] [description]
     */
    public function notify()
    {
        if (! empty($this->observers))
        {
            foreach ($this->observers as $key => $observer)
            {
                $observer->update($this);
            }
        }

        return true;
    }

}
```

EmailObserver.php
```php
<?php
class EmailObserver implements SplObserver
{
    /**
     * 觀察者接收主題通知的接口
     * @param  SplSubject $user [description]
     * @return [type]           [description]
     */
    public function update(SplSubject $user)
    {
        echo "send email to " . $user->email . PHP_EOL;
    }
}
```

SmsObserver
```php
<?php
class SmsObserver implements SplObserver
{
    public function update(SplSubject $user)
    {
        echo "send sms to " . $user->mobile . PHP_EOL;
    }
}
```
 
實例化
```php
<?php
// UserRegister 主題
$user = new UserRegister();

// 為 user 註冊 Email 觀察者 (Email 觀察者訂閱 User 主題)
$emailObserver = new EmailObserver();
$user->attach($emailObserver);

// 為 user 註冊 Sms 觀察者 (Sms 觀察者訂閱 User 主題)
$smsObserver = new SmsObserver();
$user->attach($smsObserver);

// 從 user 上刪除 Sms 觀察者 (Sms 觀察者取消訂閱 User 主題)
//$user->detach($smsObserver);

// register 中會根據註冊結果通知觀察者 觀察者做相應的處理
$user->register("york", "jason945119@gmail.com", "1888888888");
```

```
send email to jason945119@gmail.com
send sms to 1888888888
```