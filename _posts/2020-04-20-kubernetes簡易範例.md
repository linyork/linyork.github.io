---
layout: post
title: kubernetes簡易範例
categories: backend
tags:
- kubernetes
---
## 目的 ##

 - kubernetes 簡易範例

 <!-- more -->
 
## 參考 ##

https://medium.com/@C.W.Hu/kubernetes-implement-ingress-deployment-tutorial-7431c5f96c3e


## 架構圖 ##

![image](/img/1538058734402.jpg)


## YAML ##

#### ingress.yaml ####

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: web
spec:
  rules:
    - host: blue.demo.com
      http:
        paths:
          - backend:
              serviceName: blue-service
              servicePort: 80
    - host: purple.demo.com
      http:
        paths:
          - backend:
              serviceName: purple-service
              servicePort: 80
```

#### service.yaml ####

```yaml
apiVersion: v1
kind: Service
metadata:
  name: blue-service
spec:
  type: NodePort
  selector:
    app: blue-nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: purple-service
spec:
  type: NodePort
  selector:
    app: purple-nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

#### deployment.yaml ####
 
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue-nginx
spec:
  selector:
    matchLabels:
      app: blue-nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: blue-nginx
    spec:
      containers:
        - name: nginx
          image: hcwxd/blue-whale
          ports:
            - containerPort: 3000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: purple-nginx
spec:
  selector:
    matchLabels:
      app: purple-nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: purple-nginx
    spec:
      containers:
        - name: nginx
          image: hcwxd/purple-whale
          ports:
            - containerPort: 3000
```

