---
layout: post
title: Golang JWT實作
description: Implement JWT by Golang, 實作 JWT 功能
categories: backend
tags:
- go
- 驗證
- 技巧觀念
---

## 目的 ##

- 實作 JWT 功能
<!-- more -->

## 紀錄 ##

### 程式 ###

jwt.go
```
package jwt

import (
    "crypto/hmac"
    "crypto/sha256"
    "encoding/base64"
    "encoding/hex"
    "encoding/json"
    "fmt"
    "strings"
    "time"
)

var key = "CoryRightByYork!:P"

type header struct {
    Alg string `json:"alg"`
    Typ string `json:"typ"`
}

type payload struct {
    Id        string `json:"id"`
    Timestamp int64 `json:"timestamp"`
}

func Generate(id string) string {
    // 取得 header  payload 結構體
    header := getHeader()
    payload := getPayload(id)

    // 轉json格式
    jsonTokenHeader, _ := json.Marshal(header)
    jsonTokenPayload, _ := json.Marshal(payload)

    // 加密
    unsignedToken := structEncode(jsonTokenHeader) + "." + structEncode(jsonTokenPayload)
    signature := encodeHS256(unsignedToken)

    // 組合
    jwtToken := unsignedToken + "." + signature
    return jwtToken
}

func GetId(jwtToken string) string {
    // 分割字串取得 payload 部分
    split := strings.Split(jwtToken, ".")
    payloadByte := structDecode(split[1])

    // 宣告空 payload
    payload := payload{}

    // 解析 payload
    if err := json.Unmarshal(payloadByte, &payload); err != nil {
        fmt.Println(`failed payload Decode`, err)
    }

    return payload.Id
}

func getHeader() *header {
    return &header{
        Alg: "HS256",
        Typ: "JWT",
    }
}

func getPayload(id string) *payload {
    return &payload{
        Id:        id,
        Timestamp: time.Now().Unix(),
    }
}

func structEncode(s []byte) string {
    return base64.RawURLEncoding.EncodeToString(s)
}

func structDecode(str string) []byte {
    b, err := base64.RawURLEncoding.DecodeString(str)
    if err != nil {
        fmt.Println(`failed base64 Decode`, err)
    }
    return b
}

func encodeHS256(u string) string {
    // new 一個 HMAC 結構體使用 jwt 的 key
    h := hmac.New(sha256.New, []byte(key))

    // 寫入資料
    h.Write([]byte(u))

    // Get result and encode as hexadecimal string
    return hex.EncodeToString(h.Sum(nil))
}

func DecodeHS256(u string) string {
    return "TO DO"
}
```

使用
```
token := jwt.Generate(user)
useId := jwt.GetId(token)
``` 
