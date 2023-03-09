---
layout: post
title: ApacheBasicAuth
description: Apache Basic Auth, 幫網站加入 Basic Auth
categories: backend
tags:
- web
- apache
---
## 目的 ##

 - 幫網站加入 Basic Auth

 <!-- more -->
 
## 網站基本認證 ##

### 建立 .htpasswd 檔 ###

```bash
sudo sh -c "echo -n '帳號名稱:' >> .htpasswd"
sudo sh -c "openssl passwd -apr1 >> .htpasswd"
```

### apache web conf ###
 
```
 AuthType Basic
 
 AuthName "You need to login"
 
 AuthUserFile /usr/local/apache2/.htpasswd
 
 Require valid-user
```

