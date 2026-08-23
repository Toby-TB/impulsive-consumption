<p align="center">
  <a href="README.md">简体中文</a> ·
  <a href="#-衝動消費--impulsive-consumption">繁體中文</a> ·
  <a href="README.en.md">English</a>
</p>

<p align="center">
  <img src="docs/images/banner.png" alt="Impulsive Consumption" width="100%"/>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.47-47C8FB?style=for-the-badge&logo=flutter&logoColor=white"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.13-0175C2?style=for-the-badge&logo=dart&logoColor=white"/></a>
  <a href="https://drift.simonbinder.eu/"><img src="https://img.shields.io/badge/SQLite-drift-003B57?style=for-the-badge&logo=sqlite&logoColor=white"/></a>
  <a href="https://riverpod.dev/"><img src="https://img.shields.io/badge/State-Riverpod-06B6D4?style=for-the-badge"/></a>
  <img src="https://img.shields.io/badge/Network-100%25_Offline-7ED321?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Languages-3-FF6B9D?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/License-MIT-FFC53D?style=for-the-badge"/>
</p>

# 🛍️ 衝動消費 · Impulsive Consumption

> 💥 **今天不買，明天後悔！** —— 一個 **純本地 · 零網路 · 零真實支付** 的輕遊戲化模擬購物 App。

完整體驗「逛 → 加購 → 領券 → 支付 → 訂單 → 物流 → 簽到 → 成就」的購物狂歡，所有資料只存在你的裝置裡（SQLite），隨便揮霍、一鍵重置、放心重來。

## ✨ 玩點一覽

| 🎮 模組 | 🎯 亮點 |
|---|---|
| 🏪 **商品系統** | 28 件真實商品 · 6 大分類 · 搜尋 · 詳情頁 · 月銷量/評分/庫存擬真欄位 · **次日自動補貨** |
| 👛 **本地錢包** | 初始餘額 ¥10,000 · 模擬充值 · 支付校驗扣款 · 收支明細全記錄 |
| 🛒 **購物車** | 勾選部分結算 · 即時總價 · 數量上限=庫存 · 一鍵清空 |
| 💳 **結算支付** | 4 張優惠券（滿減/折扣）· 餘額不足引導充值 · **約 30% 機率觸發支付彩蛋**（驚喜立減/返幣）· 彩帶+打勾支付動畫 · 事務原子下單 |
| 📦 **訂單中心** | 歷史訂單 · 詳情 · **模擬物流時間線**（每秒推進）· 一鍵再次購買 |
| 🚚 **雙檔物流** | 極速演示約 3 分鐘送達（預設）/ 擬真 1–3 天，重啟後進度不丟 |
| ✍️ **每日簽到** | 連續 7 天循環遞增獎勵（¥5~¥12），斷簽重來 |
| 🏆 **成就徽章** | 首單達成 / 剁手大師 / 七日之約 / 收藏家 / 揮金如土 + 徽章牆 |
| ❤️ **收藏夾** | 心願單式收藏，一鍵直達 |
| 🌏 **三語三幣** | 简体中文 / 繁體中文 / English；CNY ¥ / HKD HK$ / USD US$ 即時換算 |
| 🌗 **主題** | 奶油暖底 + 活力橙珊瑚，明/暗/跟隨系統 |
| 🔄 **演示重置** | 設定頁一鍵恢復初始狀態，隨時重新開玩 |
| 📴 **完全離線** | 無任何網路請求，商品圖隨應用打包 |

## 📸 介面預覽

<p align="center">
  <img src="docs/images/home.png" alt="首頁" width="240"/>
  <img src="docs/images/products.png" alt="商品畫廊" width="600"/>
</p>

## 🖼️ 商品畫廊（28 件真實商品）

