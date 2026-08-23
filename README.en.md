<p align="center">
  <a href="README.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="#-impulsive-consumption">English</a>
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

# 🛍️ Impulsive Consumption

> 💥 **Buy today, regret tomorrow!** —— a light-gamified shopping simulator that is **100% local, zero network, zero real payment**.

Experience the full shopping spree — browse → cart → coupons → checkout → orders → logistics → sign-in → achievements — with all data stored only on your device (SQLite). Splurge freely, reset with one tap, start over anytime.

## ✨ Highlights

| 🎮 Module | 🎯 What you get |
|---|---|
| 🏪 **Product system** | 28 hand-drawn illustrated products · 6 categories · search · detail page · simulated monthly sales / rating / stock · **daily auto restock** |
| 👛 **Local wallet** | Initial balance ¥10,000 · simulated top-up · balance check & deduction · full transaction history |
| 🛒 **Cart** | Partial checkout with checkboxes · real-time total · quantity capped by stock · clear all |
| 💳 **Checkout & payment** | 4 coupons (fixed-off / percent-off) · insufficient-balance flow to recharge · **~30% chance of a lucky egg** (surprise discount / rebate) · confetti + check-mark animation · atomic order transaction |
| 📦 **Order center** | Order history · details · **simulated logistics timeline** (updates every second) · one-tap buy again |
| 🚚 **Two logistics speeds** | Turbo demo (~3 min delivery, default) / Realistic (1–3 days); progress survives restarts |
| ✍️ **Daily sign-in** | 7-day cycle with increasing rewards (¥5~¥12), streak resets on a missed day |
| 🏆 **Achievements** | First Order / Shopaholic / Week Streak / Collector / Big Spender + badge wall |
| ❤️ **Favorites** | Wishlist-style collection |
| 🌏 **3 languages & currencies** | Simplified Chinese / Traditional Chinese / English; CNY ¥ / HKD HK$ / USD US$ with live conversion |
| 🌗 **Themes** | Creamy warm base + vivid orange-coral, light / dark / system |
| 🔄 **Demo reset** | One tap in Settings to restore the initial state |
| 📴 **Fully offline** | Zero network requests; all product art is bundled |

## 📸 Screenshots

<p align="center">
  <img src="docs/images/home.png" alt="Home" width="240"/>
  <img src="docs/images/products.png" alt="Product gallery" width="600"/>
</p>

## 🖼️ Product Gallery (28 hand-drawn items)

### 📱 Digital
| <img src="assets/images/products/phone.png" width="105"><br><sub>Starlight X1 Phone · ¥7999</sub> | <img src="assets/images/products/buds.png" width="105"><br><sub>Silence Pro ANC Buds · ¥1299</sub> | <img src="assets/images/products/watch.png" width="105"><br><sub>Flow S Smart Watch · ¥1899</sub> | <img src="assets/images/products/laptop.png" width="105"><br><sub>Swift Air Ultrabook · ¥6599</sub> | <img src="assets/images/products/camera.png" width="105"><br><sub>Frame M2 Mirrorless · ¥4599</sub> | <img src="assets/images/products/tablet.png" width="105"><br><sub>Nova Tablet · ¥2499</sub> | <img src="assets/images/products/sunglasses.png" width="105"><br><sub>Summer Glare Shades · ¥199</sub> |
|---|---|---|---|---|---|---|

### 👕 Fashion
| <img src="assets/images/products/sneakers.png" width="105"><br><sub>Cloud Runner Sneakers · ¥599</sub> | <img src="assets/images/products/tee.png" width="105"><br><sub>Cotton Print Tee · ¥129</sub> | <img src="assets/images/products/coat.png" width="105"><br><sub>Warm Wool Coat · ¥899</sub> | <img src="assets/images/products/cap.png" width="105"><br><sub>Street Baseball Cap · ¥89</sub> | <img src="assets/images/products/jeans.png" width="105"><br><sub>Retro Straight Jeans · ¥299</sub> |
|---|---|---|---|---|

### 🍰 Food
| <img src="assets/images/products/chocolate.png" width="105"><br><sub>Velvet Chocolate Box · ¥99</sub> | <img src="assets/images/products/coffee.png" width="105"><br><sub>Pour-over Coffee Beans · ¥128</sub> | <img src="assets/images/products/fruit.png" width="105"><br><sub>Sunshine Fruit Basket · ¥168</sub> | <img src="assets/images/products/ramen.png" width="105"><br><sub>Midnight Ramen Kit · ¥59</sub> | <img src="assets/images/products/tea.png" width="105"><br><sub>Alpine Oolong Tea · ¥218</sub> |
|---|---|---|---|---|

