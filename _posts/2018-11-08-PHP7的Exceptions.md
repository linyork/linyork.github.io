---
layout: post
title: PHP7的Exceptions
categories: backend
tags:
- php
---
## 目的 ##

 - 為處理 Exception 的包裝
 <!-- more -->
 
## php的Exceptions層級 ##

 
 > Exception
 >
 >> LogicException
 >>> BadFunctionCallException
 >>>> BadMethodCallException
 >>>
 >>> DomainException
 >>>
 >>> InvalidArgumentException
 >>>
 >>> LengthException
 >>>
 >>> OutOfRangeException
 >
 >> RuntimeException
 >>>
 >>> OutOfBoundsException
 >>>
 >>> OverflowException
 >>> RangeException
 >>>
 >>> UnderflowException
 >>>
 >>> UnexpectedValueException