### 🖥️ 顯示卡
| <img src="assets/images/products/nvidia-rtx-4090.png" width="105"><br><sub>輝達 GeForce RTX 4090 24GB 顯示卡 · ¥12,999</sub> | <img src="assets/images/products/gigabyte-rtx-5090.png" width="105"><br><sub>技嘉 GeForce RTX 5090 Windforce OC 32GB · ¥16,499</sub> | <img src="assets/images/products/asus-rog-strix-4090.png" width="105"><br><sub>華碩 ROG Strix GeForce RTX 4090 24GB · ¥13,499</sub> | <img src="assets/images/products/zotac-rtx-5090.png" width="105"><br><sub>索泰 GeForce RTX 5090 Solid OC 32GB · ¥15,999</sub> | <img src="assets/images/products/msi-gaming-trio-4090.png" width="105"><br><sub>微星 GeForce RTX 4090 Gaming Trio 24GB · ¥12,899</sub> | <img src="assets/images/products/gigabyte-5090-aorus.png" width="105"><br><sub>技嘉 RTX 5090 Aorus Master 32GB · ¥17,999</sub> | <img src="assets/images/products/inno3d-rtx-5090.png" width="105"><br><sub>映眾 GeForce RTX 5090 X3 32GB · ¥14,899</sub> |
|---|---|---|---|---|---|---|

### 🎮 遊戲裝備
| <img src="assets/images/products/ps5-slim.png" width="105"><br><sub>PlayStation 5 Slim 數位版 · ¥2,999</sub> | <img src="assets/images/products/stern-pinball.png" width="105"><br><sub>Stern 彈珠台 – Metallica Pro · ¥49,999</sub> | <img src="assets/images/products/airhockey-kids.png" width="105"><br><sub>Air Kids 專業氣墊球桌 · ¥8,999</sub> | <img src="assets/images/products/airhockey-pro.png" width="105"><br><sub>專業投幣式氣墊球桌 · ¥13,999</sub> | <img src="assets/images/products/fanatec-gt-extreme.png" width="105"><br><sub>Fanatec GT DD Extreme 方向盤套裝 · ¥11,999</sub> | <img src="assets/images/products/fanatec-f1-kit.png" width="105"><br><sub>Fanatec ClubSport F1 方向盤套裝 · ¥10,999</sub> | <img src="assets/images/products/simagic-alpha-pro.png" width="105"><br><sub>Simagic Alpha Pro 基座套裝 · ¥9,899</sub> | <img src="assets/images/products/darth-vader-statue.png" width="105"><br><sub>達斯·維達 Mythos 1/4 雕像 · ¥10,499</sub> | <img src="assets/images/products/fanatec-dd-plus.png" width="105"><br><sub>Fanatec ClubSport DD+ 基座套裝 · ¥9,499</sub> |
|---|---|---|---|---|---|---|---|---|

### 💻 整機電腦
| <img src="assets/images/products/pulse-bluepc.png" width="105"><br><sub>Pulse BluePC 遊戲主機 i9-14900KF · ¥13,999</sub> | <img src="assets/images/products/aura-workstation.png" width="105"><br><sub>AURA by BluePC 遊戲工作站 · ¥17,499</sub> |
|---|---|

### 💄 美妝護膚
| <img src="assets/images/products/centella-cream.png" width="105"><br><sub>積雪草保濕面霜 50ml · ¥159</sub> | <img src="assets/images/products/roundlab-toner.png" width="105"><br><sub>Round Lab 1025 Dokdo 化妝水 190ml · ¥169</sub> | <img src="assets/images/products/somebymi-foam.png" width="105"><br><sub>Some By Mi 30 天奇蹟祛痘潔面 · ¥149</sub> | <img src="assets/images/products/mask-set-6.png" width="105"><br><sub>韓系面膜套裝 6 片 · ¥89</sub> | <img src="assets/images/products/collagen-mask.png" width="105"><br><sub>膠原蛋白面膜 6 片裝 · ¥79</sub> | <img src="assets/images/products/joseon-sunscreen.png" width="105"><br><sub>Beauty of Joseon 米水防曬精華 · ¥129</sub> | <img src="assets/images/products/sleep-lip-mask.png" width="105"><br><sub>睡眠唇膜 20g · ¥99</sub> | <img src="assets/images/products/medicube-mask.png" width="105"><br><sub>Medicube PDRN 粉色面膜 28g · ¥139</sub> | <img src="assets/images/products/laneige-lipmask.png" width="105"><br><sub>Laneige 唇膜（漿果味）20g · ¥169</sub> | <img src="assets/images/products/roundlab-exfoliant.png" width="105"><br><sub>Dokdo 1025 去角質化妝水 100ml · ¥179</sub> |
|---|---|---|---|---|---|---|---|---|---|