### 🛋️ Home
| <img src="assets/images/products/sofa.png" width="105"><br><sub>Cloud Modular Sofa · ¥2999</sub> | <img src="assets/images/products/lamp.png" width="105"><br><sub>Care Smart Lamp · ¥199</sub> | <img src="assets/images/products/plush.png" width="105"><br><sub>Healing Bear Plush · ¥79</sub> | <img src="assets/images/products/candle.png" width="105"><br><sub>Forest Aroma Candle · ¥69</sub> | <img src="assets/images/products/mug.png" width="105"><br><sub>Handmade Ceramic Mug · ¥49</sub> |
|---|---|---|---|---|

### 💄 Beauty
| <img src="assets/images/products/lipstick.png" width="105"><br><sub>Velvet Matte Lipstick · ¥320</sub> | <img src="assets/images/products/cream.png" width="105"><br><sub>Glow Moisturizer Cream · ¥480</sub> | <img src="assets/images/products/nail.png" width="105"><br><sub>Nail Party Polish Set · ¥150</sub> |
|---|---|---|

### 📚 Books
| <img src="assets/images/products/novel.png" width="105"><br><sub>Stardust Trilogy · ¥89</sub> | <img src="assets/images/products/watercolor.png" width="105"><br><sub>Watercolor Starter Guide · ¥129</sub> | <img src="assets/images/products/guide.png" width="105"><br><sub>City Wander Guide · ¥59</sub> |
|---|---|---|

## 🏗️ Architecture

```mermaid
flowchart LR
  subgraph UI["🎨 Flutter UI"]
    A["🏪 Shop/Search"] --- B["🛒 Cart/Checkout"]
    C["📦 Orders/Logistics"] --- D["👛 Wallet/Sign-in"]
    E["🏆 Achievements/Favorites/Settings"]
  end
  UI --> S["🧠 Riverpod State<br/>Provider / StreamProvider"]
  S --> DB["🗄️ drift (SQLite)<br/>10 tables · atomic order transactions"]
  DB --> L["📱 On-device storage<br/>Windows / macOS / Android / iOS / Web"]
```

## 🚀 Quick Start

| Platform | Command | Output |
|---|---|---|
| 📱 Android | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| 🌐 Web (recommended for Windows testing) | `flutter build web --release --base-href /` then double-click `start_web.bat` | Serve locally in your browser — no domain needed |
| 🪟 Windows native | `flutter build windows --release` | Requires Windows + Visual Studio toolchain |
| 🍎 macOS / iOS | `flutter build macos --release` / `flutter build ios --release` | Requires macOS + Xcode |
| 🔧 Dev | `flutter run -d chrome` | Hot reload |

```bash
flutter analyze   # 0 issues
flutter test      # 18 unit tests green (currency/coupons/logistics/catalog)
```

## 🎨 Make It Yours

- **Real product photos**: overwrite `assets/images/products/<product-id>.png` with same-name files (square, 600×600+ recommended)
- **Regenerate illustrations**: edit `tool/assets_src/*.svg` → `bash tool/gen_images.sh` (requires Chrome)
- **App icon**: edit `tool/assets_src/app_icon.svg` → regenerate → `dart run flutter_launcher_icons`

| Simulated parameter | Where |
|---|---|
| Exchange rates (CNY=1 / HKD=0.92 / USD=7.20) | `lib/core/money.dart` |
| Initial balance ¥10,000 | `lib/data/catalog/products.dart` → `initialBalanceCents` |
| Products / prices / stock / sales / rating | same file, `products` |
| Coupons / sign-in rewards | same file, `couponPresets` / `signinRewards` |
| Logistics durations | `lib/core/logistics.dart` |
| Lucky-egg probability & amount | `lib/data/db/database.dart` → `placeOrder` |
| Achievement thresholds | `lib/core/achievements.dart` |

## ❓ FAQ

- **Web version shows a blank page?** Flutter Web must be served over http (opening `file://` won't work) — use `start_web.bat` or any static server.
- **APK install warning?** An unsigned test build triggers a normal warning; configure signing before publishing to stores.
- **How to plug in a real backend?** All data access lives in `lib/data/db/database.dart` and `lib/state/providers.dart` — swap them for API calls; the UI stays untouched.
- **Demo state messed up?** Me → Settings → Reset demo data, back to a fresh ¥10,000 start.

## 📜 License

[MIT](LICENSE) © 2026 Impulsive Consumption contributors

---

<p align="center">🛍️ This app is a pure simulation: no real payments, no network requests 🛍️</p>
