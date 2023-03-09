---
layout: post
title: PHP7的Exceptions
description: 為處理 Exception 的包裝
categories: backend
tags:
- php
---
## 目的 ##

 - 為處理 Exception 的包裝
 <!-- more -->
 
## php的Exceptions層級 ##

PHP7以後最上層 Exception 改為 Throwable，其下分出 Error 與 Exception 兩大分支。

Error 用來取代原有的錯誤訊息，因此，php7以後的錯誤大多可以用 try catch 捕獲了。

 Throwable
 > Error
 >> ArithmeticError
 >>
 >>> DivisionByZeroError
 >>
 >> AssertionError
 >>
 >> ParseError
 >>
 >> TypeError
 >>
 >>> ArgumentCountError
 >
 > Exception
 >
 >> LogicException
 >>
 >>>
 >>> BadFunctionCallException
 >>>
 >>>> BadMethodCallException
 >>>
 >>> DomainException
 >>>
 >>> InvalidArgumentException
 >>>
 >>> LengthException
 >>>
 >>> OutOfRangeException
 >>
 >> RuntimeException
 >>>
 >>> OutOfBoundsException
 >>>
 >>> OverflowException
 >>>
 >>> RangeException
 >>>
 >>> UnderflowException
 >>>
 >>> UnexpectedValueException
 >
 
  
 
## Error Port ##

基本上，Error 系列的 Exception 都不需要自行丟出，但以下稍微說明使用的情境。
 
### ArithmeticErrord ###
 
算數錯誤，並不常見，舉例來說當你用位元運算子位移-1時
 
 ```php
 try
 {
     var_dump(1 >> -1);
 }
 catch (ArithmeticError $e)
 {
     echo $e->getMessage(); // ArithmeticError: Bit shift by negative number
 }
 ```
 
### DivisionByZeroError ###

數字除以 0 時會丟出的錯誤

```php
try
{
    var_dump(5 / 0);
}
catch (DivisionByZeroError $e)
{
    echo $e->getMessage(); // Division by zero
}
```

### AssertionError ###

使用 `assert()` 來斷言時丟出的錯誤。

```php
try
{
    assert(2 < 1, 'Two is less than one');
}
catch (AssertionError $e)
{
    echo $e->getMessage(); // Warning: assert(): Two is less than one failed
}
```

比較特別的點在於，php 預設不會真的丟出 `AssertionError`，你必須在 `php.ini` 中配置 `assert.exception` 為 `1`。

也可以在 `assert()` 第二個參數放入 Throwable 物件，它會幫你丟出這個物件。

詳情請見 PHP 文件: <http://php.net/manual/en/function.assert.php>

### ParseError ###

當 require 的檔案有語法錯誤時丟出的 Error，`eval()` 執行的程式有語法錯誤也會丟出來，例如以下範例:

```php
try
{
    eval('$a = 4'); // 沒有分號

    // OR

    require 'some-file-with-syntax-error.php';
}
catch (ParseError $e)
{
    echo $e->getMessage(); // PHP Parse error:  syntax error, unexpected end of file
}
```

在檔案本身的語法錯誤因為會直接編譯失敗，也就不會丟出 Error 了，而是直接 Fatal Error。

### TypeError ###

由於 PHP7 加入了型別判斷，當型別錯誤時就會丟出此 Error

```php
declare (strict_types = 1);

function plus(int $i) 
{
    return $i + 1;
}

try
{
    plus('5');
}
catch (TypeError $e)
{
    echo $e->getMessage(); // Argument 1 passed to plus() must be of the type integer, string given
}
```

注意，沒有加 `declare (strict_types = 1);` 的話，php 還是會幫你把 `'5'` 轉成 `5`

### ArgumentCountError (PHP 7.1) ###

傳入函式的參數數量太少或不正確時丟出

```php
function foo($a, $b)
{
    return $a / $b;
}

try
{
    foo(1);
}
catch (ArgumentCountError $e)
{
    echo $e->getMessage(); // Too few arguments to function foo(), 1 passed in
}
```

## Exception Port ##

### Runtime 與 Logic Exception ###

`RuntimeException` 與 `LogicException` 是唯二由 `Exception` 繼承出來的核心例外類別，也代表 Exception 的兩大分支。

### RuntimeException ###

首先是 RuntimeExcption，這是執行期例外，所謂的執行期例外就是指程式身本以外無法由開發者控制的狀況。例如呼叫資料庫，但是資料庫沒有回應，或者呼叫遠端 API ，可是 API 卻沒有傳回正確的數值。另外也包含檔案系統或環境的問題，例如程式要抓取的的某個外部檔案不存在，或者應該安裝的外部函式庫沒有正常運作，這些因為都不是開發者可以控制的，我們就統稱為 RuntimeException。

Web 開發最常見的狀況就是資料庫連線失敗，或者SQL查詢錯誤。例如 PDO 所丟出來的 PDOException 就是既承自 RuntimeException。所以我們要判斷是否是資料庫錯誤可以這樣寫：

```php
try
{
    // some database operation
    $db->fetch();
}
catch (RuntimeException $e)
{
    // Database error
}
catch (Exception $e)
{
    // Other error
}
```

我們並不知道 `$db` 是否是 PDO 還是其他資料庫物件，但是只要是資料庫錯誤，慣例上都應該回傳 RuntimeExcepiton，因此就能夠跟其他的 Exceptions 分開來。

### LogicException ###

`LogicException` 則是反過來，屬於程式本身的問題，應該要是開發者事前就解決的問題。例如某個應該要被 Override 的 method 沒有被 override，但 class 本身又因故無法設為 abstract 時，我們就在 method 中丟出 LogicException，要求開發者一定要處理這個問題。另外，class未被引入，呼叫不存在的物件，或是妳把數值除以零等等都屬於此例外。

```php
class Command
{
    public function execute()
    {
        if ($this->handler instanceof Closure)
        {
            return $this->handler();
        }

        throw new LogicExcpetion('Handler should be callable.');
    }
}

```

由此可知，一個正常運作的系統，應該可以允許 RuntimeException 的出現，但是 LogicException 是應該要完全見不到的。