## 🏗️ 架構

```mermaid
flowchart LR
  subgraph UI["🎨 Flutter UI 層"]
    A["🏪 商品/搜尋"] --- B["🛒 購物車/結算"]
    C["📦 訂單/物流"] --- D["👛 錢包/簽到"]
    E["🏆 成就/收藏/設定"]
  end
  UI --> S["🧠 Riverpod 狀態層<br/>Provider / StreamProvider"]
  S --> DB["🗄️ drift (SQLite)<br/>10 張表 · 事務原子下單"]
  DB --> L["📱 裝置本地儲存<br/>Windows / macOS / Android / iOS / Web"]
```

## 🚀 快速開始

| 平台 | 命令 | 產物 |
|---|---|---|
| 📱 Android | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| 🌐 Web（Windows 測試推薦） | `flutter build web --release --base-href /` 後雙擊 `start_web.bat` | 瀏覽器本地開啟，無需域名 |
| 🪟 Windows 原生 | `flutter build windows --release` | 需 Windows + Visual Studio 工具鏈 |
| 🍎 macOS / iOS | `flutter build macos --release` / `flutter build ios --release` | 需 macOS + Xcode |
| 🔧 開發調試 | `flutter run -d chrome` | 熱重載 |

> 🌍 **線上體驗（GitHub Pages）**：https://toby-tb.github.io/impulsive-consumption/ —— 每次 push 到 main 自動建置部署

```bash
flutter analyze   # 0 issue
flutter test      # 18 個單測全綠（匯率/優惠券/物流/目錄一致性）
```

## 🎨 自由訂製

- **換成自己的商品圖**：同名覆蓋 `assets/images/products/<商品id>.png` 即可（600×600+ 方形為佳）
- **重新拉取真實商品圖**：編輯 `tool/fetch_real.sh` 後運行（圖片來自公開商品頁，僅供學習演示，請勿商用）
- **重新生成橫幅與應用圖示**：`bash tool/gen_images.sh`（需 Chrome），圖示生成後 `dart run flutter_launcher_icons`

| 模擬參數 | 位置 |
|---|---|
| 匯率（CNY=1 / HKD=0.92 / USD=7.20） | `lib/core/money.dart` |
| 初始餘額 ¥10,000 | `lib/data/catalog/products.dart` → `initialBalanceCents` |
| 商品/價格/庫存/月銷/評分 | 同檔案 `products` |
| 優惠券 / 簽到獎勵 | 同檔案 `couponPresets` / `signinRewards` |
| 物流時長兩檔 | `lib/core/logistics.dart` |
| 支付彩蛋機率與力度 | `lib/data/db/database.dart` → `placeOrder` |
| 成就門檻 | `lib/core/achievements.dart` |

## ❓ 常見問題

- **商品圖版權**：商品圖片來源於 dopamineshopping.com 等公開商品頁面，僅用於學習演示，商用請替換為自己的圖片。
- **Web 版白屏？** Flutter Web 必須透過 http 服務訪問（`file://` 開啟不行），用 `start_web.bat` 或任意靜態伺服器。
- **APK 安裝提示風險？** 未簽名的測試包屬正常提示；上架商店需自行設定簽名。
- **怎麼接真實後端？** 資料層集中在 `lib/data/db/database.dart` 與 `lib/state/providers.dart`，替換為 API 呼叫即可，UI 無需改動。
- **演示亂了怎麼辦？** 我的 → 設定 → 重置演示資料，一鍵回到 ¥10,000 開局。

## 📜 License

[MIT](LICENSE) © 2026 衝動消費 contributors

---

<p align="center">🛍️ 本應用為純模擬演示：不涉及真實支付，也不會發起任何網路請求 🛍️</p>
