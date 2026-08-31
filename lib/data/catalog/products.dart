import '../../core/coupon_logic.dart';

/// 三语文本（商品名/描述/分类名等数据文案）。
class LocalizedText {
  const LocalizedText({required this.zh, required this.zhHant, required this.en});
  final String zh;
  final String zhHant;
  final String en;

  String resolve(String localeCode) {
    if (localeCode == 'en') return en;
    if (localeCode == 'zhHant') return zhHant;
    return zh;
  }
}

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.priceCents,
    required this.stock,
    required this.monthlySales,
    required this.rating,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  final String id;
  final String categoryId;
  final int priceCents; // CNY 分（基准）
  final int stock; // 初始库存
  final int monthlySales; // 模拟月销量（取自真实站点评价数）
  final double rating; // 模拟评分
  final LocalizedText name;
  final LocalizedText description;
  final String imagePath;
}

class Category {
  const Category(this.id, this.emoji, this.name);
  final String id;
  final String emoji;
  final LocalizedText name;
}

const List<Category> categories = [
  Category('gpu', '🖥️', LocalizedText(zh: '显卡', zhHant: '顯示卡', en: 'Graphics Cards')),
  Category('gaming', '🎮', LocalizedText(zh: '游戏装备', zhHant: '遊戲裝備', en: 'Gaming Gear')),
  Category('pc', '💻', LocalizedText(zh: '整机电脑', zhHant: '整機電腦', en: 'Gaming PCs')),
  Category('beauty', '💄', LocalizedText(zh: '美妆护肤', zhHant: '美妝護膚', en: 'Beauty & Skincare')),
  Category('digital', '📱', LocalizedText(zh: '手机数码', zhHant: '手機數碼', en: 'Phones & Digital')),
  Category('appliance', '🏠', LocalizedText(zh: '家用电器', zhHant: '家用電器', en: 'Home Appliances')),
  Category('home', '🛋️', LocalizedText(zh: '家居', zhHant: '家居', en: 'Home & Living')),
  Category('fashion', '👕', LocalizedText(zh: '服饰', zhHant: '服飾', en: 'Fashion')),
  Category('food', '🍜', LocalizedText(zh: '食品', zhHant: '食品', en: 'Food & Drink')),
  Category('sport', '🏃', LocalizedText(zh: '运动户外', zhHant: '運動戶外', en: 'Sports & Outdoors')),
];

