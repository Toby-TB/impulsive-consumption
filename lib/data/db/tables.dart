import 'package:drift/drift.dart';

class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  BoolColumn get selected => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}

class Favorites extends Table {
  TextColumn get productId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {productId};
}

class WalletAccount extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get balanceCents => integer()();
}

class WalletTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // recharge | payment | signin | rebate
  IntColumn get amountCents => integer()(); // 带符号
  IntColumn get balanceAfterCents => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNo => text().unique()();
  IntColumn get totalCents => integer()(); // 实付
  IntColumn get discountCents => integer().withDefault(const Constant(0))();
  TextColumn get couponTitle => text().withDefault(const Constant(''))();
  TextColumn get surpriseNote => text().withDefault(const Constant(''))(); // 'D500' 立减 / 'R1200' 返币
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get paidAt => dateTime()();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  TextColumn get productId => text()();
  TextColumn get name => text().withDefault(const Constant(''))(); // 快照（简体中文，兜底）
  TextColumn get imagePath => text().withDefault(const Constant(''))();
  IntColumn get unitPriceCents => integer()();
  IntColumn get quantity => integer()();
}

class Coupons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get title => text().withDefault(const Constant(''))(); // 快照（简体中文）
  IntColumn get kind => integer()(); // 0=满减 1=折扣
  IntColumn get value => integer()();
  IntColumn get thresholdCents => integer()();
  DateTimeColumn get usedAt => dateTime().nullable()();
}

class SignIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()(); // yyyy-MM-dd
  IntColumn get streak => integer()();
  IntColumn get rewardCents => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class ProductStocks extends Table {
  TextColumn get productId => text()();
  IntColumn get stock => integer()();
  TextColumn get restockDate => text()(); // yyyy-MM-dd

  @override
  Set<Column> get primaryKey => {productId};
}

class Achievements extends Table {
  TextColumn get key => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
