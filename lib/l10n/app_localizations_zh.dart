// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '冲动消费';

  @override
  String get appTagline => '今天不买，明天后悔';

  @override
  String get all => '全部';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get ok => '好的';

  @override
  String get back => '返回';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中…';

  @override
  String get searchHint => '搜索商品…';

  @override
  String get searchEmpty => '没有找到相关商品';

  @override
  String get outOfStock => '缺货';

  @override
  String stockLeft(int count) {
    return '库存 $count';
  }

  @override
  String monthlySales(int count) {
    return '月销 $count';
  }

  @override
  String ratingStar(double rating) {
    return '$rating 分';
  }

  @override
  String get quantity => '数量';

  @override
  String get addToCart => '加入购物车';

  @override
  String get buyNow => '立即购买';

  @override
  String get addedToCart => '已加入购物车';

  @override
  String get insufficientStock => '库存不足';

  @override
  String get operationFailed => '操作失败，请重试';

  @override
  String get tabShop => '首页';

  @override
  String get tabCart => '购物车';

  @override
  String get tabOrders => '订单';

  @override
  String get tabProfile => '我的';

  @override
  String get selectAll => '全选';

  @override
  String get totalLabel => '合计';

  @override
  String checkoutN(int count) {
    return '结算($count)';
  }

  @override
  String get clearCart => '清空';

  @override
  String get clearCartConfirm => '确定清空购物车吗？';

  @override
  String get cartEmpty => '购物车空空的，去逛逛吧';

  @override
  String get goShopping => '去逛逛';

  @override
  String itemsCount(int count) {
    return '共 $count 件商品';
  }

  @override
  String get checkoutTitle => '确认订单';

  @override
  String get orderItems => '商品清单';

  @override
  String get couponLabel => '优惠券';

  @override
  String get couponNone => '不使用优惠券';

  @override
  String couponBelowThreshold(String amount) {
    return '满 $amount 可用';
  }

  @override
  String couponDiscountFixed(String amount) {
    return '立减 $amount';
  }

  @override
  String couponDiscountPercent(String percent) {
    return '享 $percent 折';
  }

  @override
  String get priceBreakdown => '金额明细';

  @override
  String get subtotalLabel => '商品小计';

  @override
  String get discountLabel => '优惠';

  @override
  String get payableLabel => '应付';

  @override
  String get payNow => '立即支付';

  @override
  String get insufficientTitle => '余额不足';

  @override
  String insufficientMsg(String amount) {
    return '还差 $amount，去充值一下？';
  }

  @override
  String get goRecharge => '去充值';

  @override
  String paySurpriseDiscount(String amount) {
    return '惊喜立减 $amount';
  }

  @override
  String paySurpriseRebate(String amount) {
    return '惊喜返币 $amount';
  }

  @override
  String get surpriseBanner => '🎉 今日彩蛋';

  @override
  String get selectItemsFirst => '请先勾选要结算的商品';

  @override
  String get paymentSuccess => '支付成功';

  @override
  String get paymentSuccessDesc => '模拟支付已完成，余额已扣除';

  @override
  String get orderNoLabel => '订单号';

  @override
  String get viewOrder => '查看订单';

  @override
  String get continueShopping => '继续购物';

  @override
  String get emptyOrders => '还没有订单，去下一单吧';

  @override
  String get buyAgain => '再次购买';

  @override
  String get orderDetailTitle => '订单详情';

  @override
  String get orderTime => '下单时间';

  @override
  String get paidAmountLabel => '实付';

  @override
  String get trackNoLabel => '运单号';

  @override
  String get addedAgain => '商品已重新加入购物车';

  @override
  String get logisticsTitle => '物流跟踪';

  @override
  String get logisticsDemoHint => '模拟物流演示';

  @override
  String get stPaid => '已支付';

  @override
  String get stProcessing => '商家备货';

  @override
  String get stShipped => '已发货';

  @override
  String get stTransit => '运输中';

  @override
  String get stDelivered => '已送达';

  @override
  String get walletTitle => '我的钱包';

  @override
  String get balanceLabel => '当前余额';

  @override
  String get rechargeTitle => '模拟充值';

  @override
  String get rechargeAmount => '充值金额';

  @override
  String get customAmount => '自定义';

  @override
  String get rechargeSuccess => '充值成功';

  @override
  String get invalidAmount => '请输入有效金额';

  @override
  String get transactionsTitle => '收支明细';

  @override
  String get emptyTransactions => '暂无收支明细';

  @override
  String get txnRecharge => '余额充值';

  @override
  String get txnPayment => '订单支付';

  @override
  String get txnSignin => '签到奖励';

  @override
  String get txnRebate => '彩蛋返币';

  @override
  String get signinTitle => '每日签到';

  @override
  String get signinNow => '立即签到';

  @override
  String get signedToday => '今日已签到';

  @override
  String streakDays(int count) {
    return '已连续签到 $count 天';
  }

  @override
  String signinReward(String amount) {
    return '获得 $amount 奖励';
  }

  @override
  String get signinHint => '连续签到奖励递增，7 天一个循环，断签重新开始';

  @override
  String dayN(int count) {
    return '第 $count 天';
  }

  @override
  String get favoritesTitle => '收藏夹';

  @override
  String get emptyFavorites => '还没有收藏的商品';

  @override
  String get addedToFavorites => '已加入收藏';

  @override
  String get removedFromFavorites => '已取消收藏';

  @override
  String get achievementsTitle => '成就徽章';

  @override
  String achievementUnlocked(String name) {
    return '解锁成就「$name」';
  }

  @override
  String get achFirstOrder => '首单达成';

  @override
  String get achFirstOrderDesc => '完成第一笔订单';

  @override
  String get achShopaholic => '剁手大师';

  @override
  String get achShopaholicDesc => '累计完成 10 笔订单';

  @override
  String get achWeekStreak => '七日之约';

  @override
  String get achWeekStreakDesc => '连续签到 7 天';

  @override
  String get achCollector => '收藏家';

  @override
  String get achCollectorDesc => '收藏 10 件商品';

  @override
  String get achBigSpender => '挥金如土';

  @override
  String get achBigSpenderDesc => '累计消费 ¥50,000';

  @override
  String get locked => '未解锁';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get currency => '货币';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get logisticsSpeed => '物流速度';

  @override
  String get logisticsFast => '极速演示（约 3 分钟送达）';

  @override
  String get logisticsReal => '拟真模式（1–3 天送达）';

  @override
  String get about => '关于';

  @override
  String get aboutContent => '纯本地模拟购物应用：无真实支付、无网络请求，所有数据仅保存在本设备上。';

  @override
  String get version => '版本';

  @override
  String get resetData => '重置演示数据';

  @override
  String get resetConfirm => '确定重置全部数据吗？余额、订单、优惠券将恢复初始状态。';

  @override
  String get resetDone => '已重置，世界焕然一新';

  @override
  String get languageZhHans => '简体中文';

  @override
  String get languageZhHant => '繁體中文';

  @override
  String get languageEn => 'English';

  @override
  String get currencyCny => '人民币（¥）';

  @override
  String get currencyHkd => '港币（HK\$）';

  @override
  String get currencyUsd => '美元（US\$）';

  @override
  String get walletEntry => '钱包';

  @override
  String get favoritesEntry => '收藏夹';

  @override
  String get signinEntry => '每日签到';

  @override
  String get achievementsEntry => '成就徽章';

  @override
  String get ordersEntry => '订单中心';

  @override
  String get settingsEntry => '设置';

  @override
  String get welcome => '你好，购物达人';

  @override
  String get profileSubtitle => '欢迎来到冲动消费，尽情享受购物的快乐吧';

  @override
  String get dbInitFailed => '本地数据初始化失败';

  @override
  String get freeShipping => '全场包邮（模拟）';

  @override
  String get perItem => '件';

  @override
  String get heroTitle => '買 一切 · 不心疼';

  @override
  String get heroSubtitle => '虛擬餘額 ¥10,000 開局 · 今天不買明天後悔';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appName => '衝動消費';

  @override
  String get appTagline => '今天不買，明天後悔';

  @override
  String get all => '全部';

  @override
  String get confirm => '確認';

  @override
  String get cancel => '取消';

  @override
  String get ok => '好的';

  @override
  String get back => '返回';

  @override
  String get retry => '重試';

  @override
  String get loading => '載入中…';

  @override
  String get searchHint => '搜尋商品…';

  @override
  String get searchEmpty => '沒有找到相關商品';

  @override
  String get outOfStock => '缺貨';

  @override
  String stockLeft(int count) {
    return '庫存 $count';
  }

  @override
  String monthlySales(int count) {
    return '月銷 $count';
  }

  @override
  String ratingStar(double rating) {
    return '$rating 分';
  }

  @override
  String get quantity => '數量';

  @override
  String get addToCart => '加入購物車';

  @override
  String get buyNow => '立即購買';

  @override
  String get addedToCart => '已加入購物車';

  @override
  String get insufficientStock => '庫存不足';

  @override
  String get operationFailed => '操作失敗，請重試';

  @override
  String get tabShop => '首頁';

  @override
  String get tabCart => '購物車';

  @override
  String get tabOrders => '訂單';

  @override
  String get tabProfile => '我的';

  @override
  String get selectAll => '全選';

  @override
  String get totalLabel => '合計';

  @override
  String checkoutN(int count) {
    return '結算($count)';
  }

  @override
  String get clearCart => '清空';

  @override
  String get clearCartConfirm => '確定清空購物車嗎？';

  @override
  String get cartEmpty => '購物車空空的，去逛逛吧';

  @override
  String get goShopping => '去逛逛';

  @override
  String itemsCount(int count) {
    return '共 $count 件商品';
  }

  @override
  String get checkoutTitle => '確認訂單';

  @override
  String get orderItems => '商品清單';

  @override
  String get couponLabel => '優惠券';

  @override
  String get couponNone => '不使用優惠券';

  @override
  String couponBelowThreshold(String amount) {
    return '滿 $amount 可用';
  }

  @override
  String couponDiscountFixed(String amount) {
    return '立減 $amount';
  }

  @override
  String couponDiscountPercent(String percent) {
    return '享 $percent 折';
  }

  @override
  String get priceBreakdown => '金額明細';

  @override
  String get subtotalLabel => '商品小計';

  @override
  String get discountLabel => '優惠';

  @override
  String get payableLabel => '應付';

  @override
  String get payNow => '立即支付';

  @override
  String get insufficientTitle => '餘額不足';

  @override
  String insufficientMsg(String amount) {
    return '還差 $amount，去充值一下？';
  }

  @override
  String get goRecharge => '去充值';

  @override
  String paySurpriseDiscount(String amount) {
    return '驚喜立減 $amount';
  }

  @override
  String paySurpriseRebate(String amount) {
    return '驚喜返幣 $amount';
  }

  @override
  String get surpriseBanner => '🎉 今日彩蛋';

  @override
  String get selectItemsFirst => '請先勾選要結算的商品';

  @override
  String get paymentSuccess => '支付成功';

  @override
  String get paymentSuccessDesc => '模擬支付已完成，餘額已扣除';

  @override
  String get orderNoLabel => '訂單號';

  @override
  String get viewOrder => '查看訂單';

  @override
  String get continueShopping => '繼續購物';

  @override
  String get emptyOrders => '還沒有訂單，去下一單吧';

  @override
  String get buyAgain => '再次購買';

  @override
  String get orderDetailTitle => '訂單詳情';

  @override
  String get orderTime => '下單時間';

  @override
  String get paidAmountLabel => '實付';

  @override
  String get trackNoLabel => '運單號';

  @override
  String get addedAgain => '商品已重新加入購物車';

  @override
  String get logisticsTitle => '物流追蹤';

  @override
  String get logisticsDemoHint => '模擬物流演示';

  @override
  String get stPaid => '已支付';

  @override
  String get stProcessing => '商家備貨';

  @override
  String get stShipped => '已發貨';

  @override
  String get stTransit => '運輸中';

  @override
  String get stDelivered => '已送達';

  @override
  String get walletTitle => '我的錢包';

  @override
  String get balanceLabel => '當前餘額';

  @override
  String get rechargeTitle => '模擬充值';

  @override
  String get rechargeAmount => '充值金額';

  @override
  String get customAmount => '自訂';

  @override
  String get rechargeSuccess => '充值成功';

  @override
  String get invalidAmount => '請輸入有效金額';

  @override
  String get transactionsTitle => '收支明細';

  @override
  String get emptyTransactions => '暫無收支明細';

  @override
  String get txnRecharge => '餘額充值';

  @override
  String get txnPayment => '訂單支付';

  @override
  String get txnSignin => '簽到獎勵';

  @override
  String get txnRebate => '彩蛋返幣';

  @override
  String get signinTitle => '每日簽到';

  @override
  String get signinNow => '立即簽到';

  @override
  String get signedToday => '今日已簽到';

  @override
  String streakDays(int count) {
    return '已連續簽到 $count 天';
  }

  @override
  String signinReward(String amount) {
    return '獲得 $amount 獎勵';
  }

  @override
  String get signinHint => '連續簽到獎勵遞增，7 天一個循環，斷簽重新開始';

  @override
  String dayN(int count) {
    return '第 $count 天';
  }

  @override
  String get favoritesTitle => '收藏夾';

  @override
  String get emptyFavorites => '還沒有收藏的商品';

  @override
  String get addedToFavorites => '已加入收藏';

  @override
  String get removedFromFavorites => '已取消收藏';

  @override
  String get achievementsTitle => '成就徽章';

  @override
  String achievementUnlocked(String name) {
    return '解鎖成就「$name」';
  }

  @override
  String get achFirstOrder => '首單達成';

  @override
  String get achFirstOrderDesc => '完成第一筆訂單';

  @override
  String get achShopaholic => '剁手大師';

  @override
  String get achShopaholicDesc => '累計完成 10 筆訂單';

  @override
  String get achWeekStreak => '七日之約';

  @override
  String get achWeekStreakDesc => '連續簽到 7 天';

  @override
  String get achCollector => '收藏家';

  @override
  String get achCollectorDesc => '收藏 10 件商品';

  @override
  String get achBigSpender => '揮金如土';

  @override
  String get achBigSpenderDesc => '累計消費 ¥50,000';

  @override
  String get locked => '未解鎖';

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '語言';

  @override
  String get currency => '貨幣';

  @override
  String get theme => '主題';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get logisticsSpeed => '物流速度';

  @override
  String get logisticsFast => '極速演示（約 3 分鐘送達）';

  @override
  String get logisticsReal => '擬真模式（1–3 天送達）';

  @override
  String get about => '關於';

  @override
  String get aboutContent => '純本地模擬購物應用：無真實支付、無網路請求，所有資料僅保存在本裝置上。';

  @override
  String get version => '版本';

  @override
  String get resetData => '重置演示資料';

  @override
  String get resetConfirm => '確定重置全部資料嗎？餘額、訂單、優惠券將恢復初始狀態。';

  @override
  String get resetDone => '已重置，世界煥然一新';

  @override
  String get languageZhHans => '简体中文';

  @override
  String get languageZhHant => '繁體中文';

  @override
  String get languageEn => 'English';

  @override
  String get currencyCny => '人民幣（¥）';

  @override
  String get currencyHkd => '港幣（HK\$）';

  @override
  String get currencyUsd => '美元（US\$）';

  @override
  String get walletEntry => '錢包';

  @override
  String get favoritesEntry => '收藏夾';

  @override
  String get signinEntry => '每日簽到';

  @override
  String get achievementsEntry => '成就徽章';

  @override
  String get ordersEntry => '訂單中心';

  @override
  String get settingsEntry => '設定';

  @override
  String get welcome => '你好，購物達人';

  @override
  String get profileSubtitle => '歡迎來到衝動消費，盡情享受購物的快樂吧';

  @override
  String get dbInitFailed => '本地資料初始化失敗';

  @override
  String get freeShipping => '全場包郵（模擬）';

  @override
  String get perItem => '件';

  @override
  String get heroTitle => '買 一切 · 不心疼';

  @override
  String get heroSubtitle => '虛擬餘額 ¥10,000 開局 · 今天不買明天後悔';
}
