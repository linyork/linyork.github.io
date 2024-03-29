---
layout: post
title: 狀態模式(State Pattern)
description: 實作 Facebook or PTT 的讚噓功能
categories: backend
tags:
- php
- design pattern
---
## 目的 ##

 - 實作 Facebook or PTT 的讚噓功能
 <!-- more -->
 
## 紀錄 ##

### 程式 ###

Context.php
````php
<?php
class Context
{
	private $likeState;
	private $fuckState;
	private $nullState;
	private $currentState;

	public function __construct()
	{
		$this->likeState    = new LikeState($this);
		$this->fuckState    = new FuckState($this);
		$this->nullState    = new NullState($this);
		$this->currentState = $this->nullState;
	}

	// 觸發器
	public function turnLike()
	{
		$this->currentState->like();
	}

	// 觸發器
	public function turnFuck()
	{
		$this->currentState->fuck();
	}

	// 設定目前狀態
	public function setState(IState $state)
	{
		$this->currentState = $state;
	}

	// 取得狀態-讚
	public function getLikeState()
	{
		return $this->likeState;
	}

	// 取得狀態-幹
	public function getFuckState()
	{
		return $this->fuckState;
	}

	// 取得狀態-無
	public function getNullState()
	{
		return $this->nullState;
	}
}
````
IState.php
````php
<?php
interface IState
{
	public function like();
	public function fuck();
}
````
LikeState.php
````php
<?php
class LikeState implements IState
{
	private $context;

	public function __construct(Context $contextNew)
	{
		$this->context = $contextNew;
	}

	public function like()
	{
		echo "讚 -> 無\n";
		$this->context->setState($this->context->getNullState());
	}

	public function fuck()
	{
		echo "讚 -> 幹\n";
		$this->context->setState($this->context->getFuckState());
	}
}
````
FuckState.php
````php
<?php
class FuckState implements IState
{
	private $context;

	public function __construct(Context $contextNew)
	{
		$this->context = $contextNew;
	}

	public function like()
	{
		echo "幹 -> 讚\n";
		$this->context->setState($this->context->getLikeState());
	}

	public function fuck()
	{
		echo "幹 -> 無\n";
		$this->context->setState($this->context->getNullState());
	}
}
````

NullState.php
````php
<?php
class NullState implements IState
{
	private $context;

	public function __construct(Context $contextNew)
	{
		$this->context = $contextNew;
	}

	public function like()
	{
		echo "無 -> 讚\n";
		$this->context->setState($this->context->getLikeState());
	}

	public function fuck()
	{
		echo "無 -> 幹\n";
		$this->context->setState($this->context->getFuckState());
	}
}
````

實例化
````
$example = new Context();
$example->turnLike();
$example->turnLike();

$example->turnFuck();
$example->turnFuck();

$example->turnLike();
$example->turnFuck();
$example->turnLike();
````
### 結果 ###

````
無 -> 讚
讚 -> 無

無 -> 幹
幹 -> 無

無 -> 讚
讚 -> 幹
幹 -> 讚
````
   
