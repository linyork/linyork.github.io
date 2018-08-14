---
layout: post
title: TemplateMethod設計模式
categories: backend
tags:
- php
- design pattern
---
## 目的 ##

 - 因各個頁面不同,實作麵包屑模板
 <!-- more -->
 
## 紀錄 ##

### 程式 ###

BreadCrumbsTmplate.php
```php
<?php
abstract class BreadCrumbsTmplate
{
	protected $_list;

	protected $_level;

	abstract protected function __construct();
	
	abstract public function addBread( string $level, array $item);

	public function getBreadCrumbs( )
	{
		foreach ($this->_level as $row)
		{
			if(empty($this->_list[$row]))
			{
				throw new Exception("missing level $row");	
			}
			echo $row."=>".$this->_list[$row]['area_name'].":".$this->_list[$row]['url'];
		    echo "\n";
		}
	}
}
```

ShopBreadCrumbs.php
```php
<?php
class ShopBreadCrumbs extends BreadCrumbsTmplate
{
	public function __construct()
	{
		$this->_level = ['pref','area'];
	}

	public function addBread( string $level, array $item) : self
	{
		$this->_list[$level] = $item;
		return $this;
	}
}
```

實例化
```php
<?php
$shopBreadCrumbs = new ShopBreadCrumbs();
$shopBreadCrumbs->addBread('pref', ['area_name' => '北海道', 'url' => 'http://www.google.com.tw'])
                ->addBread('area', ['area_name' => '千歲', 'url' => 'http://www..com.tw'])
                ->getBreadCrumbs();
```

### 結果 ###

```
pref=>北海道:http://www.google.com.tw
area=>千歲:http://www..com.tw
```