/// 28 件真实商品（图片来自真实商品页面，仅用于学习演示）。
const List<Product> products = [
  // 显卡
  Product(id: 'nvidia-rtx-4090', categoryId: 'gpu', priceCents: 1299900, stock: 12, monthlySales: 63761, rating: 4.9,
    name: LocalizedText(zh: 'NVIDIA GeForce RTX 4090 24GB 显卡', zhHant: '輝達 GeForce RTX 4090 24GB 顯示卡', en: 'NVIDIA GeForce RTX 4090 24GB'),
    description: LocalizedText(zh: 'Ada Lovelace 架构旗舰，4K 光追毫无压力，跑分与画质双巅峰。', zhHant: 'Ada Lovelace 架構旗艦，4K 光追毫無壓力，跑分與畫質雙巔峰。', en: 'Ada Lovelace flagship — effortless 4K ray tracing at peak performance.'),
    imagePath: 'assets/images/products/nvidia-rtx-4090.png'),
  Product(id: 'gigabyte-rtx-5090', categoryId: 'gpu', priceCents: 1649900, stock: 10, monthlySales: 69892, rating: 4.9,
    name: LocalizedText(zh: '技嘉 GeForce RTX 5090 Windforce OC 32GB', zhHant: '技嘉 GeForce RTX 5090 Windforce OC 32GB', en: 'Gigabyte GeForce RTX 5090 Windforce OC 32GB'),
    description: LocalizedText(zh: '风之力三风扇散热，32GB GDDR7 显存，次世代游戏全能王。', zhHant: '風之力三風扇散熱，32GB GDDR7 顯存，次世代遊戲全能王。', en: 'WINDFORCE triple-fan cooling with 32GB GDDR7 for next-gen gaming.'),
    imagePath: 'assets/images/products/gigabyte-rtx-5090.png'),
  Product(id: 'asus-rog-strix-4090', categoryId: 'gpu', priceCents: 1349900, stock: 8, monthlySales: 55479, rating: 4.9,
    name: LocalizedText(zh: '华硕 ROG Strix GeForce RTX 4090 24GB', zhHant: '華碩 ROG Strix GeForce RTX 4090 24GB', en: 'ASUS ROG Strix GeForce RTX 4090 24GB'),
    description: LocalizedText(zh: '败家之眼信仰加持，越级供电与散热，超频玩家的梦中情卡。', zhHant: '敗家之眼信仰加持，越級供電與散熱，超頻玩家的夢中情卡。', en: 'ROG heritage with overbuilt power delivery — the overclocker\u2019s dream card.'),
    imagePath: 'assets/images/products/asus-rog-strix-4090.png'),
  Product(id: 'zotac-rtx-5090', categoryId: 'gpu', priceCents: 1599900, stock: 10, monthlySales: 24200, rating: 4.9,
    name: LocalizedText(zh: '索泰 GeForce RTX 5090 Solid OC 32GB', zhHant: '索泰 GeForce RTX 5090 Solid OC 32GB', en: 'Zotac GeForce RTX 5090 Solid OC 32GB'),
    description: LocalizedText(zh: 'IceStorm 3.0 散热系统，出厂超频，安静且凶猛。', zhHant: 'IceStorm 3.0 散熱系統，出廠超頻，安靜且兇猛。', en: 'IceStorm 3.0 cooling with factory overclock — quiet and fierce.'),
    imagePath: 'assets/images/products/zotac-rtx-5090.png'),
  Product(id: 'msi-gaming-trio-4090', categoryId: 'gpu', priceCents: 1289900, stock: 12, monthlySales: 37608, rating: 4.9,
    name: LocalizedText(zh: '微星 GeForce RTX 4090 Gaming Trio 24GB', zhHant: '微星 GeForce RTX 4090 Gaming Trio 24GB', en: 'MSI GeForce RTX 4090 Gaming Trio 24GB'),
    description: LocalizedText(zh: 'TRI FROZR 3 三风扇设计，龙魂灯效，性能与颜值兼得。', zhHant: 'TRI FROZR 3 三風扇設計，龍魂燈效，性能與顏值兼得。', en: 'TRI FROZR 3 triple-fan design with dragon RGB — power meets style.'),
    imagePath: 'assets/images/products/msi-gaming-trio-4090.png'),
  Product(id: 'gigabyte-5090-aorus', categoryId: 'gpu', priceCents: 1799900, stock: 6, monthlySales: 85314, rating: 4.9,
    name: LocalizedText(zh: '技嘉 RTX 5090 Aorus Master 32GB', zhHant: '技嘉 RTX 5090 Aorus Master 32GB', en: 'Gigabyte RTX 5090 Aorus Master 32GB'),
    description: LocalizedText(zh: 'AORUS 旗舰风冷，LCD 边屏 + RGB，顶级做工的代表作。', zhHant: 'AORUS 旗艦風冷，LCD 邊屏 + RGB，頂級做工的代表作。', en: 'AORUS flagship air-cooled card with LCD edge screen and RGB.'),
    imagePath: 'assets/images/products/gigabyte-5090-aorus.png'),
  Product(id: 'inno3d-rtx-5090', categoryId: 'gpu', priceCents: 1489900, stock: 10, monthlySales: 51981, rating: 4.9,
    name: LocalizedText(zh: '映众 GeForce RTX 5090 X3 32GB', zhHant: '映眾 GeForce RTX 5090 X3 32GB', en: 'Inno3D GeForce RTX 5090 X3 32GB'),
    description: LocalizedText(zh: '三风扇紧凑设计，机箱兼容性好，性价比之选。', zhHant: '三風扇緊湊設計，機箱相容性好，性價比之選。', en: 'Compact triple-fan design with great case compatibility.'),
    imagePath: 'assets/images/products/inno3d-rtx-5090.png'),
  // 游戏装备
  Product(id: 'ps5-slim', categoryId: 'gaming', priceCents: 299900, stock: 30, monthlySales: 32000, rating: 4.9,
    name: LocalizedText(zh: 'PlayStation 5 Slim 数字版', zhHant: 'PlayStation® 5 Slim 數位版', en: 'PlayStation 5 Slim Digital Edition'),
    description: LocalizedText(zh: '次世代主机，825GB 高速 SSD，独占大作一网打尽。', zhHant: '次世代主機，825GB 高速 SSD，獨佔大作一網打盡。', en: 'Next-gen console with a blazing 825GB SSD and exclusive hits.'),
    imagePath: 'assets/images/products/ps5-slim.png'),
  Product(id: 'stern-pinball', categoryId: 'gaming', priceCents: 4999900, stock: 3, monthlySales: 81784, rating: 4.9,
    name: LocalizedText(zh: 'Stern Metallica Pro 弹珠台', zhHant: 'Stern 彈珠台 – Metallica Pro', en: 'Stern Metallica Pro Pinball Machine'),
    description: LocalizedText(zh: '重金属主题弹珠台，Metallica 经典曲目随球响起。', zhHant: '重金屬主題彈珠台，Metallica 經典曲目隨球響起。', en: 'Heavy-metal themed pinball with classic Metallica tracks.'),
    imagePath: 'assets/images/products/stern-pinball.png'),
  Product(id: 'airhockey-kids', categoryId: 'gaming', priceCents: 899900, stock: 8, monthlySales: 35853, rating: 4.8,
    name: LocalizedText(zh: 'Air Kids 专业气垫球桌', zhHant: 'Air Kids 專業氣墊球桌', en: 'Air Kids Air Hockey Table'),
    description: LocalizedText(zh: '自动出球 + 计分器，客厅秒变游乐场。', zhHant: '自動出球 + 計分器，客廳秒變遊樂場。', en: 'Auto puck feeder with scoreboard — turn your living room into an arcade.'),
    imagePath: 'assets/images/products/airhockey-kids.png'),
  Product(id: 'airhockey-pro', categoryId: 'gaming', priceCents: 1399900, stock: 5, monthlySales: 61491, rating: 4.9,
    name: LocalizedText(zh: '专业投币式气垫球桌', zhHant: '專業投幣式氣墊球桌', en: 'Pro Coin-Operated Air Hockey Table'),
    description: LocalizedText(zh: '商用级做工 + 投币系统，开个小球厅不是梦。', zhHant: '商用級做工 + 投幣系統，開個小球廳不是夢。', en: 'Commercial-grade build with coin system — your own mini arcade.'),
    imagePath: 'assets/images/products/airhockey-pro.png'),
  Product(id: 'fanatec-gt-extreme', categoryId: 'gaming', priceCents: 1199900, stock: 8, monthlySales: 75785, rating: 4.8,
    name: LocalizedText(zh: 'Fanatec Gran Turismo DD Extreme 方向盘套装', zhHant: 'Fanatec Gran Turismo DD Extreme 方向盤套裝', en: 'Fanatec Gran Turismo DD Extreme Wheel + Pedals'),
    description: LocalizedText(zh: '15Nm 直驱力反馈 + V3 踏板，把 GT 赛场搬回家。', zhHant: '15Nm 直驅力回饋 + V3 踏板，把 GT 賽場搬回家。', en: '15Nm direct drive with V3 pedals — bring the GT track home.'),
    imagePath: 'assets/images/products/fanatec-gt-extreme.png'),
  Product(id: 'fanatec-f1-kit', categoryId: 'gaming', priceCents: 1099900, stock: 8, monthlySales: 37183, rating: 4.9,
    name: LocalizedText(zh: 'Fanatec ClubSport Racing Wheel F1 套装', zhHant: 'Fanatec ClubSport Racing Wheel F1 套裝', en: 'Fanatec ClubSport Racing Wheel F1 Kit'),
    description: LocalizedText(zh: '18Nm 基座 + F1 方向盘 + 倒置踏板，模拟赛车终极方案。', zhHant: '18Nm 基座 + F1 方向盤 + 倒置踏板，模擬賽車終極方案。', en: '18Nm base, F1 wheel and inverted pedals — the ultimate sim-racing rig.'),
    imagePath: 'assets/images/products/fanatec-f1-kit.png'),
  Product(id: 'simagic-alpha-pro', categoryId: 'gaming', priceCents: 989900, stock: 10, monthlySales: 21390, rating: 4.8,
    name: LocalizedText(zh: 'Simagic Alpha Pro 方向盘基座套装', zhHant: 'Simagic Alpha Pro 方向盤基座套裝', en: 'Simagic Alpha Pro Wheelbase Combo'),
    description: LocalizedText(zh: '国产直驱新势力，细腻力反馈，性价比拉满。', zhHant: '國產直驅新勢力，細膩力回饋，性價比拉滿。', en: 'Rising direct-drive star with detailed force feedback and great value.'),
    imagePath: 'assets/images/products/simagic-alpha-pro.png'),
  Product(id: 'darth-vader-statue', categoryId: 'gaming', priceCents: 1049900, stock: 4, monthlySales: 34933, rating: 4.8,
    name: LocalizedText(zh: '达斯·维达 Mythos 1/4 雕像', zhHant: '達斯·維達 Mythos 1/4 雕像', en: 'Darth Vader Mythos 1/4 Scale Statue'),
    description: LocalizedText(zh: 'Sideshow 限定版，黑武士气场全开，收藏柜的镇柜之宝。', zhHant: 'Sideshow 限定版，黑武士氣場全開，收藏櫃的鎮櫃之寶。', en: 'Limited Sideshow piece — the centerpiece of any collection.'),
    imagePath: 'assets/images/products/darth-vader-statue.png'),
  Product(id: 'fanatec-dd-plus', categoryId: 'gaming', priceCents: 949900, stock: 9, monthlySales: 67890, rating: 4.9,
    name: LocalizedText(zh: 'Fanatec ClubSport DD+ 基座套装', zhHant: 'Fanatec ClubSport DD+ 基座套裝', en: 'Fanatec ClubSport DD+ Base Kit'),
    description: LocalizedText(zh: 'PlayStation 官方授权直驱基座，跨平台即插即玩。', zhHant: 'PlayStation 官方授權直驅基座，跨平台即插即玩。', en: 'Officially licensed direct-drive base — plug and play across platforms.'),
    imagePath: 'assets/images/products/fanatec-dd-plus.png'),
  // 整机电脑
  Product(id: 'pulse-bluepc', categoryId: 'pc', priceCents: 1399900, stock: 6, monthlySales: 30586, rating: 4.9,
    name: LocalizedText(zh: 'Pulse BluePC 游戏主机 i9-14900KF + RTX 5070 Ti', zhHant: 'Pulse BluePC 遊戲主機 i9-14900KF + RTX 5070 Ti', en: 'Pulse BluePC Gaming PC (i9-14900KF, RTX 5070 Ti)'),
    description: LocalizedText(zh: '32GB 内存 + 1TB SSD，2K 高刷畅玩主流大作。', zhHant: '32GB 記憶體 + 1TB SSD，2K 高刷暢玩主流大作。', en: '32GB RAM and 1TB SSD for smooth 1440p high-refresh gaming.'),
    imagePath: 'assets/images/products/pulse-bluepc.png'),
  Product(id: 'aura-workstation', categoryId: 'pc', priceCents: 1749900, stock: 5, monthlySales: 86363, rating: 4.9,
    name: LocalizedText(zh: 'AURA by BluePC 游戏工作站 i9-14900KF', zhHant: 'AURA by BluePC 遊戲工作站 i9-14900KF', en: 'AURA by BluePC Workstation (i9-14900KF)'),
    description: LocalizedText(zh: 'RGB 光污染拉满的创作工作站，剪片渲染两不误。', zhHant: 'RGB 光污染拉滿的創作工作站，剪片渲染兩不誤。', en: 'RGB-loaded creator workstation for editing and rendering.'),
    imagePath: 'assets/images/products/aura-workstation.png'),
  // 美妆护肤
  Product(id: 'centella-cream', categoryId: 'beauty', priceCents: 15900, stock: 120, monthlySales: 79114, rating: 4.9,
    name: LocalizedText(zh: '积雪草保湿面霜 50ml', zhHant: '積雪草保濕面霜 50ml', en: 'Centella Soothing Cream 50ml'),
    description: LocalizedText(zh: '积雪草精粹舒缓修护，敏感肌的安心之选。', zhHant: '積雪草精粹舒緩修護，敏感肌的安心之選。', en: 'Centella extract soothes and repairs — a safe pick for sensitive skin.'),
    imagePath: 'assets/images/products/centella-cream.png'),
  Product(id: 'roundlab-toner', categoryId: 'beauty', priceCents: 16900, stock: 150, monthlySales: 29241, rating: 4.8,
    name: LocalizedText(zh: 'Round Lab 1025 Dokdo 化妆水 190ml', zhHant: 'Round Lab 1025 Dokdo 化妝水 190ml', en: 'Round Lab 1025 Dokdo Toner 190ml'),
    description: LocalizedText(zh: '独岛深层水 + 泛醇配方，清爽补水不黏腻。', zhHant: '獨島深層水 + 泛醇配方，清爽補水不黏膩。', en: 'Dokdo deep-sea water with panthenol — light, non-sticky hydration.'),
    imagePath: 'assets/images/products/roundlab-toner.png'),
  Product(id: 'somebymi-foam', categoryId: 'beauty', priceCents: 14900, stock: 180, monthlySales: 67777, rating: 4.8,
    name: LocalizedText(zh: 'Some By Mi 30 天奇迹祛痘洁面', zhHant: 'Some By Mi 30 天奇蹟祛痘潔面', en: 'Some By Mi 30-Day Miracle Acne Foam'),
    description: LocalizedText(zh: 'AHA/BHA/PHA 三重酸温和洁面，痘肌救星。', zhHant: 'AHA/BHA/PHA 三重酸溫和潔面，痘肌救星。', en: 'Gentle AHA/BHA/PHA foam — the acne-prone skin lifesaver.'),
    imagePath: 'assets/images/products/somebymi-foam.png'),
  Product(id: 'mask-set-6', categoryId: 'beauty', priceCents: 8900, stock: 200, monthlySales: 12651, rating: 4.8,
    name: LocalizedText(zh: '韩系面膜套装 6 片', zhHant: '韓系面膜套裝 6 片', en: 'Korean Sheet Mask Set (6 pcs)'),
    description: LocalizedText(zh: '六种功效轮番上阵，一周面膜计划轻松搞定。', zhHant: '六種功效輪番上陣，一週面膜計劃輕鬆搞定。', en: 'Six treatments in one box — your weekly masking plan sorted.'),
    imagePath: 'assets/images/products/mask-set-6.png'),
  Product(id: 'collagen-mask', categoryId: 'beauty', priceCents: 7900, stock: 200, monthlySales: 12567, rating: 4.9,
    name: LocalizedText(zh: '胶原蛋白面膜 6 片装', zhHant: '膠原蛋白面膜 6 片裝', en: 'Collagen Sheet Mask (6 pcs)'),
    description: LocalizedText(zh: '水解胶原密集修护，敷出水光肌。', zhHant: '水解膠原密集修護，敷出水光肌。', en: 'Hydrolyzed collagen for intense repair and a glass-skin glow.'),
    imagePath: 'assets/images/products/collagen-mask.png'),
  Product(id: 'joseon-sunscreen', categoryId: 'beauty', priceCents: 12900, stock: 160, monthlySales: 7472, rating: 4.8,
    name: LocalizedText(zh: 'Beauty of Joseon 米水防晒精华', zhHant: 'Beauty of Joseon 米水防曬精華', en: 'Beauty of Joseon Rice + Probiotics Sunscreen'),
    description: LocalizedText(zh: 'SPF50+ 米糠益生菌配方，防晒养肤一步到位。', zhHant: 'SPF50+ 米糠益生菌配方，防曬養膚一步到位。', en: 'SPF50+ rice-probiotic formula — protection and care in one step.'),
    imagePath: 'assets/images/products/joseon-sunscreen.png'),
  Product(id: 'sleep-lip-mask', categoryId: 'beauty', priceCents: 9900, stock: 170, monthlySales: 72757, rating: 4.9,
    name: LocalizedText(zh: '睡眠唇膜 20g', zhHant: '睡眠唇膜 20g', en: 'Overnight Lip Mask 20g'),
    description: LocalizedText(zh: '夜间厚涂，晨起唇部水嫩饱满。', zhHant: '夜間厚塗，晨起唇部水嫩飽滿。', en: 'Apply overnight, wake up to soft, plump lips.'),
    imagePath: 'assets/images/products/sleep-lip-mask.png'),
  Product(id: 'medicube-mask', categoryId: 'beauty', priceCents: 13900, stock: 90, monthlySales: 1894, rating: 4.9,
    name: LocalizedText(zh: 'Medicube PDRN 粉色面膜 28g', zhHant: 'Medicube PDRN 粉色面膜 28g', en: 'Medicube PDRN Pink Mask 28g'),
    description: LocalizedText(zh: 'PDRN 修护因子，熬夜脸的急救面膜。', zhHant: 'PDRN 修護因子，熬夜臉的急救面膜。', en: 'PDRN repair complex — first aid for late-night skin.'),
    imagePath: 'assets/images/products/medicube-mask.png'),
  Product(id: 'laneige-lipmask', categoryId: 'beauty', priceCents: 16900, stock: 140, monthlySales: 12196, rating: 4.8,
    name: LocalizedText(zh: '兰芝唇膜（浆果味）20g', zhHant: 'Laneige 唇膜（漿果味）20g', en: 'Laneige Lip Sleeping Mask (Berry) 20g'),
    description: LocalizedText(zh: '经典浆果唇膜，一夜修护干裂起皮。', zhHant: '經典漿果唇膜，一夜修護乾裂起皮。', en: 'The classic berry lip mask — overnight repair for dry lips.'),
    imagePath: 'assets/images/products/laneige-lipmask.png'),
  Product(id: 'roundlab-exfoliant', categoryId: 'beauty', priceCents: 17900, stock: 100, monthlySales: 50582, rating: 4.8,
    name: LocalizedText(zh: 'Dokdo 1025 去角质化妆水 100ml', zhHant: 'Dokdo 1025 去角質化妝水 100ml', en: 'Dokdo 1025 Exfoliating Toner 100ml'),
    description: LocalizedText(zh: '温和代谢老废角质，日夜可用不刺激。', zhHant: '溫和代謝老廢角質，日夜可用不刺激。', en: 'Gently renews dead skin cells — safe for day and night use.'),
    imagePath: 'assets/images/products/roundlab-exfoliant.png'),
  Product(id: 'iphone-15-pro', categoryId: 'digital', priceCents: 799900, stock: 40, monthlySales: 18000, rating: 4.9,
    name: LocalizedText(zh: 'Apple iPhone 15 Pro', zhHant: 'Apple iPhone 15 Pro', en: 'Apple iPhone 15 Pro'),
    description: LocalizedText(zh: '钛金属机身，潜望长焦，影像旗舰。', zhHant: '鈦金屬機身，潛望長焦，影像旗艦。', en: 'Titanium body with a periscope telephoto — a camera flagship.'),
    imagePath: 'assets/images/products/iphone-15-pro.png'),
  Product(id: 'samsung-galaxy-s24', categoryId: 'digital', priceCents: 549900, stock: 60, monthlySales: 26000, rating: 4.8,
    name: LocalizedText(zh: '三星 Galaxy S24', zhHant: '三星 Galaxy S24', en: 'Samsung Galaxy S24'),
    description: LocalizedText(zh: 'AI 手机新标杆，轻巧机身，旗舰性能。', zhHant: 'AI 手機新標竿，輕巧機身，旗艦效能。', en: 'The AI-first flagship with a light body and flagship power.'),
    imagePath: 'assets/images/products/samsung-galaxy-s24.png'),
  Product(id: 'macbook-air', categoryId: 'digital', priceCents: 859900, stock: 35, monthlySales: 12000, rating: 4.9,
    name: LocalizedText(zh: 'MacBook Air M3', zhHant: 'MacBook Air M3', en: 'MacBook Air M3'),
    description: LocalizedText(zh: 'M3 芯片，超轻薄，续航 18 小时。', zhHant: 'M3 晶片，超輕薄，續航 18 小時。', en: 'M3 chip, featherlight, with 18-hour battery life.'),
    imagePath: 'assets/images/products/macbook-air.png'),
  Product(id: 'airpods-pro', categoryId: 'digital', priceCents: 189900, stock: 90, monthlySales: 52000, rating: 4.8,
    name: LocalizedText(zh: 'AirPods Pro 2', zhHant: 'AirPods Pro 2', en: 'AirPods Pro 2'),
    description: LocalizedText(zh: '自适应降噪，通透模式，苹果生态无缝切换。', zhHant: '自適應降噪，通透模式，蘋果生態無縫切換。', en: 'Adaptive ANC, transparency mode, seamless in the Apple ecosystem.'),
    imagePath: 'assets/images/products/airpods-pro.png'),
  Product(id: 'ipad-air', categoryId: 'digital', priceCents: 479900, stock: 50, monthlySales: 21000, rating: 4.9,
    name: LocalizedText(zh: 'iPad Air', zhHant: 'iPad Air', en: 'iPad Air'),
    description: LocalizedText(zh: '11 英寸全面屏，M1 芯片，生产力与追剧兼得。', zhHant: '11 吋全螢幕，M1 晶片，生產力與追劇兼得。', en: '11-inch display with M1 chip — productivity and binge-watching.'),
    imagePath: 'assets/images/products/ipad-air.png'),
  Product(id: 'kindle-paperwhite', categoryId: 'digital', priceCents: 99900, stock: 80, monthlySales: 28000, rating: 4.9,
    name: LocalizedText(zh: 'Kindle Paperwhite 电子书阅读器', zhHant: 'Kindle Paperwhite 電子書閱讀器', en: 'Amazon Kindle Paperwhite'),
    description: LocalizedText(zh: '300ppi 墨水屏，防水，夜间阅读不伤眼。', zhHant: '300ppi 墨水螢幕，防水，夜間閱讀不傷眼。', en: '300ppi e-ink, waterproof, and easy on the eyes at night.'),
    imagePath: 'assets/images/products/kindle-paperwhite.png'),
  Product(id: 'laser-printer', categoryId: 'digital', priceCents: 109900, stock: 30, monthlySales: 9000, rating: 4.6,
    name: LocalizedText(zh: '家用激光打印机', zhHant: '家用雷射印表機', en: 'Home Laser Printer'),
    description: LocalizedText(zh: '黑白激光打印，高速低耗材，家庭作业神器。', zhHant: '黑白雷射列印，高速低耗材，家庭作業神器。', en: 'Fast monochrome laser printing with low running costs.'),
    imagePath: 'assets/images/products/laser-printer.png'),
  Product(id: 'dyson-v12', categoryId: 'appliance', priceCents: 399900, stock: 45, monthlySales: 14000, rating: 4.8,
    name: LocalizedText(zh: '戴森 V12 无线吸尘器', zhHant: '戴森 V12 無線吸塵器', en: 'Dyson V12 Cordless Vacuum'),
    description: LocalizedText(zh: '激光探测灰尘，吸力强劲，轻量无线。', zhHant: '雷射偵測灰塵，吸力強勁，輕量無線。', en: 'Laser-detectable dust, powerful suction, cordless and light.'),
    imagePath: 'assets/images/products/dyson-v12.png'),
  Product(id: 'instant-pot', categoryId: 'appliance', priceCents: 89900, stock: 90, monthlySales: 36000, rating: 4.8,
    name: LocalizedText(zh: 'Instant Pot 电压力锅', zhHant: 'Instant Pot 電壓力鍋', en: 'Instant Pot Pressure Cooker'),
    description: LocalizedText(zh: '一锅多用，炖煮焖煲，解放厨房。', zhHant: '一鍋多用，燉煮燜煲，解放廚房。', en: 'One pot, many modes — steaming, slow-cooking, pressure-cooking.'),
    imagePath: 'assets/images/products/instant-pot.png'),
  Product(id: 'air-fryer', categoryId: 'appliance', priceCents: 59900, stock: 120, monthlySales: 48000, rating: 4.7,
    name: LocalizedText(zh: '空气炸锅', zhHant: '空氣炸鍋', en: 'Air Fryer'),
    description: LocalizedText(zh: '高温热风，少油酥脆，万物皆可炸。', zhHant: '高溫熱風，少油酥脆，萬物皆可炸。', en: 'Hot-air crispiness with far less oil.'),
    imagePath: 'assets/images/products/air-fryer.png'),
  Product(id: 'robot-vacuum', categoryId: 'appliance', priceCents: 219900, stock: 60, monthlySales: 25000, rating: 4.7,
    name: LocalizedText(zh: '扫地机器人', zhHant: '掃地機器人', en: 'Robot Vacuum Cleaner'),
    description: LocalizedText(zh: '激光导航，自动集尘，扫拖一体。', zhHant: '雷射導航，自動集塵，掃拖一體。', en: 'Laser navigation, auto-empty, and sweep-mop in one.'),
    imagePath: 'assets/images/products/robot-vacuum.png'),
  Product(id: 'espresso-machine', categoryId: 'appliance', priceCents: 149900, stock: 40, monthlySales: 12000, rating: 4.8,
    name: LocalizedText(zh: '意式半自动咖啡机', zhHant: '義式半自動咖啡機', en: 'Semi-Automatic Espresso Machine'),
    description: LocalizedText(zh: '20-bar 萃取，蒸汽奶泡，家里就是咖啡馆。', zhHant: '20-bar 萃取，蒸氣奶泡，家裡就是咖啡館。', en: '20-bar extraction and steam milk froth — a home café.'),
    imagePath: 'assets/images/products/espresso-machine.png'),
  Product(id: 'water-purifier', categoryId: 'appliance', priceCents: 99900, stock: 55, monthlySales: 18000, rating: 4.7,
    name: LocalizedText(zh: '家用净水器', zhHant: '家用淨水器', en: 'Home Water Purifier'),
    description: LocalizedText(zh: 'RO 反渗透，直饮鲜活，滤芯智能提醒。', zhHant: 'RO 逆滲透，直飲鮮活，濾芯智能提醒。', en: 'RO reverse-osmosis drinking water with smart filter alerts.'),
    imagePath: 'assets/images/products/water-purifier.png'),
  Product(id: 'electric-kettle', categoryId: 'appliance', priceCents: 19900, stock: 160, monthlySales: 60000, rating: 4.6,
    name: LocalizedText(zh: '智能电热水壶', zhHant: '智能電熱水壺', en: 'Smart Electric Kettle'),
    description: LocalizedText(zh: '304 不锈钢，恒温保温，一次烧开。', zhHant: '304 不鏽鋼，恆溫保溫，一次燒開。', en: '304 stainless steel, keep-warm, boils in a flash.'),
    imagePath: 'assets/images/products/electric-kettle.png'),
  Product(id: 'induction-cooker', categoryId: 'appliance', priceCents: 39900, stock: 130, monthlySales: 33000, rating: 4.7,
    name: LocalizedText(zh: '电磁炉', zhHant: '電磁爐', en: 'Induction Cooker'),
    description: LocalizedText(zh: '大火猛、小火稳，不挑锅，安全防干烧。', zhHant: '大火猛、小火穩，不挑鍋，安全防乾燒。', en: 'High and steady heat for any pan, with dry-boil protection.'),
    imagePath: 'assets/images/products/induction-cooker.png'),
  Product(id: 'ergo-chair', categoryId: 'home', priceCents: 99900, stock: 50, monthlySales: 15000, rating: 4.7,
    name: LocalizedText(zh: '人体工学办公椅', zhHant: '人體工學辦公椅', en: 'Ergonomic Office Chair'),
    description: LocalizedText(zh: '腰背支撑，网布透气，久坐不累。', zhHant: '腰背支撐，網布透氣，久坐不累。', en: 'Lumbar support and breathable mesh for long sessions.'),
    imagePath: 'assets/images/products/ergo-chair.png'),
  Product(id: 'standing-desk', categoryId: 'home', priceCents: 169900, stock: 40, monthlySales: 9000, rating: 4.8,
    name: LocalizedText(zh: '电动升降桌', zhHant: '電動升降桌', en: 'Electric Standing Desk'),
    description: LocalizedText(zh: '记忆高度，静音升降，坐站交替。', zhHant: '記憶高度，靜音升降，坐站交替。', en: 'Memory presets and quiet height adjustment.'),
    imagePath: 'assets/images/products/standing-desk.png'),
  Product(id: 'led-desk-lamp', categoryId: 'home', priceCents: 29900, stock: 150, monthlySales: 42000, rating: 4.7,
    name: LocalizedText(zh: 'LED 护眼台灯', zhHant: 'LED 護眼檯燈', en: 'LED Desk Lamp'),
    description: LocalizedText(zh: '无频闪，多档色温，智能感应。', zhHant: '無頻閃，多檔色溫，智慧感應。', en: 'Flicker-free, adjustable color temperature, auto sensing.'),
    imagePath: 'assets/images/products/led-desk-lamp.png'),
  Product(id: 'memory-mattress', categoryId: 'home', priceCents: 199900, stock: 35, monthlySales: 11000, rating: 4.8,
    name: LocalizedText(zh: '记忆棉床垫', zhHant: '記憶棉床墊', en: 'Memory Foam Mattress'),
    description: LocalizedText(zh: '慢回弹支撑，贴合身体曲线，翻身不打扰。', zhHant: '慢回彈支撐，貼合身體曲線，翻身不打擾。', en: 'Slow-rebound support that contours to your body.'),
    imagePath: 'assets/images/products/memory-mattress.png'),
  Product(id: 'bookshelf', categoryId: 'home', priceCents: 79900, stock: 45, monthlySales: 13000, rating: 4.6,
    name: LocalizedText(zh: '六格书柜', zhHant: '六格書櫃', en: '6-Cube Bookshelf'),
    description: LocalizedText(zh: '自由组合，耐晒承重，收纳有序。', zhHant: '自由組合，耐曬承重，收納有序。', en: 'Modular cubes with sturdy shelving for tidy storage.'),
    imagePath: 'assets/images/products/bookshelf.png'),
  Product(id: 'storage-box', categoryId: 'home', priceCents: 12900, stock: 200, monthlySales: 70000, rating: 4.6,
    name: LocalizedText(zh: '加厚收纳箱三件套', zhHant: '加厚收納箱三件套', en: 'Stackable Storage Boxes (3-Pack)'),
    description: LocalizedText(zh: '透明可视，可叠放，防潮防尘。', zhHant: '透明可視，可疊放，防潮防塵。', en: 'Clear, stackable, moisture- and dust-resistant.'),
    imagePath: 'assets/images/products/storage-box.png'),
  Product(id: 'nike-sneaker', categoryId: 'fashion', priceCents: 89900, stock: 100, monthlySales: 41000, rating: 4.8,
    name: LocalizedText(zh: 'Nike 缓震运动鞋', zhHant: 'Nike 緩震運動鞋', en: 'Nike Cushioned Running Shoes'),
    description: LocalizedText(zh: '缓震回弹，透气鞋面，跑步日常都合适。', zhHant: '緩震回彈，透氣鞋面，跑步日常都合適。', en: 'Cushioned bounce and breathable mesh for runs and everywhere.'),
    imagePath: 'assets/images/products/nike-sneaker.png'),
  Product(id: 'adidas-hoodie', categoryId: 'fashion', priceCents: 49900, stock: 120, monthlySales: 36000, rating: 4.6,
    name: LocalizedText(zh: 'Adidas 经典卫衣', zhHant: 'Adidas 經典衛衣', en: 'Adidas Classic Hoodie'),
    description: LocalizedText(zh: '加绒内里，落肩版型，秋冬百搭。', zhHant: '加絨內裡，落肩版型，秋冬百搭。', en: 'Fleece-lined, relaxed fit, an autumn staple.'),
    imagePath: 'assets/images/products/adidas-hoodie.png'),
  Product(id: 'levi-jeans', categoryId: 'fashion', priceCents: 69900, stock: 90, monthlySales: 28000, rating: 4.7,
    name: LocalizedText(zh: 'Levi\'s 501 牛仔裤', zhHant: 'Levi\'s 501 牛仔褲', en: 'Levi\'s 501 Jeans'),
    description: LocalizedText(zh: '经典直筒，耐磨水洗，穿出街头感。', zhHant: '經典直筒，耐磨水洗，穿出街頭感。', en: 'Timeless straight-leg denim with a lived-in wash.'),
    imagePath: 'assets/images/products/levi-jeans.png'),
  Product(id: 'canvas-tote', categoryId: 'fashion', priceCents: 12900, stock: 220, monthlySales: 52000, rating: 4.5,
    name: LocalizedText(zh: '帆布托特包', zhHant: '帆布托特包', en: 'Canvas Tote Bag'),
    description: LocalizedText(zh: '加厚帆布，大容量，通勤购物两用。', zhHant: '加厚帆布，大容量，通勤購物兩用。', en: 'Thick canvas, roomy, for commutes and errands.'),
    imagePath: 'assets/images/products/canvas-tote.png'),
  Product(id: 'espresso-beans', categoryId: 'food', priceCents: 11800, stock: 140, monthlySales: 38000, rating: 4.8,
    name: LocalizedText(zh: '意式浓缩咖啡豆', zhHant: '義式濃縮咖啡豆', en: 'Espresso Coffee Beans'),
    description: LocalizedText(zh: '中深烘焙，坚果可可香，油脂丰富。', zhHant: '中深烘焙，堅果可可香，油脂豐富。', en: 'Medium-dark roast with nutty cocoa notes and rich crema.'),
    imagePath: 'assets/images/products/espresso-beans.png'),
  Product(id: 'longjing-tea', categoryId: 'food', priceCents: 25800, stock: 70, monthlySales: 9000, rating: 4.9,
    name: LocalizedText(zh: '西湖龙井礼盒', zhHant: '西湖龍井禮盒', en: 'Longjing Green Tea Gift Box'),
    description: LocalizedText(zh: '明前采摘，豆香鲜爽，送礼体面。', zhHant: '明前採摘，豆香鮮爽，送禮體面。', en: 'Pre-Qingming harvest, fresh chestnut aroma — a fine gift.'),
    imagePath: 'assets/images/products/longjing-tea.png'),
  Product(id: 'dark-chocolate', categoryId: 'food', priceCents: 8800, stock: 200, monthlySales: 46000, rating: 4.7,
    name: LocalizedText(zh: '瑞士黑巧克力', zhHant: '瑞士黑巧克力', en: 'Swiss Dark Chocolate'),
    description: LocalizedText(zh: '72% 可可，微苦回甘，丝滑入口。', zhHant: '72% 可可，微苦回甘，絲滑入口。', en: '72% cocoa, bittersweet and silky.'),
    imagePath: 'assets/images/products/dark-chocolate.png'),
  Product(id: 'olive-oil', categoryId: 'food', priceCents: 16800, stock: 80, monthlySales: 17000, rating: 4.8,
    name: LocalizedText(zh: '特级初榨橄榄油', zhHant: '特級初榨橄欖油', en: 'Extra Virgin Olive Oil'),
    description: LocalizedText(zh: '冷榨酸度低，果香馥郁，拌沙拉煎炒皆宜。', zhHant: '冷榨酸度低，果香馥郁，拌沙拉煎炒皆宜。', en: 'Cold-pressed, low acidity, fruity — salad and sauté ready.'),
    imagePath: 'assets/images/products/olive-oil.png'),
  Product(id: 'yoga-mat', categoryId: 'sport', priceCents: 15900, stock: 180, monthlySales: 39000, rating: 4.7,
    name: LocalizedText(zh: '加厚防滑瑜伽垫', zhHant: '加厚防滑瑜珈墊', en: 'Non-Slip Yoga Mat'),
    description: LocalizedText(zh: '加厚回弹，防滑纹理，附绑带。', zhHant: '加厚回彈，防滑紋理，附綁帶。', en: 'Thick, non-slip with a carry strap.'),
    imagePath: 'assets/images/products/yoga-mat.png'),
  Product(id: 'dumbbell-set', categoryId: 'sport', priceCents: 59900, stock: 60, monthlySales: 14000, rating: 4.7,
    name: LocalizedText(zh: '可调节哑铃套装', zhHant: '可調節啞鈴套裝', en: 'Adjustable Dumbbell Set'),
    description: LocalizedText(zh: '15kg 级可调，一铃多用，家庭练肌。', zhHant: '15kg 級可調，一鈴多用，家庭練肌。', en: 'Up to 15kg adjustable — your home strength partner.'),
    imagePath: 'assets/images/products/dumbbell-set.png'),
  Product(id: 'thermos-bottle', categoryId: 'sport', priceCents: 15900, stock: 220, monthlySales: 48000, rating: 4.6,
    name: LocalizedText(zh: '316 不锈钢保温杯', zhHant: '316 不鏽鋼保溫杯', en: 'Insulated Stainless Bottle'),
    description: LocalizedText(zh: '12 小时保温保冷，一键弹盖，不漏水。', zhHant: '12 小時保溫保冷，一鍵彈蓋，不漏水。', en: '12-hour hot/cold retention with a one-tap lid.'),
    imagePath: 'assets/images/products/thermos-bottle.png'),
];

