---
layout: post
title: Agent Skill 進階指南
description: "本文深度解析 Anthropic 提出的 Agent Skill 開放標準，探討其如何透過漸進式披露機制優化 AI Agent 的 Token 消耗。內容涵蓋 skill.md 的構造、Reference 與 Script 的進階實作，並釐清其與 MCP 在數據處理上的本質區別"
categories: AI
tags: [AI, Agent Skill, Agent, Anthropic]
comments: true
---

在 AI Agent 領域中，如何讓大模型穩定地執行特定任務並節省 Token 成本，是開發者面臨的核心挑戰。Anthropic 於 **2025 年 10 月 16 日正式推出了 Agent Skill**，起初是為了提升 Claude 在特定任務上的表現，隨後因其設計優異，迅速被 VS Code、Cursor 等工具支持，並於 12 月 18 日演變為**跨平台的開放標準**。

本文將深入探討 Agent Skill 的核心架構，特別是 **Reference** 與 **Script** 這兩個進階功能的使用與原理。

---

### 什麼是 Agent Skill？

最通俗的理解是：**Agent Skill 是大模型可以隨時翻閱的「說明文檔」**。

當你需要 AI 執行特定任務（如智能客服或會議助理）時，你不再需要在每次對話中重複貼上冗長的要求。只需將規則寫進 Skill 中，模型便會根據需求自行查閱這份說明書。

#### Skill 的基本構造
每一個 Agent Skill 都存放在以其名稱命名的文件夾中，核心文件是 `skill.md`。其結構包含：
1.  **元數據 (Metadata)**：由兩段短橫線包圍，包含 `name`（須與文件夾名一致）與 `description`（描述，向模型說明此 Skill 的用途）。
2.  **指令 (Instruction)**：詳細描述模型需要遵循的規則，甚至可以包含範例（Few-shot）來確保輸出格式符合預期。

---

### 核心機制：漸進式披露 (Progressive Disclosure)

Agent Skill 之所以高效，是因為它採用了**按需加載 (On-demand Loading)** 的三層結構，大幅節省 Token 消耗：

1.  **元數據層 (Metadata)**：**始終加載**。模型只讀取 Skill 的名稱與描述，作為判斷是否需要該 Skill 的「目錄」。
2.  **指令層 (Instruction)**：當模型判定任務相關後，才會讀取 `skill.md` 中的具體指令正文。
3.  **資源層 (Resource Layer)**：包含 **Reference** 與 **Script**，僅在觸發特定條件時才會加載或執行。

以下是為您調整後的段落，特別加入了**檔案路徑說明**以及**範例代碼塊**，方便您直接複製使用：

---

### 進階功能：Reference (參考資源)

**Reference** 解決了「說明文檔過於臃腫」的問題。例如，會議助理可能需要參考繁雜的財務規章，但並非每次會議都會用到。

*   **運作原理**：開發者在 `skill.md` 中設定觸發規則。
*   **特性**：它是**按需加載中的按需加載**。若任務與資源無關，文件會留在硬碟中，**不佔用 Token**。
*   **影響**：內容會加載到模型上下文，因此會消耗 Token。

#### 📂 檔案路徑與範例
**檔案位置：** `~/Documents/Claude/skills/會議總結助手/集團財務手冊.md`

**`skill.md` 中的配置範例：**
```markdown
### 財務合規檢查
若會議內容提到「錢」、「預算」、「採購」或「報銷費用」時，
請讀取 `集團財務手冊.md`。
根據手冊內容指出會議決定中的金額是否超標，並明確審批人。
```

**`集團財務手冊.md` 內容範例：**
```markdown
# 集團財務報銷標準
- 住宿補貼：每晚上限 500 元
- 餐飲費用：每人每餐上限 300 元
- 交通補助：僅限二等座或經濟艙
```

---

### 進階功能：Script (腳本執行)

如果說 Reference 是讓模型「查資料」，那麼 **Script** 就是讓模型「動手做」，是實現自動化的關鍵。

*   **運作原理**：在 Skill 文件夾中放置腳本（如 Python），並在指令中定義執行時機。
*   **核心優勢**：**模型只執行不讀取**。即使腳本有萬行邏輯，它消耗的上下文 Token 幾乎為零。
*   **特性**：模型僅關心執行結果，讓複雜業務邏輯變得輕量化。

#### 📂 檔案路徑與範例
**檔案位置：** `~/Documents/Claude/skills/會議總結助手/upload.py`

**`skill.md` 中的配置範例：**
```markdown
### 自動化同步規則
如果用戶提到「上傳」、「同步」或「發送到伺服器」等字眼，
你必須運行 `upload.py` 腳本。
這將會把會議總結內容上傳至公司內部伺服器。
```

**`upload.py` 腳本範例：**
```python
import sys

def upload_summary(content):
    # 這裡模擬上傳邏輯
    print(f"成功將以下內容上傳至伺服器：\n{content}")

if __name__ == "__main__":
    # 接收來自模型的總結內容
    summary_data = sys.stdin.read()
    upload_summary(summary_data)
```

---

### 💡 核心機制小結：漸進式披露 (Progressive Disclosure)

Agent Skill 的設計是一個精密的**三層結構**，確保效率最大化：

1.  **元數據層 (Metadata)**：位於 `skill.md` 頭部，始終加載，作為模型判斷需求的「目錄」。
2.  **指令層 (Instruction)**：`skill.md` 正文，僅在 Skill 被選中時「按需加載」。
3.  **資源層 (Resource Layer)**：即 **Reference** 與 **Script**，屬於「按需中的按需」，只有觸發特定規則時才會讀取或執行。

**比喻：**
這就像是一個**三層保險櫃**。模型平常只看**標籤（Metadata）**；確定要用時才打開**櫃門（Instruction）**；最後只有在需要特定工具時，才會從**抽屜（Reference/Script）**裡取出說明書或啟動機器。

### Agent Skill 與 MCP 的區別

許多開發者會將 Agent Skill 與 **MCP (Model Context Protocol)** 混淆。Anthropic 官方指出：**"MCP connects data; skills teach what to do with that data."**

| 特性 | MCP | Agent Skill |
| :--- | :--- | :--- |
| **本質** | 獨立運行的程序 | 一段說明文檔與輕量腳本 |
| **定位** | 為模型提供數據（如查詢銷售記錄） | 教導模型處理數據（如總結格式） |
| **安全與穩定** | 較高，適合複雜數據連接 | 適合輕量邏輯與格式規範 |

雖然 Skill 也可以寫代碼連接數據，但官方建議將兩者結合使用：用 MCP 獲取數據，用 Skill 定義處理數據的邏輯。

---

### 總結

Agent Skill 透過精密的**漸進式披露結構**，在功能性與成本之間取得了平衡。透過 **Reference** 實現知識的按需讀取，透過 **Script** 實現零負擔的自動化操作，為 AI Agent 的開發提供了一套通用的設計模式。

**比喻：**
Agent Skill 就像是給員工的一本**工作手冊**。**Metadata** 是封面目錄；**Instruction** 是基本準則；**Reference** 是遇到專業問題才去翻閱的**百科全書**；而 **Script** 則像是辦公桌上的**一鍵自動化按鈕**，員工只需按下去執行任務，而不需要背誦機器內部的運作代碼。