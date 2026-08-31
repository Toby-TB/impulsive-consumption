<p align="center">
  <a href="#-冲动消费--impulsive-consumption">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
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

# 🛍️ 冲动消费 · Impulsive Consumption

> 💥 **今天不买，明天后悔！** —— 一个 **纯本地 · 零网络 · 零真实支付** 的轻游戏化模拟购物 App。

完整体验「逛 → 加购 → 领券 → 支付 → 订单 → 物流 → 签到 → 成就」的购物狂欢，所有数据只存在你的设备里（SQLite），随便挥霍、一键重置、放心重来。

## ✨ 玩点一览

| 🎮 模块 | 🎯 亮点 |
|---|---|
| 🏪 **商品系统** | 60 件真实商品 · 6 大分类 · 搜索 · 详情页 · 月销量/评分/库存拟真字段 · **次日自动补货** |
| 👛 **本地钱包** | 初始余额 ¥10,000 · 模拟充值 · 支付校验扣款 · 收支明细全记录 |
| 🛒 **购物车** | 勾选部分结算 · 实时总价 · 数量上限=库存 · 一键清空 |
| 💳 **结算支付** | 4 张优惠券（满减/折扣）· 余额不足引导充值 · **约 30% 概率触发支付彩蛋**（惊喜立减/返币）· 彩带+打勾支付动画 · 事务原子下单 |
| 📦 **订单中心** | 历史订单 · 详情 · **模拟物流时间线**（每秒推进）· 一键再次购买 |
| 🚚 **双档物流** | 极速演示约 3 分钟送达（默认）/ 拟真 1–3 天，重启后进度不丢 |
| ✍️ **每日签到** | 连续 7 天循环递增奖励（¥5~¥12），断签重来 |
| 🏆 **成就徽章** | 首单达成 / 剁手大师 / 七日之约 / 收藏家 / 挥金如土 + 徽章墙 |
| ❤️ **收藏夹** | 心愿单式收藏，一键直达 |
| 🌏 **三语三币** | 简体中文 / 繁體中文 / English；CNY ¥ / HKD HK$ / USD US$ 即时换算 |
| 🌗 **主题** | 奶油暖底 + 活力橙珊瑚，明/暗/跟随系统 |
| 🔄 **演示重置** | 设置页一键恢复初始状态，随时重新开玩 |
| 📴 **完全离线** | 无任何网络请求，商品图随应用打包 |

## 📸 界面预览

<p align="center">
  <img src="docs/images/home.png" alt="首页" width="240"/>
  <img src="docs/images/products.png" alt="商品画廊" width="600"/>
</p>

## 🖼️ 商品画廊（60 件真实商品）

### 🖥️ 显卡
| <img src="assets/images/products/nvidia-rtx-4090.png" width="105"><br><sub>NVIDIA GeForce RTX 4090 24GB 显卡 · ¥12,999</sub> | <img src="assets/images/products/gigabyte-rtx-5090.png" width="105"><br><sub>技嘉 GeForce RTX 5090 Windforce OC 32GB · ¥16,499</sub> | <img src="assets/images/products/asus-rog-strix-4090.png" width="105"><br><sub>华硕 ROG Strix GeForce RTX 4090 24GB · ¥13,499</sub> | <img src="assets/images/products/zotac-rtx-5090.png" width="105"><br><sub>索泰 GeForce RTX 5090 Solid OC 32GB · ¥15,999</sub> | <img src="assets/images/products/msi-gaming-trio-4090.png" width="105"><br><sub>微星 GeForce RTX 4090 Gaming Trio 24GB · ¥12,899</sub> | <img src="assets/images/products/gigabyte-5090-aorus.png" width="105"><br><sub>技嘉 RTX 5090 Aorus Master 32GB · ¥17,999</sub> | <img src="assets/images/products/inno3d-rtx-5090.png" width="105"><br><sub>映众 GeForce RTX 5090 X3 32GB · ¥14,899</sub> |
|---|---|---|---|---|---|---|

### 🎮 游戏装备
| <img src="assets/images/products/ps5-slim.png" width="105"><br><sub>PlayStation 5 Slim 数字版 · ¥2,999</sub> | <img src="assets/images/products/stern-pinball.png" width="105"><br><sub>Stern Metallica Pro 弹珠台 · ¥49,999</sub> | <img src="assets/images/products/airhockey-kids.png" width="105"><br><sub>Air Kids 专业气垫球桌 · ¥8,999</sub> | <img src="assets/images/products/airhockey-pro.png" width="105"><br><sub>专业投币式气垫球桌 · ¥13,999</sub> | <img src="assets/images/products/fanatec-gt-extreme.png" width="105"><br><sub>Fanatec GT DD Extreme 方向盘套装 · ¥11,999</sub> | <img src="assets/images/products/fanatec-f1-kit.png" width="105"><br><sub>Fanatec ClubSport F1 方向盘套装 · ¥10,999</sub> | <img src="assets/images/products/simagic-alpha-pro.png" width="105"><br><sub>Simagic Alpha Pro 基座套装 · ¥9,899</sub> | <img src="assets/images/products/darth-vader-statue.png" width="105"><br><sub>达斯·维达 Mythos 1/4 雕像 · ¥10,499</sub> | <img src="assets/images/products/fanatec-dd-plus.png" width="105"><br><sub>Fanatec ClubSport DD+ 基座套装 · ¥9,499</sub> |
|---|---|---|---|---|---|---|---|---|

### 💻 整机电脑
| <img src="assets/images/products/pulse-bluepc.png" width="105"><br><sub>Pulse BluePC 游戏主机 i9-14900KF · ¥13,999</sub> | <img src="assets/images/products/aura-workstation.png" width="105"><br><sub>AURA by BluePC 游戏工作站 · ¥17,499</sub> |
|---|---|