Product? productById(String id) {
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
}

/// 预设优惠券（新用户发放）。
class CouponPreset {
  const CouponPreset({
    required this.code,
    required this.title,
    required this.kind,
    required this.value,
    required this.thresholdCents,
  });

  final String code;
  final LocalizedText title;
  final CouponKind kind;
  final int value;
  final int thresholdCents;
}

const List<CouponPreset> couponPresets = [
  CouponPreset(code: 'WELCOME10', title: LocalizedText(zh: '新人立减券', zhHant: '新人立減券', en: 'Welcome Voucher'), kind: CouponKind.fixed, value: 1000, thresholdCents: 5000),
  CouponPreset(code: 'SAVE30', title: LocalizedText(zh: '满 200 减 30', zhHant: '滿 200 減 30', en: '¥30 off ¥200'), kind: CouponKind.fixed, value: 3000, thresholdCents: 20000),
  CouponPreset(code: 'SAVE80', title: LocalizedText(zh: '满 500 减 80', zhHant: '滿 500 減 80', en: '¥80 off ¥500'), kind: CouponKind.fixed, value: 8000, thresholdCents: 50000),
  CouponPreset(code: 'NINETY', title: LocalizedText(zh: '全场九折券', zhHant: '全場九折券', en: '10% Off Voucher'), kind: CouponKind.percent, value: 90, thresholdCents: 10000),
];

/// 初始余额：¥10,000 = 1,000,000 分
const int initialBalanceCents = 1000000;

/// 签到奖励：7 天循环递增（CNY 分）
const List<int> signinRewards = [500, 600, 700, 800, 900, 1000, 1200];
