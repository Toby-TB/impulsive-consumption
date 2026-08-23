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
| 🏪 **Product system** | 28 real products · 6 categories · search · detail page · simulated monthly sales / rating / stock · **daily auto restock** |
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

## 🖼️ Product Gallery (28 real items)

### 🖥️ Graphics Cards
| <img src="assets/images/products/nvidia-rtx-4090.png" width="105"><br><sub>NVIDIA GeForce RTX 4090 24GB · ¥12,999</sub> | <img src="assets/images/products/gigabyte-rtx-5090.png" width="105"><br><sub>Gigabyte GeForce RTX 5090 Windforce OC 32GB · ¥16,499</sub> | <img src="assets/images/products/asus-rog-strix-4090.png" width="105"><br><sub>ASUS ROG Strix GeForce RTX 4090 24GB · ¥13,499</sub> | <img src="assets/images/products/zotac-rtx-5090.png" width="105"><br><sub>Zotac GeForce RTX 5090 Solid OC 32GB · ¥15,999</sub> | <img src="assets/images/products/msi-gaming-trio-4090.png" width="105"><br><sub>MSI GeForce RTX 4090 Gaming Trio 24GB · ¥12,899</sub> | <img src="assets/images/products/gigabyte-5090-aorus.png" width="105"><br><sub>Gigabyte RTX 5090 Aorus Master 32GB · ¥17,999</sub> | <img src="assets/images/products/inno3d-rtx-5090.png" width="105"><br><sub>Inno3D GeForce RTX 5090 X3 32GB · ¥14,899</sub> |
|---|---|---|---|---|---|---|

### 🎮 Gaming Gear
| <img src="assets/images/products/ps5-slim.png" width="105"><br><sub>PlayStation 5 Slim Digital Edition · ¥2,999</sub> | <img src="assets/images/products/stern-pinball.png" width="105"><br><sub>Stern Metallica Pro Pinball Machine · ¥49,999</sub> | <img src="assets/images/products/airhockey-kids.png" width="105"><br><sub>Air Kids Air Hockey Table · ¥8,999</sub> | <img src="assets/images/products/airhockey-pro.png" width="105"><br><sub>Pro Coin-Operated Air Hockey Table · ¥13,999</sub> | <img src="assets/images/products/fanatec-gt-extreme.png" width="105"><br><sub>Fanatec Gran Turismo DD Extreme Kit · ¥11,999</sub> | <img src="assets/images/products/fanatec-f1-kit.png" width="105"><br><sub>Fanatec ClubSport Racing Wheel F1 Kit · ¥10,999</sub> | <img src="assets/images/products/simagic-alpha-pro.png" width="105"><br><sub>Simagic Alpha Pro Wheelbase Combo · ¥9,899</sub> | <img src="assets/images/products/darth-vader-statue.png" width="105"><br><sub>Darth Vader Mythos 1/4 Statue · ¥10,499</sub> | <img src="assets/images/products/fanatec-dd-plus.png" width="105"><br><sub>Fanatec ClubSport DD+ Base Kit · ¥9,499</sub> |
|---|---|---|---|---|---|---|---|---|

### 💻 Gaming PCs
| <img src="assets/images/products/pulse-bluepc.png" width="105"><br><sub>Pulse BluePC Gaming PC (i9-14900KF) · ¥13,999</sub> | <img src="assets/images/products/aura-workstation.png" width="105"><br><sub>AURA by BluePC Workstation · ¥17,499</sub> |
|---|---|

### 💄 Beauty & Skincare
| <img src="assets/images/products/centella-cream.png" width="105"><br><sub>Centella Soothing Cream 50ml · ¥159</sub> | <img src="assets/images/products/roundlab-toner.png" width="105"><br><sub>Round Lab 1025 Dokdo Toner 190ml · ¥169</sub> | <img src="assets/images/products/somebymi-foam.png" width="105"><br><sub>Some By Mi 30-Day Miracle Acne Foam · ¥149</sub> | <img src="assets/images/products/mask-set-6.png" width="105"><br><sub>Korean Sheet Mask Set (6 pcs) · ¥89</sub> | <img src="assets/images/products/collagen-mask.png" width="105"><br><sub>Collagen Sheet Mask (6 pcs) · ¥79</sub> | <img src="assets/images/products/joseon-sunscreen.png" width="105"><br><sub>Beauty of Joseon Sunscreen · ¥129</sub> | <img src="assets/images/products/sleep-lip-mask.png" width="105"><br><sub>Overnight Lip Mask 20g · ¥99</sub> | <img src="assets/images/products/medicube-mask.png" width="105"><br><sub>Medicube PDRN Pink Mask 28g · ¥139</sub> | <img src="assets/images/products/laneige-lipmask.png" width="105"><br><sub>Laneige Lip Sleeping Mask (Berry) 20g · ¥169</sub> | <img src="assets/images/products/roundlab-exfoliant.png" width="105"><br><sub>Dokdo 1025 Exfoliating Toner 100ml · ¥179</sub> |
|---|---|---|---|---|---|---|---|---|---|

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

## 📥 Download & Install (no dev environment needed)

- 📱 **Android**: grab the latest `app-release.apk` from the [Releases page](https://github.com/Toby-TB/impulsive-consumption/releases), copy it to your phone and install (allow "unknown sources")
- 🌐 **Web/PC**: just open https://toby-tb.github.io/impulsive-consumption/ (no install needed)

## 🚀 Quick Start (developers)

| Platform | Command | Output |
|---|---|---|
| 📱 Android | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| 🌐 Web (recommended for Windows testing) | `flutter build web --release --base-href /` then double-click `start_web.bat` | Serve locally in your browser — no domain needed |
| 🪟 Windows native | `flutter build windows --release` | Requires Windows + Visual Studio toolchain |
| 🍎 macOS / iOS | `flutter build macos --release` / `flutter build ios --release` | Requires macOS + Xcode |
| 🔧 Dev | `flutter run -d chrome` | Hot reload |

> 🌍 **Live demo (GitHub Pages)**: https://toby-tb.github.io/impulsive-consumption/ —— auto-built & deployed on every push to main

```bash
flutter analyze   # 0 issues
flutter test      # 18 unit tests green (currency/coupons/logistics/catalog)
```

## 🎨 Make It Yours

- **Your own product photos**: overwrite `assets/images/products/<product-id>.png` with same-name files (square, 600×600+ recommended)
- **Re-fetch real product images**: edit `tool/fetch_real.sh` and run it (images come from public product pages, for learning/demo only — do not use commercially)
- **Regenerate banner & app icon**: `bash tool/gen_images.sh` (requires Chrome), then `dart run flutter_launcher_icons`

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

- **Image credits**: product images come from public product pages such as dopamineshopping.com, for learning/demo purposes only — replace them with your own images for commercial use.
- **Web version shows a blank page?** Flutter Web must be served over http (opening `file://` won't work) — use `start_web.bat` or any static server.
- **APK install warning?** An unsigned test build triggers a normal warning; configure signing before publishing to stores.
- **How to plug in a real backend?** All data access lives in `lib/data/db/database.dart` and `lib/state/providers.dart` — swap them for API calls; the UI stays untouched.
- **Demo state messed up?** Me → Settings → Reset demo data, back to a fresh ¥10,000 start.

## 📜 License

[MIT](LICENSE) © 2026 Impulsive Consumption contributors

---

<p align="center">🛍️ This app is a pure simulation: no real payments, no network requests 🛍️</p>
