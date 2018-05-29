---
layout: post
title: google-google登入串接
categories: Github
tags:
- google
- 後端
---
## 目的 ##

 - 為了使用 google 登入機制
 <!-- more -->
 
## 紀錄 ##

### 程式 ###

#### composer.json ####

```php
"require":{
    "google/apiclient": "^2.0"
}
```

#### 單頁面PHP ####

```php
session_start();
// 0) 設定 client 端的 id, secret
$client = new Google_Client;
$client->setClientId(" 你的 id ");
$client->setClientSecret("你的 secret");

// 2) 使用者認證後，可取得 access_token
if (isset($_GET['code']))
{
    $client->setRedirectUri("http://dev-hypenode.tw");
    $result = $client->authenticate($_GET['code']);

    if (isset($result['error']))
    {
        die($result['error_description']);
    }

    $_SESSION['google']['access_token'] = $result;
    header("Location:http://dev-hypenode.tw?action=profile");
}

// 3) 使用 id_token 取得使用者資料。另有 setAccessToken()、getAccessToken() 可以設定與取得 token
elseif ($_GET['action'] == "profile")
{
    $profile = $client->verifyIdToken($_SESSION['google']['access_token']['id_token']);
    //使用者個人資料
    echo json_encode($profile); 
}

// 1) 前往 Google 登入網址，請求用戶授權
else
{
    $client->revokeToken();
    session_destroy();

    // 添加授權範圍，參考 https://developers.google.com/identity/protocols/googlescopes
    $client->addScope(['https://www.googleapis.com/auth/userinfo.profile']);
    $client->addScope(['https://www.googleapis.com/auth/userinfo.email']);
    $client->setRedirectUri("http://dev-hypenode.tw");
    $url = $client->createAuthUrl();
    header("Location:{$url}");
}
```

### 結果 ###

```
{
    "azp": "000000000000-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com",
    "aud": "000000000000-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com",
    "sub": "000000000000000000000",
    "at_hash": "XXXXXXXXXXXXXXXXXXXXXX",
    "exp": 1520999538,
    "iss": "https://accounts.google.com",
    "iat": 1520995938,
    "name": "林宥勳",
    "picture": "https://lh4.googleusercontent.com/-ZalzZFc3U9s/AAAAAAAAAAI/AAAAAAAAAAA/AGi4gfwS0572TdyrUtBGt_e2MZ_mwliqDw/s96-c/photo.jpg",
    "given_name": "宥勳",
    "family_name": "林",
    "locale": "zh-TW"
}
```