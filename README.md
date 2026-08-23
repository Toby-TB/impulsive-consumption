# 🛍️ 冲动消费 · Impulsive Consumption

一个**纯本地、零网络、零真实支付**的跨平台模拟购物 App，轻游戏化 / 趣味模拟风格，
让你完整体验「逛 → 加购 → 优惠券 → 支付 → 订单 → 物流 → 签到 → 成就」的购物乐趣。

所有数据只保存在设备本地（SQLite），卸载即消失，放心“挥霍”。

## ✨ 功能一览

| 模块 | 说明 |
|---|---|
| 🏪 商品系统 | 28 件手绘插画商品、6 大分类、搜索、详情页、月销量/评分/库存拟真字段 |
| 👛 本地钱包 | 初始余额 ¥10,000，模拟充值，支付校验扣款，收支明细全记录 |
| 🛒 购物车 | 加购/改数量/勾选部分结算/清空，实时总价 |
| 💳 结算支付 | 优惠券（满减/折扣）、余额校验、约 30% 概率触发支付彩蛋（立减/返币）、支付成功动画（彩带+打勾）、下单原子事务 |
| 📦 订单中心 | 历史订单、详情、模拟物流时间线（支付后按真实时间推进）、一键再次购买 |
| 🚚 物流 | 两档速度：极速演示（约 3 分钟送达）/ 拟真（1–3 天），重启后状态不丢 |
| ✍️ 每日签到 | 连续 7 天循环递增奖励（¥5~¥12），断签重来 |
| 🏆 成就徽章 | 首单达成 / 剁手大师 / 七日之约 / 收藏家 / 挥金如土，徽章墙展示 |
| ❤️ 收藏夹 | 心愿单式收藏 |
| 🌗 主题 | 明/暗/跟随系统，暖橙奶油底游戏化风格 |
| 🌏 本地化 | 简体中文 / 繁體中文 / English 即时切换 |
| 💱 货币 | CNY ¥ / HKD HK$ / USD US$ 即时换算（模拟固定汇率） |
| 🔄 演示重置 | 设置页一键恢复初始状态（余额/库存/优惠券） |
| 📴 完全离线 | 无任何网络请求，商品图随应用打包 |

## 🛠 技术栈

- **Flutter** 最新稳定版（Dart 3）
- **drift (SQLite)** 本地存储（10 张表，关系模型 + 事务原子下单）
- **Riverpod** 状态管理（Provider / StreamProvider，数据库流驱动 UI）
- **flutter gen-l10n** 三语本地化（ARB）
- 商品图为**手绘扁平插画 SVG**（tool/assets_src/）光栅化而来，可复现、可替换

## 📁 目录结构

```
lib/
├── main.dart / app.dart          # 入口、启动引导、MaterialApp 装配
├── core/                         # 纯逻辑：money 汇率 / logistics 物流 / coupon 优惠 / theme 主题
├── data/
│   ├── catalog/products.dart     # 28 商品 + 6 分类 + 4 优惠券 + 签到奖励表
│   └── db/                       # drift 表与业务事务（种子/补货/下单/签到/成就/重置）
├── state/providers.dart          # Riverpod 状态层
├── features/                     # home 导航壳 / shop 商品 / cart 购物车结算 / orders 订单物流
│                                 # wallet 钱包充值 / signin 签到 / achievements 成就 / favorites / settings / profile
└── l10n/                         # app_zh.arb / app_zh_Hant.arb / app_en.arb
assets/images/products/           # 28 张商品图（600×600 PNG）
tool/                             # 插画源文件与生成脚本（可复现）
```

## 🚀 构建与运行

### Android（可直接安装 APK）
```bash
flutter build apk --debug        # 产物: build/app/outputs/flutter-apk/app-debug.apk
```
把 app-debug.apk 传到手机安装即可（需允许“安装未知来源应用”）。

### Windows —— 用 Web 版（无需域名，本地即开即用）
```bash
flutter build web --release --base-href /
# Windows: 双击 start_web.bat（自动起本地服务并打开浏览器）
# 或手动: python -m http.server 8080 --directory build\web  然后访问 http://localhost:8080
```

### Windows 原生 exe（需要 Windows 机器 + Visual Studio 工具链）
```bash
flutter build windows --release    # 产物: build/windows/x64/runner/Release/*.exe
```

### macOS / iOS（需要 macOS + Xcode，本机为 Linux 无法产出）
```bash
flutter build macos --release
flutter build ios --release        # 真机需在 Xcode 中配置签名
```

### 开发调试
```bash
flutter run -d chrome              # 浏览器热重载调试
flutter run -d <android-device>    # 手机调试
```

## 🧪 测试与质量

```bash
flutter analyze                    # 0 issue
flutter test                       # 18 个单测全绿（汇率/优惠券/物流/目录一致性）
```

## 🎨 商品图：替换真实图片 / 重新生成

- **替换成真实照片**：把同名图片覆盖到 assets/images/products/<商品id>.png（如 phone.png），
  建议 600×600 以上、方形。商品 id 见 lib/data/catalog/products.dart。
- **重新生成插画**：编辑 tool/assets_src/*.svg 后运行 bash tool/gen_images.sh
  （需要 Chrome，用 CHROME_EXECUTABLE 环境变量指定路径）。
- **应用图标**：改 tool/assets_src/app_icon.svg → bash tool/gen_images.sh → dart run flutter_launcher_icons。

## 🔧 模拟参数修改点（写死的模拟值）

| 参数 | 位置 |
|---|---|
| 汇率（CNY=1 / HKD=0.92 / USD=7.20） | lib/core/money.dart 的 Currency 枚举 |
| 初始余额 ¥10,000 | lib/data/catalog/products.dart 的 initialBalanceCents |
| 商品/价格/库存/月销/评分 | lib/data/catalog/products.dart 的 products 列表 |
| 优惠券（4 张新用户券） | 同文件 couponPresets |
| 签到奖励（7 天循环） | 同文件 signinRewards |
| 物流时长（极速/拟真两档） | lib/core/logistics.dart |
| 支付彩蛋概率与力度 | lib/data/db/database.dart 的 placeOrder |
| 成就门槛 | lib/core/achievements.dart + unlockAchievementsNow |

## ❓ 常见问题

- **Web 版打开白屏？** Flutter Web 需要 http 服务加载（file:// 打开不行），请用 start_web.bat 或任意静态服务器访问。
- **手机安装 APK 提示风险？** 这是未签名 debug 包，仅用于测试，属正常提示。
- **如何对接真实后端？** 数据层全部集中在 lib/data/db/database.dart 与 lib/state/providers.dart，
  把数据库方法替换为 API 调用即可，UI 无需改动。
- **演示后想恢复初始状态？** 我的 → 设置 → 重置演示数据。

*本应用为纯模拟演示：不涉及任何真实支付，也不会发起任何网络请求。*
