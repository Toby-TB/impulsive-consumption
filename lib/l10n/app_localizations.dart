import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'冲动消费'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In zh, this message translates to:
  /// **'今天不买，明天后悔'**
  String get appTagline;

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'好的'**
  String get ok;

  /// No description provided for @back.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中…'**
  String get loading;

  /// No description provided for @searchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索商品…'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In zh, this message translates to:
  /// **'没有找到相关商品'**
  String get searchEmpty;

  /// No description provided for @outOfStock.
  ///
  /// In zh, this message translates to:
  /// **'缺货'**
  String get outOfStock;

  /// No description provided for @stockLeft.
  ///
  /// In zh, this message translates to:
  /// **'库存 {count}'**
  String stockLeft(int count);

  /// No description provided for @monthlySales.
  ///
  /// In zh, this message translates to:
  /// **'月销 {count}'**
  String monthlySales(int count);

  /// No description provided for @ratingStar.
  ///
  /// In zh, this message translates to:
  /// **'{rating} 分'**
  String ratingStar(double rating);

  /// No description provided for @quantity.
  ///
  /// In zh, this message translates to:
  /// **'数量'**
  String get quantity;

  /// No description provided for @addToCart.
  ///
  /// In zh, this message translates to:
  /// **'加入购物车'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In zh, this message translates to:
  /// **'立即购买'**
  String get buyNow;

  /// No description provided for @addedToCart.
  ///
  /// In zh, this message translates to:
  /// **'已加入购物车'**
  String get addedToCart;

  /// No description provided for @insufficientStock.
  ///
  /// In zh, this message translates to:
  /// **'库存不足'**
  String get insufficientStock;

  /// No description provided for @operationFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请重试'**
  String get operationFailed;

  /// No description provided for @tabShop.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get tabShop;

  /// No description provided for @tabCart.
  ///
  /// In zh, this message translates to:
  /// **'购物车'**
  String get tabCart;

  /// No description provided for @tabOrders.
  ///
  /// In zh, this message translates to:
  /// **'订单'**
  String get tabOrders;

  /// No description provided for @tabProfile.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get tabProfile;

  /// No description provided for @selectAll.
  ///
  /// In zh, this message translates to:
  /// **'全选'**
  String get selectAll;

  /// No description provided for @totalLabel.
  ///
  /// In zh, this message translates to:
  /// **'合计'**
  String get totalLabel;

  /// No description provided for @checkoutN.
  ///
  /// In zh, this message translates to:
  /// **'结算({count})'**
  String checkoutN(int count);

  /// No description provided for @clearCart.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clearCart;

  /// No description provided for @clearCartConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定清空购物车吗？'**
  String get clearCartConfirm;

  /// No description provided for @cartEmpty.
  ///
  /// In zh, this message translates to:
  /// **'购物车空空的，去逛逛吧'**
  String get cartEmpty;

  /// No description provided for @goShopping.
  ///
  /// In zh, this message translates to:
  /// **'去逛逛'**
  String get goShopping;

  /// No description provided for @itemsCount.
  ///
  /// In zh, this message translates to:
  /// **'共 {count} 件商品'**
  String itemsCount(int count);

  /// No description provided for @checkoutTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认订单'**
  String get checkoutTitle;

  /// No description provided for @orderItems.
  ///
  /// In zh, this message translates to:
  /// **'商品清单'**
  String get orderItems;

  /// No description provided for @couponLabel.
  ///
  /// In zh, this message translates to:
  /// **'优惠券'**
  String get couponLabel;

  /// No description provided for @couponNone.
  ///
  /// In zh, this message translates to:
  /// **'不使用优惠券'**
  String get couponNone;

  /// No description provided for @couponBelowThreshold.
  ///
  /// In zh, this message translates to:
  /// **'满 {amount} 可用'**
  String couponBelowThreshold(String amount);

  /// No description provided for @couponDiscountFixed.
  ///
  /// In zh, this message translates to:
  /// **'立减 {amount}'**
  String couponDiscountFixed(String amount);

  /// No description provided for @couponDiscountPercent.
  ///
  /// In zh, this message translates to:
  /// **'享 {percent} 折'**
  String couponDiscountPercent(String percent);

  /// No description provided for @priceBreakdown.
  ///
  /// In zh, this message translates to:
  /// **'金额明细'**
  String get priceBreakdown;

  /// No description provided for @subtotalLabel.
  ///
  /// In zh, this message translates to:
  /// **'商品小计'**
  String get subtotalLabel;

  /// No description provided for @discountLabel.
  ///
  /// In zh, this message translates to:
  /// **'优惠'**
  String get discountLabel;

  /// No description provided for @payableLabel.
  ///
  /// In zh, this message translates to:
  /// **'应付'**
  String get payableLabel;

  /// No description provided for @payNow.
  ///
  /// In zh, this message translates to:
  /// **'立即支付'**
  String get payNow;

  /// No description provided for @insufficientTitle.
  ///
  /// In zh, this message translates to:
  /// **'余额不足'**
  String get insufficientTitle;

  /// No description provided for @insufficientMsg.
  ///
  /// In zh, this message translates to:
  /// **'还差 {amount}，去充值一下？'**
  String insufficientMsg(String amount);

  /// No description provided for @goRecharge.
  ///
  /// In zh, this message translates to:
  /// **'去充值'**
  String get goRecharge;

  /// No description provided for @paySurpriseDiscount.
  ///
  /// In zh, this message translates to:
  /// **'惊喜立减 {amount}'**
  String paySurpriseDiscount(String amount);

  /// No description provided for @paySurpriseRebate.
  ///
  /// In zh, this message translates to:
  /// **'惊喜返币 {amount}'**
  String paySurpriseRebate(String amount);

  /// No description provided for @surpriseBanner.
  ///
  /// In zh, this message translates to:
  /// **'🎉 今日彩蛋'**
  String get surpriseBanner;

  /// No description provided for @selectItemsFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先勾选要结算的商品'**
  String get selectItemsFirst;

  /// No description provided for @paymentSuccess.
  ///
  /// In zh, this message translates to:
  /// **'支付成功'**
  String get paymentSuccess;

  /// No description provided for @paymentSuccessDesc.
  ///
  /// In zh, this message translates to:
  /// **'模拟支付已完成，余额已扣除'**
  String get paymentSuccessDesc;

  /// No description provided for @orderNoLabel.
  ///
  /// In zh, this message translates to:
  /// **'订单号'**
  String get orderNoLabel;

  /// No description provided for @viewOrder.
  ///
  /// In zh, this message translates to:
  /// **'查看订单'**
  String get viewOrder;

  /// No description provided for @continueShopping.
  ///
  /// In zh, this message translates to:
  /// **'继续购物'**
  String get continueShopping;

  /// No description provided for @emptyOrders.
  ///
  /// In zh, this message translates to:
  /// **'还没有订单，去下一单吧'**
  String get emptyOrders;

  /// No description provided for @buyAgain.
  ///
  /// In zh, this message translates to:
  /// **'再次购买'**
  String get buyAgain;

  /// No description provided for @orderDetailTitle.
  ///
  /// In zh, this message translates to:
  /// **'订单详情'**
  String get orderDetailTitle;

  /// No description provided for @orderTime.
  ///
  /// In zh, this message translates to:
  /// **'下单时间'**
  String get orderTime;

  /// No description provided for @paidAmountLabel.
  ///
  /// In zh, this message translates to:
  /// **'实付'**
  String get paidAmountLabel;

  /// No description provided for @trackNoLabel.
  ///
  /// In zh, this message translates to:
  /// **'运单号'**
  String get trackNoLabel;

  /// No description provided for @addedAgain.
  ///
  /// In zh, this message translates to:
  /// **'商品已重新加入购物车'**
  String get addedAgain;

  /// No description provided for @logisticsTitle.
  ///
  /// In zh, this message translates to:
  /// **'物流跟踪'**
  String get logisticsTitle;

  /// No description provided for @logisticsDemoHint.
  ///
  /// In zh, this message translates to:
  /// **'模拟物流演示'**
  String get logisticsDemoHint;

  /// No description provided for @stPaid.
  ///
  /// In zh, this message translates to:
  /// **'已支付'**
  String get stPaid;

  /// No description provided for @stProcessing.
  ///
  /// In zh, this message translates to:
  /// **'商家备货'**
  String get stProcessing;

  /// No description provided for @stShipped.
  ///
  /// In zh, this message translates to:
  /// **'已发货'**
  String get stShipped;

  /// No description provided for @stTransit.
  ///
  /// In zh, this message translates to:
  /// **'运输中'**
  String get stTransit;

  /// No description provided for @stDelivered.
  ///
  /// In zh, this message translates to:
  /// **'已送达'**
  String get stDelivered;

  /// No description provided for @walletTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的钱包'**
  String get walletTitle;

  /// No description provided for @balanceLabel.
  ///
  /// In zh, this message translates to:
  /// **'当前余额'**
  String get balanceLabel;

  /// No description provided for @rechargeTitle.
  ///
  /// In zh, this message translates to:
  /// **'模拟充值'**
  String get rechargeTitle;

  /// No description provided for @rechargeAmount.
  ///
  /// In zh, this message translates to:
  /// **'充值金额'**
  String get rechargeAmount;

  /// No description provided for @customAmount.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get customAmount;

  /// No description provided for @rechargeSuccess.
  ///
  /// In zh, this message translates to:
  /// **'充值成功'**
  String get rechargeSuccess;

  /// No description provided for @invalidAmount.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效金额'**
  String get invalidAmount;

  /// No description provided for @transactionsTitle.
  ///
  /// In zh, this message translates to:
  /// **'收支明细'**
  String get transactionsTitle;

  /// No description provided for @emptyTransactions.
  ///
  /// In zh, this message translates to:
  /// **'暂无收支明细'**
  String get emptyTransactions;

  /// No description provided for @txnRecharge.
  ///
  /// In zh, this message translates to:
  /// **'余额充值'**
  String get txnRecharge;

  /// No description provided for @txnPayment.
  ///
  /// In zh, this message translates to:
  /// **'订单支付'**
  String get txnPayment;

  /// No description provided for @txnSignin.
  ///
  /// In zh, this message translates to:
  /// **'签到奖励'**
  String get txnSignin;

  /// No description provided for @txnRebate.
  ///
  /// In zh, this message translates to:
  /// **'彩蛋返币'**
  String get txnRebate;

  /// No description provided for @signinTitle.
  ///
  /// In zh, this message translates to:
  /// **'每日签到'**
  String get signinTitle;

  /// No description provided for @signinNow.
  ///
  /// In zh, this message translates to:
  /// **'立即签到'**
  String get signinNow;

  /// No description provided for @signedToday.
  ///
  /// In zh, this message translates to:
  /// **'今日已签到'**
  String get signedToday;

  /// No description provided for @streakDays.
  ///
  /// In zh, this message translates to:
  /// **'已连续签到 {count} 天'**
  String streakDays(int count);

  /// No description provided for @signinReward.
  ///
  /// In zh, this message translates to:
  /// **'获得 {amount} 奖励'**
  String signinReward(String amount);

  /// No description provided for @signinHint.
  ///
  /// In zh, this message translates to:
  /// **'连续签到奖励递增，7 天一个循环，断签重新开始'**
  String get signinHint;

  /// No description provided for @dayN.
  ///
  /// In zh, this message translates to:
  /// **'第 {count} 天'**
  String dayN(int count);

  /// No description provided for @favoritesTitle.
  ///
  /// In zh, this message translates to:
  /// **'收藏夹'**
  String get favoritesTitle;

  /// No description provided for @emptyFavorites.
  ///
  /// In zh, this message translates to:
  /// **'还没有收藏的商品'**
  String get emptyFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In zh, this message translates to:
  /// **'已加入收藏'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In zh, this message translates to:
  /// **'已取消收藏'**
  String get removedFromFavorites;

  /// No description provided for @achievementsTitle.
  ///
  /// In zh, this message translates to:
  /// **'成就徽章'**
  String get achievementsTitle;

  /// No description provided for @achievementUnlocked.
  ///
  /// In zh, this message translates to:
  /// **'解锁成就「{name}」'**
  String achievementUnlocked(String name);

  /// No description provided for @achFirstOrder.
  ///
  /// In zh, this message translates to:
  /// **'首单达成'**
  String get achFirstOrder;

  /// No description provided for @achFirstOrderDesc.
  ///
  /// In zh, this message translates to:
  /// **'完成第一笔订单'**
  String get achFirstOrderDesc;

  /// No description provided for @achShopaholic.
  ///
  /// In zh, this message translates to:
  /// **'剁手大师'**
  String get achShopaholic;

  /// No description provided for @achShopaholicDesc.
  ///
  /// In zh, this message translates to:
  /// **'累计完成 10 笔订单'**
  String get achShopaholicDesc;

  /// No description provided for @achWeekStreak.
  ///
  /// In zh, this message translates to:
  /// **'七日之约'**
  String get achWeekStreak;

  /// No description provided for @achWeekStreakDesc.
  ///
  /// In zh, this message translates to:
  /// **'连续签到 7 天'**
  String get achWeekStreakDesc;

  /// No description provided for @achCollector.
  ///
  /// In zh, this message translates to:
  /// **'收藏家'**
  String get achCollector;

  /// No description provided for @achCollectorDesc.
  ///
  /// In zh, this message translates to:
  /// **'收藏 10 件商品'**
  String get achCollectorDesc;

  /// No description provided for @achBigSpender.
  ///
  /// In zh, this message translates to:
  /// **'挥金如土'**
  String get achBigSpender;

  /// No description provided for @achBigSpenderDesc.
  ///
  /// In zh, this message translates to:
  /// **'累计消费 ¥50,000'**
  String get achBigSpenderDesc;

  /// No description provided for @locked.
  ///
  /// In zh, this message translates to:
  /// **'未解锁'**
  String get locked;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In zh, this message translates to:
  /// **'货币'**
  String get currency;

  /// No description provided for @theme.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeDark;

  /// No description provided for @logisticsSpeed.
  ///
  /// In zh, this message translates to:
  /// **'物流速度'**
  String get logisticsSpeed;

  /// No description provided for @logisticsFast.
  ///
  /// In zh, this message translates to:
  /// **'极速演示（约 3 分钟送达）'**
  String get logisticsFast;

  /// No description provided for @logisticsReal.
  ///
  /// In zh, this message translates to:
  /// **'拟真模式（1–3 天送达）'**
  String get logisticsReal;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// No description provided for @aboutContent.
  ///
  /// In zh, this message translates to:
  /// **'纯本地模拟购物应用：无真实支付、无网络请求，所有数据仅保存在本设备上。'**
  String get aboutContent;

  /// No description provided for @version.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @resetData.
  ///
  /// In zh, this message translates to:
  /// **'重置演示数据'**
  String get resetData;

  /// No description provided for @resetConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定重置全部数据吗？余额、订单、优惠券将恢复初始状态。'**
  String get resetConfirm;

  /// No description provided for @resetDone.
  ///
  /// In zh, this message translates to:
  /// **'已重置，世界焕然一新'**
  String get resetDone;

  /// No description provided for @languageZhHans.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get languageZhHans;

  /// No description provided for @languageZhHant.
  ///
  /// In zh, this message translates to:
  /// **'繁體中文'**
  String get languageZhHant;

  /// No description provided for @languageEn.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @currencyCny.
  ///
  /// In zh, this message translates to:
  /// **'人民币（¥）'**
  String get currencyCny;

  /// No description provided for @currencyHkd.
  ///
  /// In zh, this message translates to:
  /// **'港币（HK\$）'**
  String get currencyHkd;

  /// No description provided for @currencyUsd.
  ///
  /// In zh, this message translates to:
  /// **'美元（US\$）'**
  String get currencyUsd;

  /// No description provided for @walletEntry.
  ///
  /// In zh, this message translates to:
  /// **'钱包'**
  String get walletEntry;

  /// No description provided for @favoritesEntry.
  ///
  /// In zh, this message translates to:
  /// **'收藏夹'**
  String get favoritesEntry;

  /// No description provided for @signinEntry.
  ///
  /// In zh, this message translates to:
  /// **'每日签到'**
  String get signinEntry;

  /// No description provided for @achievementsEntry.
  ///
  /// In zh, this message translates to:
  /// **'成就徽章'**
  String get achievementsEntry;

  /// No description provided for @ordersEntry.
  ///
  /// In zh, this message translates to:
  /// **'订单中心'**
  String get ordersEntry;

  /// No description provided for @settingsEntry.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsEntry;

  /// No description provided for @welcome.
  ///
  /// In zh, this message translates to:
  /// **'你好，购物达人'**
  String get welcome;

  /// No description provided for @profileSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'欢迎来到冲动消费，尽情享受购物的快乐吧'**
  String get profileSubtitle;

  /// No description provided for @dbInitFailed.
  ///
  /// In zh, this message translates to:
  /// **'本地数据初始化失败'**
  String get dbInitFailed;

  /// No description provided for @freeShipping.
  ///
  /// In zh, this message translates to:
  /// **'全场包邮（模拟）'**
  String get freeShipping;

  /// No description provided for @perItem.
  ///
  /// In zh, this message translates to:
  /// **'件'**
  String get perItem;

  /// No description provided for @heroTitle.
  ///
  /// In zh, this message translates to:
  /// **'想买就买 · 开心就好'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'模拟购物 · 虚拟钱包 · ¥10,000 开局畅玩全场'**
  String get heroSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
