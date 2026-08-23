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
  final int monthlySales; // 模拟月销量
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
  Category('digital', '📱', LocalizedText(zh: '数码', zhHant: '數碼', en: 'Digital')),
  Category('fashion', '👕', LocalizedText(zh: '服饰', zhHant: '服飾', en: 'Fashion')),
  Category('food', '🍰', LocalizedText(zh: '食品', zhHant: '食品', en: 'Food')),
  Category('home', '🛋️', LocalizedText(zh: '家居', zhHant: '家居', en: 'Home')),
  Category('beauty', '💄', LocalizedText(zh: '美妆', zhHant: '美妝', en: 'Beauty')),
  Category('books', '📚', LocalizedText(zh: '图书', zhHant: '圖書', en: 'Books')),
];

const List<Product> products = [
  // 数码
  Product(id: 'phone', categoryId: 'digital', priceCents: 799900, stock: 25, monthlySales: 2100, rating: 4.9,
    name: LocalizedText(zh: '星辉 X1 智能手机', zhHant: '星輝 X1 智能手機', en: 'Starlight X1 Phone'),
    description: LocalizedText(zh: '6.8 英寸流光屏，一亿像素影像，陪你记录每一刻闪耀。', zhHant: '6.8 吋流光螢幕，一億像素影像，陪你記錄每一刻閃耀。', en: '6.8" glowing display with a 100MP camera to capture every shiny moment.'),
    imagePath: 'assets/images/products/phone.png'),
  Product(id: 'buds', categoryId: 'digital', priceCents: 129900, stock: 60, monthlySales: 8600, rating: 4.8,
    name: LocalizedText(zh: '静界 Pro 降噪耳机', zhHant: '靜界 Pro 降噪耳機', en: 'Silence Pro ANC Buds'),
    description: LocalizedText(zh: '一键开启深度降噪，喧嚣世界与你无关。', zhHant: '一鍵開啟深度降噪，喧囂世界與你無關。', en: 'One tap for deep ANC — tune the noisy world out.'),
    imagePath: 'assets/images/products/buds.png'),
  Product(id: 'watch', categoryId: 'digital', priceCents: 189900, stock: 40, monthlySales: 3200, rating: 4.7,
    name: LocalizedText(zh: '流光 S 智能手表', zhHant: '流光 S 智能手錶', en: 'Flow S Smart Watch'),
    description: LocalizedText(zh: '全天候健康监测，百种运动模式，腕上小管家。', zhHant: '全天候健康監測，百種運動模式，腕上小管家。', en: 'All-day health tracking and 100+ workout modes on your wrist.'),
    imagePath: 'assets/images/products/watch.png'),
  Product(id: 'laptop', categoryId: 'digital', priceCents: 659900, stock: 15, monthlySales: 950, rating: 4.9,
    name: LocalizedText(zh: '极速 Air 轻薄本', zhHant: '極速 Air 輕薄本', en: 'Swift Air Ultrabook'),
    description: LocalizedText(zh: '1.2kg 轻盈机身，18 小时续航，移动办公好伙伴。', zhHant: '1.2kg 輕盈機身，18 小時續航，行動辦公好夥伴。', en: '1.2kg featherweight body with 18h battery for work on the go.'),
    imagePath: 'assets/images/products/laptop.png'),
  Product(id: 'camera', categoryId: 'digital', priceCents: 459900, stock: 12, monthlySales: 680, rating: 4.8,
    name: LocalizedText(zh: '定格 M2 微单相机', zhHant: '定格 M2 微單相機', en: 'Frame M2 Mirrorless'),
    description: LocalizedText(zh: '全画幅传感器，4K 60fps，大片随手拍。', zhHant: '全片幅感光元件，4K 60fps，大片隨手拍。', en: 'Full-frame sensor with 4K 60fps video — shoot like a pro.'),
    imagePath: 'assets/images/products/camera.png'),
  Product(id: 'tablet', categoryId: 'digital', priceCents: 249900, stock: 20, monthlySales: 1500, rating: 4.7,
    name: LocalizedText(zh: '幻彩 Nova 平板', zhHant: '幻彩 Nova 平板', en: 'Nova Tablet'),
    description: LocalizedText(zh: '11 英寸高刷屏，四扬声器，追剧学习两不误。', zhHant: '11 吋高刷螢幕，四揚聲器，追劇學習兩不誤。', en: '11" 120Hz display with quad speakers for shows and study.'),
    imagePath: 'assets/images/products/tablet.png'),
  Product(id: 'sunglasses', categoryId: 'digital', priceCents: 19900, stock: 80, monthlySales: 5200, rating: 4.6,
    name: LocalizedText(zh: '夏日炫光墨镜', zhHant: '夏日炫光墨鏡', en: 'Summer Glare Shades'),
    description: LocalizedText(zh: 'UV400 防护，轻盈镜架，度假出街必备。', zhHant: 'UV400 防護，輕盈鏡架，度假出街必備。', en: 'UV400 protection on featherlight frames for vacation vibes.'),
    imagePath: 'assets/images/products/sunglasses.png'),
  // 服饰
  Product(id: 'sneakers', categoryId: 'fashion', priceCents: 59900, stock: 90, monthlySales: 12000, rating: 4.8,
    name: LocalizedText(zh: '云感缓震跑鞋', zhHant: '雲感緩震跑鞋', en: 'Cloud Runner Sneakers'),
    description: LocalizedText(zh: '踩云般的缓震回弹，跑步通勤都舒服。', zhHant: '踩雲般的緩震回彈，跑步通勤都舒服。', en: 'Cloud-soft cushioning and bounce for runs and commutes.'),
    imagePath: 'assets/images/products/sneakers.png'),
  Product(id: 'tee', categoryId: 'fashion', priceCents: 12900, stock: 200, monthlySales: 25000, rating: 4.5,
    name: LocalizedText(zh: '纯棉印花 T 恤', zhHant: '純棉印花 T 恤', en: 'Cotton Print Tee'),
    description: LocalizedText(zh: '100% 新疆长绒棉，柔软亲肤，百搭单品。', zhHant: '100% 新疆長絨棉，柔軟親膚，百搭單品。', en: '100% long-staple cotton, soft and endlessly mixable.'),
    imagePath: 'assets/images/products/tee.png'),
  Product(id: 'coat', categoryId: 'fashion', priceCents: 89900, stock: 35, monthlySales: 1800, rating: 4.7,
    name: LocalizedText(zh: '暖冬羊毛大衣', zhHant: '暖冬羊毛大衣', en: 'Warm Wool Coat'),
    description: LocalizedText(zh: '双面羊毛呢，挺括有型，冬天也要风度翩翩。', zhHant: '雙面羊毛呢，挺括有型，冬天也要風度翩翩。', en: 'Double-faced wool with a sharp silhouette for winter style.'),
    imagePath: 'assets/images/products/coat.png'),
  Product(id: 'cap', categoryId: 'fashion', priceCents: 8900, stock: 150, monthlySales: 9800, rating: 4.4,
    name: LocalizedText(zh: '街头棒球帽', zhHant: '街頭棒球帽', en: 'Street Baseball Cap'),
    description: LocalizedText(zh: '经典六片式帽型，防晒凹造型两不误。', zhHant: '經典六片式帽型，防曬凹造型兩不誤。', en: 'Classic six-panel cap for sun protection and style.'),
    imagePath: 'assets/images/products/cap.png'),
  Product(id: 'jeans', categoryId: 'fashion', priceCents: 29900, stock: 90, monthlySales: 7600, rating: 4.6,
    name: LocalizedText(zh: '复古直筒牛仔裤', zhHant: '復古直筒牛仔褲', en: 'Retro Straight Jeans'),
    description: LocalizedText(zh: '微弹面料，直筒版型，显瘦显腿长。', zhHant: '微彈面料，直筒版型，顯瘦顯腿長。', en: 'Stretch denim in a straight cut that flatters every leg.'),
    imagePath: 'assets/images/products/jeans.png'),
  // 食品
  Product(id: 'chocolate', categoryId: 'food', priceCents: 9900, stock: 120, monthlySales: 21000, rating: 4.8,
    name: LocalizedText(zh: '丝绒巧克力礼盒', zhHant: '絲絨巧克力禮盒', en: 'Velvet Chocolate Box'),
    description: LocalizedText(zh: '精选可可豆慢火烘焙，丝滑口感，送礼首选。', zhHant: '精選可可豆慢火烘焙，絲滑口感，送禮首選。', en: 'Slow-roasted cacao, silky smooth — the perfect gift.'),
    imagePath: 'assets/images/products/chocolate.png'),
  Product(id: 'coffee', categoryId: 'food', priceCents: 12800, stock: 70, monthlySales: 5400, rating: 4.9,
    name: LocalizedText(zh: '手冲精品咖啡豆', zhHant: '手沖精品咖啡豆', en: 'Pour-over Coffee Beans'),
    description: LocalizedText(zh: '中度烘焙，花果香气，办公续命神器。', zhHant: '中度烘焙，花果香氣，辦公續命神器。', en: 'Medium roast with floral notes — the office lifesaver.'),
    imagePath: 'assets/images/products/coffee.png'),
  Product(id: 'fruit', categoryId: 'food', priceCents: 16800, stock: 45, monthlySales: 8900, rating: 4.7,
    name: LocalizedText(zh: '阳光鲜果礼篮', zhHant: '陽光鮮果禮籃', en: 'Sunshine Fruit Basket'),
    description: LocalizedText(zh: '当季鲜果当日采摘，清甜多汁，维生素满满。', zhHant: '當季鮮果當日採摘，清甜多汁，維生素滿滿。', en: 'Same-day picked seasonal fruit, juicy and vitamin-packed.'),
    imagePath: 'assets/images/products/fruit.png'),
  Product(id: 'ramen', categoryId: 'food', priceCents: 5900, stock: 100, monthlySales: 15000, rating: 4.6,
    name: LocalizedText(zh: '深夜拉面套餐', zhHant: '深夜拉麵套餐', en: 'Midnight Ramen Kit'),
    description: LocalizedText(zh: '豚骨汤底配 Q 弹面条，5 分钟复刻深夜食堂。', zhHant: '豚骨湯底配 Q 彈麵條，5 分鐘複刻深夜食堂。', en: 'Tonkotsu broth with chewy noodles — midnight diner in 5 minutes.'),
    imagePath: 'assets/images/products/ramen.png'),
  Product(id: 'tea', categoryId: 'food', priceCents: 21800, stock: 55, monthlySales: 3600, rating: 4.9,
    name: LocalizedText(zh: '高山乌龙茶', zhHant: '高山烏龍茶', en: 'Alpine Oolong Tea'),
    description: LocalizedText(zh: '海拔 1200 米茶园，兰花香韵，回甘悠长。', zhHant: '海拔 1200 米茶園，蘭花香韻，回甘悠長。', en: 'Grown at 1200m with orchid aroma and a lasting sweet finish.'),
    imagePath: 'assets/images/products/tea.png'),
  // 家居
  Product(id: 'sofa', categoryId: 'home', priceCents: 299900, stock: 10, monthlySales: 420, rating: 4.8,
    name: LocalizedText(zh: '云朵模块沙发', zhHant: '雲朵模組沙發', en: 'Cloud Modular Sofa'),
    description: LocalizedText(zh: '高回弹海绵填充，自由组合，客厅的温柔乡。', zhHant: '高回彈海綿填充，自由組合，客廳的溫柔鄉。', en: 'High-resilience foam modules — build your living-room haven.'),
    imagePath: 'assets/images/products/sofa.png'),
  Product(id: 'lamp', categoryId: 'home', priceCents: 19900, stock: 65, monthlySales: 6800, rating: 4.7,
    name: LocalizedText(zh: '护眼智能台灯', zhHant: '護眼智能檯燈', en: 'Care Smart Lamp'),
    description: LocalizedText(zh: '无频闪暖光，三档色温，深夜赶工也安心。', zhHant: '無頻閃暖光，三檔色溫，深夜趕工也安心。', en: 'Flicker-free warm light with 3 color temps for late nights.'),
    imagePath: 'assets/images/products/lamp.png'),
  Product(id: 'plush', categoryId: 'home', priceCents: 7900, stock: 140, monthlySales: 13000, rating: 4.9,
    name: LocalizedText(zh: '治愈系小熊抱枕', zhHant: '治癒系小熊抱枕', en: 'Healing Bear Plush'),
    description: LocalizedText(zh: '软糯亲肤，抱起来就不想撒手。', zhHant: '軟糯親膚，抱起來就不想撒手。', en: 'So soft you will never want to let go.'),
    imagePath: 'assets/images/products/plush.png'),
  Product(id: 'candle', categoryId: 'home', priceCents: 6900, stock: 110, monthlySales: 8800, rating: 4.6,
    name: LocalizedText(zh: '森林香薰蜡烛', zhHant: '森林香薰蠟燭', en: 'Forest Aroma Candle'),
    description: LocalizedText(zh: '雪松与苔藓气息，点燃即入森林。', zhHant: '雪松與苔蘚氣息，點燃即入森林。', en: 'Cedar and moss notes — light it and step into the woods.'),
    imagePath: 'assets/images/products/candle.png'),
  Product(id: 'mug', categoryId: 'home', priceCents: 4900, stock: 160, monthlySales: 11000, rating: 4.7,
    name: LocalizedText(zh: '手作陶瓷马克杯', zhHant: '手作陶瓷馬克杯', en: 'Handmade Ceramic Mug'),
    description: LocalizedText(zh: '高温釉下彩，每只都是独一无二。', zhHant: '高溫釉下彩，每只都是獨一無二。', en: 'High-fired underglaze colors — every mug is one of a kind.'),
    imagePath: 'assets/images/products/mug.png'),
  // 美妆
  Product(id: 'lipstick', categoryId: 'beauty', priceCents: 32000, stock: 85, monthlySales: 19000, rating: 4.8,
    name: LocalizedText(zh: '丝绒哑光口红', zhHant: '絲絨啞光口紅', en: 'Velvet Matte Lipstick'),
    description: LocalizedText(zh: '一抹显色不拔干，约会通勤都出彩。', zhHant: '一抹顯色不拔乾，約會通勤都出彩。', en: 'One-swipe color that never dries out your lips.'),
    imagePath: 'assets/images/products/lipstick.png'),
  Product(id: 'cream', categoryId: 'beauty', priceCents: 48000, stock: 50, monthlySales: 7800, rating: 4.9,
    name: LocalizedText(zh: '焕颜保湿面霜', zhHant: '煥顏保濕面霜', en: 'Glow Moisturizer Cream'),
    description: LocalizedText(zh: '神经酰胺配方，72 小时锁水，素颜也发光。', zhHant: '神經醯胺配方，72 小時鎖水，素顏也發光。', en: 'Ceramide formula locks in moisture for 72h — glow bare-faced.'),
    imagePath: 'assets/images/products/cream.png'),
  Product(id: 'nail', categoryId: 'beauty', priceCents: 15000, stock: 75, monthlySales: 6400, rating: 4.5,
    name: LocalizedText(zh: '指尖派对指甲油套装', zhHant: '指尖派對指甲油套裝', en: 'Nail Party Polish Set'),
    description: LocalizedText(zh: '三色套装随心混搭，速干不脱落。', zhHant: '三色套裝隨心混搭，速乾不脫落。', en: 'Three quick-dry shades to mix and match your mood.'),
    imagePath: 'assets/images/products/nail.png'),
  // 图书
  Product(id: 'novel', categoryId: 'books', priceCents: 8900, stock: 95, monthlySales: 4600, rating: 4.8,
    name: LocalizedText(zh: '星尘往事三部曲', zhHant: '星塵往事三部曲', en: 'Stardust Trilogy'),
    description: LocalizedText(zh: '跨越百年的宇宙冒险，读过的都说好。', zhHant: '跨越百年的宇宙冒險，讀過的都說好。', en: 'A century-spanning cosmic adventure readers rave about.'),
    imagePath: 'assets/images/products/novel.png'),
  Product(id: 'watercolor', categoryId: 'books', priceCents: 12900, stock: 60, monthlySales: 2900, rating: 4.9,
    name: LocalizedText(zh: '零基础水彩教程', zhHant: '零基礎水彩教程', en: 'Watercolor Starter Guide'),
    description: LocalizedText(zh: '从握笔到晕染，小白也能画出治愈系小画。', zhHant: '從握筆到暈染，小白也能畫出治癒系小畫。', en: 'From brush grip to washes — paint cozy scenes as a beginner.'),
    imagePath: 'assets/images/products/watercolor.png'),
  Product(id: 'guide', categoryId: 'books', priceCents: 5900, stock: 130, monthlySales: 1700, rating: 4.6,
    name: LocalizedText(zh: '城市漫游指南', zhHant: '城市漫遊指南', en: 'City Wander Guide'),
    description: LocalizedText(zh: '本地人私藏路线，周末说走就走。', zhHant: '本地人私藏路線，週末說走就走。', en: 'Locals-only routes for spontaneous weekend wanders.'),
    imagePath: 'assets/images/products/guide.png'),
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
