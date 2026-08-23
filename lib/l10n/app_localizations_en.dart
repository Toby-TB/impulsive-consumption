// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Impulsive Consumption';

  @override
  String get appTagline => 'Buy today, regret tomorrow';

  @override
  String get all => 'All';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get searchHint => 'Search products…';

  @override
  String get searchEmpty => 'No products found';

  @override
  String get outOfStock => 'Sold out';

  @override
  String stockLeft(int count) {
    return 'Stock: $count';
  }

  @override
  String monthlySales(int count) {
    return '$count sold/mo';
  }

  @override
  String ratingStar(double rating) {
    return '$rating ★';
  }

  @override
  String get quantity => 'Quantity';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get insufficientStock => 'Not enough stock';

  @override
  String get operationFailed => 'Something went wrong. Try again';

  @override
  String get tabShop => 'Home';

  @override
  String get tabCart => 'Cart';

  @override
  String get tabOrders => 'Orders';

  @override
  String get tabProfile => 'Me';

  @override
  String get selectAll => 'Select all';

  @override
  String get totalLabel => 'Total';

  @override
  String checkoutN(int count) {
    return 'Checkout ($count)';
  }

  @override
  String get clearCart => 'Clear';

  @override
  String get clearCartConfirm => 'Clear the whole cart?';

  @override
  String get cartEmpty => 'Your cart is empty — go shopping!';

  @override
  String get goShopping => 'Go shopping';

  @override
  String itemsCount(int count) {
    return '$count item(s)';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get orderItems => 'Items';

  @override
  String get couponLabel => 'Coupon';

  @override
  String get couponNone => 'No coupon';

  @override
  String couponBelowThreshold(String amount) {
    return 'Valid over $amount';
  }

  @override
  String couponDiscountFixed(String amount) {
    return '−$amount';
  }

  @override
  String couponDiscountPercent(String percent) {
    return 'Pay ${percent}0%';
  }

  @override
  String get priceBreakdown => 'Summary';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get discountLabel => 'Discount';

  @override
  String get payableLabel => 'Payable';

  @override
  String get payNow => 'Pay Now';

  @override
  String get insufficientTitle => 'Insufficient balance';

  @override
  String insufficientMsg(String amount) {
    return 'You\'re $amount short. Recharge now?';
  }

  @override
  String get goRecharge => 'Recharge';

  @override
  String paySurpriseDiscount(String amount) {
    return 'Lucky −$amount';
  }

  @override
  String paySurpriseRebate(String amount) {
    return 'Lucky +$amount rebate';
  }

  @override
  String get surpriseBanner => '🎉 Lucky Egg';

  @override
  String get selectItemsFirst => 'Select items to check out first';

  @override
  String get paymentSuccess => 'Payment Successful';

  @override
  String get paymentSuccessDesc =>
      'Simulated payment complete — balance deducted';

  @override
  String get orderNoLabel => 'Order No.';

  @override
  String get viewOrder => 'View Order';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get emptyOrders => 'No orders yet — place your first one!';

  @override
  String get buyAgain => 'Buy Again';

  @override
  String get orderDetailTitle => 'Order Detail';

  @override
  String get orderTime => 'Placed at';

  @override
  String get paidAmountLabel => 'Paid';

  @override
  String get trackNoLabel => 'Tracking No.';

  @override
  String get addedAgain => 'Items added back to your cart';

  @override
  String get logisticsTitle => 'Logistics';

  @override
  String get logisticsDemoHint => 'Simulated logistics';

  @override
  String get stPaid => 'Paid';

  @override
  String get stProcessing => 'Preparing';

  @override
  String get stShipped => 'Shipped';

  @override
  String get stTransit => 'In transit';

  @override
  String get stDelivered => 'Delivered';

  @override
  String get walletTitle => 'My Wallet';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get rechargeTitle => 'Simulated Recharge';

  @override
  String get rechargeAmount => 'Amount';

  @override
  String get customAmount => 'Custom';

  @override
  String get rechargeSuccess => 'Recharged';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get emptyTransactions => 'No transactions yet';

  @override
  String get txnRecharge => 'Recharge';

  @override
  String get txnPayment => 'Order payment';

  @override
  String get txnSignin => 'Sign-in bonus';

  @override
  String get txnRebate => 'Lucky rebate';

  @override
  String get signinTitle => 'Daily Sign-in';

  @override
  String get signinNow => 'Sign in now';

  @override
  String get signedToday => 'Signed in today';

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String signinReward(String amount) {
    return 'Earned $amount';
  }

  @override
  String get signinHint =>
      'Streak rewards grow over a 7-day cycle — a missed day restarts it';

  @override
  String dayN(int count) {
    return 'Day $count';
  }

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get emptyFavorites => 'No favorites yet';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String achievementUnlocked(String name) {
    return 'Achievement unlocked: $name';
  }

  @override
  String get achFirstOrder => 'First Order!';

  @override
  String get achFirstOrderDesc => 'Complete your first order';

  @override
  String get achShopaholic => 'Shopaholic';

  @override
  String get achShopaholicDesc => 'Complete 10 orders';

  @override
  String get achWeekStreak => 'Week Streak';

  @override
  String get achWeekStreakDesc => 'Sign in 7 days in a row';

  @override
  String get achCollector => 'Collector';

  @override
  String get achCollectorDesc => 'Favorite 10 products';

  @override
  String get achBigSpender => 'Big Spender';

  @override
  String get achBigSpenderDesc => 'Spend ¥50,000 in total';

  @override
  String get locked => 'Locked';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get logisticsSpeed => 'Logistics speed';

  @override
  String get logisticsFast => 'Turbo demo (~3 min delivery)';

  @override
  String get logisticsReal => 'Realistic (1–3 day delivery)';

  @override
  String get about => 'About';

  @override
  String get aboutContent =>
      'A fully offline shopping simulator — no real payments, no network, all data stays on this device.';

  @override
  String get version => 'Version';

  @override
  String get resetData => 'Reset demo data';

  @override
  String get resetConfirm =>
      'Reset everything? Balance, orders and coupons return to their initial state.';

  @override
  String get resetDone => 'Reset complete — fresh start!';

  @override
  String get languageZhHans => '简体中文';

  @override
  String get languageZhHant => '繁體中文';

  @override
  String get languageEn => 'English';

  @override
  String get currencyCny => 'CNY (¥)';

  @override
  String get currencyHkd => 'HKD (HK\$)';

  @override
  String get currencyUsd => 'USD (US\$)';

  @override
  String get walletEntry => 'Wallet';

  @override
  String get favoritesEntry => 'Favorites';

  @override
  String get signinEntry => 'Daily Sign-in';

  @override
  String get achievementsEntry => 'Achievements';

  @override
  String get ordersEntry => 'Orders';

  @override
  String get settingsEntry => 'Settings';

  @override
  String get welcome => 'Hello, shopper!';

  @override
  String get profileSubtitle =>
      'Welcome to Impulsive Consumption — enjoy the joy of shopping';

  @override
  String get dbInitFailed => 'Failed to initialize local data';

  @override
  String get freeShipping => 'Free shipping (simulated)';

  @override
  String get perItem => 'pcs';

  @override
  String get heroTitle => 'BUY ON IMPULSE. HAVE FUN.';

  @override
  String get heroSubtitle =>
      'Simulated shopping · Virtual wallet · Start with ¥10,000';
}
