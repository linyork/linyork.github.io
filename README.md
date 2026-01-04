# York's Blog

基於 [Leonids Jekyll Theme](https://github.com/renyuanz/leonids) 的個人技術部落格。

## 🌐 網站資訊

- **網址**: https://york.hypenode.tw
- **主題**: Leonids - 簡潔的 Jekyll 主題
- **部署**: GitHub Pages

## ✨ 特色

- 📱 響應式設計 - 支援手機、平板、桌面
- 🎨 簡潔優雅的介面
- 📝 Markdown 撰寫
- 🔍 SEO 優化
- 📊 分類和標籤系統
- 💼 履歷頁面

## 🚀 本地開發

### 前置需求
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 快速啟動

#### Windows
```cmd
start-dev.bat
```

#### Mac/Linux
```bash
chmod +x start-dev.sh
./start-dev.sh
```

### 訪問網站
啟動後在瀏覽器開啟：
- http://localhost:4000

## 📝 撰寫文章

### 建立新文章
在 `_posts` 目錄建立檔案，格式：`YYYY-MM-DD-標題.md`

```markdown
---
layout: post
title: "文章標題"
date: 2026-01-04 12:00:00 +0800
categories: [分類1, 分類2]
tags: [標籤1, 標籤2]
---

文章內容...
```

## 🔧 技術棧

- **Jekyll**: 3.10.0
- **GitHub Pages**: 232
- **Kramdown**: 2.4.0
- **Rouge**: 3.30.0
- **Ruby**: 3.1.1 (Docker)

## 📚 文件

詳細的開發文件請參考 `docs/` 資料夾：
- [快速開始](docs/快速開始.md)
- [開發指南](docs/開發指南.md)

## 🛑 停止伺服器

按 `Ctrl + C`

## 📄 授權

本專案基於 MIT License。

---

**主題來源**: [Leonids Jekyll Theme](https://github.com/renyuanz/leonids)  
**作者**: York  
**最後更新**: 2026-01-04
