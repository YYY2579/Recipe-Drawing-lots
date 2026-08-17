import 'package:drift/drift.dart';

/// 菜谱（对应文档 §25 Recipe）。categories / flavors 用 JSON 文本存储，MVP 简化。
@DataClassName('RecipeData')
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get difficulty => integer().nullable()(); // 1~5
  IntColumn get cookingTime => integer().nullable()(); // 分钟
  IntColumn get servings => integer().nullable()(); // 人份
  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get categoriesJson => text().nullable()(); // JSON 数组
  TextColumn get flavorsJson => text().nullable()(); // JSON 数组

  @override
  Set<Column> get primaryKey => {id};
}

/// 食材（一条菜谱可有多条）
@DataClassName('IngredientData')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId => text()();
  TextColumn get name => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// 调料（种子里多为字符串，amount/unit 可空）
@DataClassName('SeasoningData')
class Seasonings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId => text()();
  TextColumn get name => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// 烹饪步骤
@DataClassName('RecipeStepData')
class RecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId => text()();
  IntColumn get stepNumber => integer()();
  TextColumn get description => text()();
  TextColumn get imagePath => text().nullable()();
}

/// 签池（对应 §25 Pool）
@DataClassName('PoolData')
class Pools extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 签池 ↔ 菜谱 关联（多对多，菜与签池解耦 §8）。weight 为权重抽签预留。
class PoolRecipes extends Table {
  TextColumn get poolId => text()();
  TextColumn get recipeId => text()();
  RealColumn get weight => real().nullable()();

  @override
  Set<Column> get primaryKey => {poolId, recipeId};
}

/// 抽签历史（驱动 §12 最近不重复）
@DataClassName('DrawHistoryData')
class DrawHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get poolId => text()();
  TextColumn get recipeId => text()();
  DateTimeColumn get drawTime => dateTime()();
}

/// 设置（单行）
@DataClassName('SettingsData')
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get animationEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get excludeRecentCount =>
      integer().withDefault(const Constant(1))(); // 最近 N 次不重复
  TextColumn get theme => text().withDefault(const Constant('system'))();
  BoolColumn get luckyStarEnabled =>
      boolean().withDefault(const Constant(false))(); // 幸运星模式
}

/// 做饭记录（按天一条主记录，recordDate 截断到当天 00:00）。
@DataClassName('CookingRecordData')
class CookingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordDate => dateTime()(); // 当天日期（系统时间截断）
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
}

/// 做饭记录条目（当天做了哪些菜、买菜价格等）。
@DataClassName('CookingRecordItemData')
class CookingRecordItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer()();
  TextColumn get dishName => text()();
  RealColumn get price => real().nullable()(); // 买菜价格（元）
  TextColumn get note => text().nullable()();
}

/// 做饭记录模板（预留，可一键套用一组菜品）。
@DataClassName('CookingTemplateData')
class CookingTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get itemsJson => text().nullable()(); // JSON: [{"dishName":..,"price":..}]
}