### 💄 美妆护肤
| <img src="assets/images/products/centella-cream.png" width="105"><br><sub>积雪草保湿面霜 50ml · ¥159</sub> | <img src="assets/images/products/roundlab-toner.png" width="105"><br><sub>Round Lab 1025 Dokdo 化妆水 190ml · ¥169</sub> | <img src="assets/images/products/somebymi-foam.png" width="105"><br><sub>Some By Mi 30 天奇迹祛痘洁面 · ¥149</sub> | <img src="assets/images/products/mask-set-6.png" width="105"><br><sub>韩系面膜套装 6 片 · ¥89</sub> | <img src="assets/images/products/collagen-mask.png" width="105"><br><sub>胶原蛋白面膜 6 片装 · ¥79</sub> | <img src="assets/images/products/joseon-sunscreen.png" width="105"><br><sub>Beauty of Joseon 米水防晒精华 · ¥129</sub> | <img src="assets/images/products/sleep-lip-mask.png" width="105"><br><sub>睡眠唇膜 20g · ¥99</sub> | <img src="assets/images/products/medicube-mask.png" width="105"><br><sub>Medicube PDRN 粉色面膜 28g · ¥139</sub> | <img src="assets/images/products/laneige-lipmask.png" width="105"><br><sub>兰芝唇膜（浆果味）20g · ¥169</sub> | <img src="assets/images/products/roundlab-exfoliant.png" width="105"><br><sub>Dokdo 1025 去角质化妆水 100ml · ¥179</sub> |
|---|---|---|---|---|---|---|---|---|---|

## 🏗️ 架构

```mermaid
flowchart LR
  subgraph UI["🎨 Flutter UI 层"]
    A["🏪 商品/搜索"] --- B["🛒 购物车/结算"]
    C["📦 订单/物流"] --- D["👛 钱包/签到"]
    E["🏆 成就/收藏/设置"]
  end
  UI --> S["🧠 Riverpod 状态层<br/>Provider / StreamProvider"]
  S --> DB["🗄️ drift (SQLite)<br/>10 张表 · 事务原子下单"]
  DB --> L["📱 设备本地存储<br/>Windows / macOS / Android / iOS / Web"]
```

## 📥 下载安装（无需开发环境）

- 📱 **Android**：到 [Releases 页面](https://github.com/Toby-TB/impulsive-consumption/releases) 下载最新 `app-release.apk`，传到手机安装（需允许"未知来源应用"）
- 🌐 **Web/PC**：直接打开 https://toby-tb.github.io/impulsive-consumption/ （无需安装）

## 🚀 快速开始（开发者）

| 平台 | 命令 | 产物 |
|---|---|---|
| 📱 Android | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| 🌐 Web（Windows 测试推荐） | `flutter build web --release --base-href /` 后双击 `start_web.bat` | 浏览器本地打开，无需域名 |
| 🪟 Windows 原生 | `flutter build windows --release` | 需 Windows + Visual Studio 工具链 |
| 🍎 macOS / iOS | `flutter build macos --release` / `flutter build ios --release` | 需 macOS + Xcode |
| 🔧 开发调试 | `flutter run -d chrome` | 热重载 |

> 🌍 **在线体验（GitHub Pages）**：https://toby-tb.github.io/impulsive-consumption/ —— 每次 push 到 main 自动构建部署

```bash
flutter analyze   # 0 issue
flutter test      # 18 个单测全绿（汇率/优惠券/物流/目录一致性）
```

## 🎨 自由定制

- **换成自己的商品图**：同名覆盖 `assets/images/products/<商品id>.png` 即可（600×600+ 方形为佳）
- **重新拉取真实商品图**：编辑 `tool/fetch_real.sh` 后运行（图片来自公开商品页，仅供学习演示，请勿商用）
- **重新生成横幅与应用图标**：`bash tool/gen_images.sh`（需 Chrome），图标生成后 `dart run flutter_launcher_icons`

| 模拟参数 | 位置 |
|---|---|
| 汇率（CNY=1 / HKD=0.92 / USD=7.20） | `lib/core/money.dart` |
| 初始余额 ¥10,000 | `lib/data/catalog/products.dart` → `initialBalanceCents` |
| 商品/价格/库存/月销/评分 | 同文件 `products` |
| 优惠券 / 签到奖励 | 同文件 `couponPresets` / `signinRewards` |
| 物流时长两档 | `lib/core/logistics.dart` |
| 支付彩蛋概率与力度 | `lib/data/db/database.dart` → `placeOrder` |
| 成就门槛 | `lib/core/achievements.dart` |

## ❓ 常见问题

- **商品图版权**：商品图片来源于 dopamineshopping.com 等公开商品页面，仅用于学习演示，商用请替换为自己的图片。
- **Web 版白屏？** Flutter Web 必须通过 http 服务访问（`file://` 打开不行），用 `start_web.bat` 或任意静态服务器。
- **APK 安装提示风险？** 未签名的测试包属正常提示；上架商店需自行配置签名。
- **怎么接真实后端？** 数据层集中在 `lib/data/db/database.dart` 与 `lib/state/providers.dart`，替换为 API 调用即可，UI 无需改动。
- **演示乱了怎么办？** 我的 → 设置 → 重置演示数据，一键回到 ¥10,000 开局。

## 📜 License

[MIT](LICENSE) © 2026 冲动消费 contributors

---

<p align="center">🛍️ 本应用为纯模拟演示：不涉及真实支付，也不会发起任何网络请求 🛍️</p>
