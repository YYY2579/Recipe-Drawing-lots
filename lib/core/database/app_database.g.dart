// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
      'difficulty', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cookingTimeMeta =
      const VerificationMeta('cookingTime');
  @override
  late final GeneratedColumn<int> cookingTime = GeneratedColumn<int>(
      'cooking_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _categoriesJsonMeta =
      const VerificationMeta('categoriesJson');
  @override
  late final GeneratedColumn<String> categoriesJson = GeneratedColumn<String>(
      'categories_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _flavorsJsonMeta =
      const VerificationMeta('flavorsJson');
  @override
  late final GeneratedColumn<String> flavorsJson = GeneratedColumn<String>(
      'flavors_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        difficulty,
        cookingTime,
        servings,
        description,
        imagePath,
        isFavorite,
        createdAt,
        updatedAt,
        categoriesJson,
        flavorsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('cooking_time')) {
      context.handle(
          _cookingTimeMeta,
          cookingTime.isAcceptableOrUnknown(
              data['cooking_time']!, _cookingTimeMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('categories_json')) {
      context.handle(
          _categoriesJsonMeta,
          categoriesJson.isAcceptableOrUnknown(
              data['categories_json']!, _categoriesJsonMeta));
    }
    if (data.containsKey('flavors_json')) {
      context.handle(
          _flavorsJsonMeta,
          flavorsJson.isAcceptableOrUnknown(
              data['flavors_json']!, _flavorsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}difficulty']),
      cookingTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cooking_time']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      categoriesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categories_json']),
      flavorsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flavors_json']),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class RecipeData extends DataClass implements Insertable<RecipeData> {
  final String id;
  final String name;
  final int? difficulty;
  final int? cookingTime;
  final int? servings;
  final String? description;
  final String? imagePath;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? categoriesJson;
  final String? flavorsJson;
  const RecipeData(
      {required this.id,
      required this.name,
      this.difficulty,
      this.cookingTime,
      this.servings,
      this.description,
      this.imagePath,
      required this.isFavorite,
      this.createdAt,
      this.updatedAt,
      this.categoriesJson,
      this.flavorsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<int>(difficulty);
    }
    if (!nullToAbsent || cookingTime != null) {
      map['cooking_time'] = Variable<int>(cookingTime);
    }
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || categoriesJson != null) {
      map['categories_json'] = Variable<String>(categoriesJson);
    }
    if (!nullToAbsent || flavorsJson != null) {
      map['flavors_json'] = Variable<String>(flavorsJson);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      cookingTime: cookingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(cookingTime),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isFavorite: Value(isFavorite),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      categoriesJson: categoriesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriesJson),
      flavorsJson: flavorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorsJson),
    );
  }

  factory RecipeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      difficulty: serializer.fromJson<int?>(json['difficulty']),
      cookingTime: serializer.fromJson<int?>(json['cookingTime']),
      servings: serializer.fromJson<int?>(json['servings']),
      description: serializer.fromJson<String?>(json['description']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      categoriesJson: serializer.fromJson<String?>(json['categoriesJson']),
      flavorsJson: serializer.fromJson<String?>(json['flavorsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'difficulty': serializer.toJson<int?>(difficulty),
      'cookingTime': serializer.toJson<int?>(cookingTime),
      'servings': serializer.toJson<int?>(servings),
      'description': serializer.toJson<String?>(description),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'categoriesJson': serializer.toJson<String?>(categoriesJson),
      'flavorsJson': serializer.toJson<String?>(flavorsJson),
    };
  }

  RecipeData copyWith(
          {String? id,
          String? name,
          Value<int?> difficulty = const Value.absent(),
          Value<int?> cookingTime = const Value.absent(),
          Value<int?> servings = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          bool? isFavorite,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> categoriesJson = const Value.absent(),
          Value<String?> flavorsJson = const Value.absent()}) =>
      RecipeData(
        id: id ?? this.id,
        name: name ?? this.name,
        difficulty: difficulty.present ? difficulty.value : this.difficulty,
        cookingTime: cookingTime.present ? cookingTime.value : this.cookingTime,
        servings: servings.present ? servings.value : this.servings,
        description: description.present ? description.value : this.description,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        categoriesJson:
            categoriesJson.present ? categoriesJson.value : this.categoriesJson,
        flavorsJson: flavorsJson.present ? flavorsJson.value : this.flavorsJson,
      );
  RecipeData copyWithCompanion(RecipesCompanion data) {
    return RecipeData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      cookingTime:
          data.cookingTime.present ? data.cookingTime.value : this.cookingTime,
      servings: data.servings.present ? data.servings.value : this.servings,
      description:
          data.description.present ? data.description.value : this.description,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      categoriesJson: data.categoriesJson.present
          ? data.categoriesJson.value
          : this.categoriesJson,
      flavorsJson:
          data.flavorsJson.present ? data.flavorsJson.value : this.flavorsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('difficulty: $difficulty, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('servings: $servings, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoriesJson: $categoriesJson, ')
          ..write('flavorsJson: $flavorsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      difficulty,
      cookingTime,
      servings,
      description,
      imagePath,
      isFavorite,
      createdAt,
      updatedAt,
      categoriesJson,
      flavorsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeData &&
          other.id == this.id &&
          other.name == this.name &&
          other.difficulty == this.difficulty &&
          other.cookingTime == this.cookingTime &&
          other.servings == this.servings &&
          other.description == this.description &&
          other.imagePath == this.imagePath &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.categoriesJson == this.categoriesJson &&
          other.flavorsJson == this.flavorsJson);
}

class RecipesCompanion extends UpdateCompanion<RecipeData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> difficulty;
  final Value<int?> cookingTime;
  final Value<int?> servings;
  final Value<String?> description;
  final Value<String?> imagePath;
  final Value<bool> isFavorite;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> categoriesJson;
  final Value<String?> flavorsJson;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.cookingTime = const Value.absent(),
    this.servings = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categoriesJson = const Value.absent(),
    this.flavorsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String name,
    this.difficulty = const Value.absent(),
    this.cookingTime = const Value.absent(),
    this.servings = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categoriesJson = const Value.absent(),
    this.flavorsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<RecipeData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? difficulty,
    Expression<int>? cookingTime,
    Expression<int>? servings,
    Expression<String>? description,
    Expression<String>? imagePath,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? categoriesJson,
    Expression<String>? flavorsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (difficulty != null) 'difficulty': difficulty,
      if (cookingTime != null) 'cooking_time': cookingTime,
      if (servings != null) 'servings': servings,
      if (description != null) 'description': description,
      if (imagePath != null) 'image_path': imagePath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (categoriesJson != null) 'categories_json': categoriesJson,
      if (flavorsJson != null) 'flavors_json': flavorsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? difficulty,
      Value<int?>? cookingTime,
      Value<int?>? servings,
      Value<String?>? description,
      Value<String?>? imagePath,
      Value<bool>? isFavorite,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? categoriesJson,
      Value<String?>? flavorsJson,
      Value<int>? rowid}) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoriesJson: categoriesJson ?? this.categoriesJson,
      flavorsJson: flavorsJson ?? this.flavorsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (cookingTime.present) {
      map['cooking_time'] = Variable<int>(cookingTime.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (categoriesJson.present) {
      map['categories_json'] = Variable<String>(categoriesJson.value);
    }
    if (flavorsJson.present) {
      map['flavors_json'] = Variable<String>(flavorsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('difficulty: $difficulty, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('servings: $servings, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoriesJson: $categoriesJson, ')
          ..write('flavorsJson: $flavorsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, IngredientData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, name, amount, unit, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<IngredientData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class IngredientData extends DataClass implements Insertable<IngredientData> {
  final int id;
  final String recipeId;
  final String name;
  final double? amount;
  final String? unit;
  final String? note;
  const IngredientData(
      {required this.id,
      required this.recipeId,
      required this.name,
      this.amount,
      this.unit,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory IngredientData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientData(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
    };
  }

  IngredientData copyWith(
          {int? id,
          String? recipeId,
          String? name,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      IngredientData(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        note: note.present ? note.value : this.note,
      );
  IngredientData copyWithCompanion(IngredientsCompanion data) {
    return IngredientData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, name, amount, unit, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.note == this.note);
}

class IngredientsCompanion extends UpdateCompanion<IngredientData> {
  final Value<int> id;
  final Value<String> recipeId;
  final Value<String> name;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> note;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String recipeId,
    required String name,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
  })  : recipeId = Value(recipeId),
        name = Value(name);
  static Insertable<IngredientData> custom({
    Expression<int>? id,
    Expression<String>? recipeId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recipeId,
      Value<String>? name,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? note}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $SeasoningsTable extends Seasonings
    with TableInfo<$SeasoningsTable, SeasoningData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasoningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, name, amount, unit, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seasonings';
  @override
  VerificationContext validateIntegrity(Insertable<SeasoningData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeasoningData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeasoningData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $SeasoningsTable createAlias(String alias) {
    return $SeasoningsTable(attachedDatabase, alias);
  }
}

class SeasoningData extends DataClass implements Insertable<SeasoningData> {
  final int id;
  final String recipeId;
  final String name;
  final double? amount;
  final String? unit;
  final String? note;
  const SeasoningData(
      {required this.id,
      required this.recipeId,
      required this.name,
      this.amount,
      this.unit,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SeasoningsCompanion toCompanion(bool nullToAbsent) {
    return SeasoningsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SeasoningData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeasoningData(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
    };
  }

  SeasoningData copyWith(
          {int? id,
          String? recipeId,
          String? name,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      SeasoningData(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        note: note.present ? note.value : this.note,
      );
  SeasoningData copyWithCompanion(SeasoningsCompanion data) {
    return SeasoningData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeasoningData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, name, amount, unit, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeasoningData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.note == this.note);
}

class SeasoningsCompanion extends UpdateCompanion<SeasoningData> {
  final Value<int> id;
  final Value<String> recipeId;
  final Value<String> name;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> note;
  const SeasoningsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
  });
  SeasoningsCompanion.insert({
    this.id = const Value.absent(),
    required String recipeId,
    required String name,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
  })  : recipeId = Value(recipeId),
        name = Value(name);
  static Insertable<SeasoningData> custom({
    Expression<int>? id,
    Expression<String>? recipeId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
    });
  }

  SeasoningsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recipeId,
      Value<String>? name,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? note}) {
    return SeasoningsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasoningsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStepData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stepNumberMeta =
      const VerificationMeta('stepNumber');
  @override
  late final GeneratedColumn<int> stepNumber = GeneratedColumn<int>(
      'step_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, stepNumber, description, imagePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeStepData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('step_number')) {
      context.handle(
          _stepNumberMeta,
          stepNumber.isAcceptableOrUnknown(
              data['step_number']!, _stepNumberMeta));
    } else if (isInserting) {
      context.missing(_stepNumberMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStepData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStepData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      stepNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_number'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStepData extends DataClass implements Insertable<RecipeStepData> {
  final int id;
  final String recipeId;
  final int stepNumber;
  final String description;
  final String? imagePath;
  const RecipeStepData(
      {required this.id,
      required this.recipeId,
      required this.stepNumber,
      required this.description,
      this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['step_number'] = Variable<int>(stepNumber);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      stepNumber: Value(stepNumber),
      description: Value(description),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory RecipeStepData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStepData(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      stepNumber: serializer.fromJson<int>(json['stepNumber']),
      description: serializer.fromJson<String>(json['description']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'stepNumber': serializer.toJson<int>(stepNumber),
      'description': serializer.toJson<String>(description),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  RecipeStepData copyWith(
          {int? id,
          String? recipeId,
          int? stepNumber,
          String? description,
          Value<String?> imagePath = const Value.absent()}) =>
      RecipeStepData(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        stepNumber: stepNumber ?? this.stepNumber,
        description: description ?? this.description,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
      );
  RecipeStepData copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStepData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      stepNumber:
          data.stepNumber.present ? data.stepNumber.value : this.stepNumber,
      description:
          data.description.present ? data.description.value : this.description,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, stepNumber, description, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStepData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.stepNumber == this.stepNumber &&
          other.description == this.description &&
          other.imagePath == this.imagePath);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStepData> {
  final Value<int> id;
  final Value<String> recipeId;
  final Value<int> stepNumber;
  final Value<String> description;
  final Value<String?> imagePath;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.stepNumber = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    required String recipeId,
    required int stepNumber,
    required String description,
    this.imagePath = const Value.absent(),
  })  : recipeId = Value(recipeId),
        stepNumber = Value(stepNumber),
        description = Value(description);
  static Insertable<RecipeStepData> custom({
    Expression<int>? id,
    Expression<String>? recipeId,
    Expression<int>? stepNumber,
    Expression<String>? description,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (stepNumber != null) 'step_number': stepNumber,
      if (description != null) 'description': description,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  RecipeStepsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recipeId,
      Value<int>? stepNumber,
      Value<String>? description,
      Value<String?>? imagePath}) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      stepNumber: stepNumber ?? this.stepNumber,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (stepNumber.present) {
      map['step_number'] = Variable<int>(stepNumber.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $PoolsTable extends Pools with TableInfo<$PoolsTable, PoolData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pools';
  @override
  VerificationContext validateIntegrity(Insertable<PoolData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PoolData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoolData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PoolsTable createAlias(String alias) {
    return $PoolsTable(attachedDatabase, alias);
  }
}

class PoolData extends DataClass implements Insertable<PoolData> {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const PoolData(
      {required this.id,
      required this.name,
      this.description,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PoolsCompanion toCompanion(bool nullToAbsent) {
    return PoolsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PoolData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoolData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PoolData copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PoolData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  PoolData copyWithCompanion(PoolsCompanion data) {
    return PoolData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoolData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PoolsCompanion extends UpdateCompanion<PoolData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const PoolsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PoolsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<PoolData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PoolsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return PoolsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoolsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PoolRecipesTable extends PoolRecipes
    with TableInfo<$PoolRecipesTable, PoolRecipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoolRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _poolIdMeta = const VerificationMeta('poolId');
  @override
  late final GeneratedColumn<String> poolId = GeneratedColumn<String>(
      'pool_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [poolId, recipeId, weight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pool_recipes';
  @override
  VerificationContext validateIntegrity(Insertable<PoolRecipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pool_id')) {
      context.handle(_poolIdMeta,
          poolId.isAcceptableOrUnknown(data['pool_id']!, _poolIdMeta));
    } else if (isInserting) {
      context.missing(_poolIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {poolId, recipeId};
  @override
  PoolRecipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoolRecipe(
      poolId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pool_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
    );
  }

  @override
  $PoolRecipesTable createAlias(String alias) {
    return $PoolRecipesTable(attachedDatabase, alias);
  }
}

class PoolRecipe extends DataClass implements Insertable<PoolRecipe> {
  final String poolId;
  final String recipeId;
  final double? weight;
  const PoolRecipe({required this.poolId, required this.recipeId, this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pool_id'] = Variable<String>(poolId);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    return map;
  }

  PoolRecipesCompanion toCompanion(bool nullToAbsent) {
    return PoolRecipesCompanion(
      poolId: Value(poolId),
      recipeId: Value(recipeId),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
    );
  }

  factory PoolRecipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoolRecipe(
      poolId: serializer.fromJson<String>(json['poolId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      weight: serializer.fromJson<double?>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'poolId': serializer.toJson<String>(poolId),
      'recipeId': serializer.toJson<String>(recipeId),
      'weight': serializer.toJson<double?>(weight),
    };
  }

  PoolRecipe copyWith(
          {String? poolId,
          String? recipeId,
          Value<double?> weight = const Value.absent()}) =>
      PoolRecipe(
        poolId: poolId ?? this.poolId,
        recipeId: recipeId ?? this.recipeId,
        weight: weight.present ? weight.value : this.weight,
      );
  PoolRecipe copyWithCompanion(PoolRecipesCompanion data) {
    return PoolRecipe(
      poolId: data.poolId.present ? data.poolId.value : this.poolId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoolRecipe(')
          ..write('poolId: $poolId, ')
          ..write('recipeId: $recipeId, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(poolId, recipeId, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolRecipe &&
          other.poolId == this.poolId &&
          other.recipeId == this.recipeId &&
          other.weight == this.weight);
}

class PoolRecipesCompanion extends UpdateCompanion<PoolRecipe> {
  final Value<String> poolId;
  final Value<String> recipeId;
  final Value<double?> weight;
  final Value<int> rowid;
  const PoolRecipesCompanion({
    this.poolId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PoolRecipesCompanion.insert({
    required String poolId,
    required String recipeId,
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : poolId = Value(poolId),
        recipeId = Value(recipeId);
  static Insertable<PoolRecipe> custom({
    Expression<String>? poolId,
    Expression<String>? recipeId,
    Expression<double>? weight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poolId != null) 'pool_id': poolId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (weight != null) 'weight': weight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PoolRecipesCompanion copyWith(
      {Value<String>? poolId,
      Value<String>? recipeId,
      Value<double?>? weight,
      Value<int>? rowid}) {
    return PoolRecipesCompanion(
      poolId: poolId ?? this.poolId,
      recipeId: recipeId ?? this.recipeId,
      weight: weight ?? this.weight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (poolId.present) {
      map['pool_id'] = Variable<String>(poolId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoolRecipesCompanion(')
          ..write('poolId: $poolId, ')
          ..write('recipeId: $recipeId, ')
          ..write('weight: $weight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DrawHistoriesTable extends DrawHistories
    with TableInfo<$DrawHistoriesTable, DrawHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrawHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _poolIdMeta = const VerificationMeta('poolId');
  @override
  late final GeneratedColumn<String> poolId = GeneratedColumn<String>(
      'pool_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _drawTimeMeta =
      const VerificationMeta('drawTime');
  @override
  late final GeneratedColumn<DateTime> drawTime = GeneratedColumn<DateTime>(
      'draw_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, poolId, recipeId, drawTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draw_histories';
  @override
  VerificationContext validateIntegrity(Insertable<DrawHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pool_id')) {
      context.handle(_poolIdMeta,
          poolId.isAcceptableOrUnknown(data['pool_id']!, _poolIdMeta));
    } else if (isInserting) {
      context.missing(_poolIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('draw_time')) {
      context.handle(_drawTimeMeta,
          drawTime.isAcceptableOrUnknown(data['draw_time']!, _drawTimeMeta));
    } else if (isInserting) {
      context.missing(_drawTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrawHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrawHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      poolId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pool_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      drawTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}draw_time'])!,
    );
  }

  @override
  $DrawHistoriesTable createAlias(String alias) {
    return $DrawHistoriesTable(attachedDatabase, alias);
  }
}

class DrawHistoryData extends DataClass implements Insertable<DrawHistoryData> {
  final int id;
  final String poolId;
  final String recipeId;
  final DateTime drawTime;
  const DrawHistoryData(
      {required this.id,
      required this.poolId,
      required this.recipeId,
      required this.drawTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pool_id'] = Variable<String>(poolId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['draw_time'] = Variable<DateTime>(drawTime);
    return map;
  }

  DrawHistoriesCompanion toCompanion(bool nullToAbsent) {
    return DrawHistoriesCompanion(
      id: Value(id),
      poolId: Value(poolId),
      recipeId: Value(recipeId),
      drawTime: Value(drawTime),
    );
  }

  factory DrawHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrawHistoryData(
      id: serializer.fromJson<int>(json['id']),
      poolId: serializer.fromJson<String>(json['poolId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      drawTime: serializer.fromJson<DateTime>(json['drawTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'poolId': serializer.toJson<String>(poolId),
      'recipeId': serializer.toJson<String>(recipeId),
      'drawTime': serializer.toJson<DateTime>(drawTime),
    };
  }

  DrawHistoryData copyWith(
          {int? id, String? poolId, String? recipeId, DateTime? drawTime}) =>
      DrawHistoryData(
        id: id ?? this.id,
        poolId: poolId ?? this.poolId,
        recipeId: recipeId ?? this.recipeId,
        drawTime: drawTime ?? this.drawTime,
      );
  DrawHistoryData copyWithCompanion(DrawHistoriesCompanion data) {
    return DrawHistoryData(
      id: data.id.present ? data.id.value : this.id,
      poolId: data.poolId.present ? data.poolId.value : this.poolId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      drawTime: data.drawTime.present ? data.drawTime.value : this.drawTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrawHistoryData(')
          ..write('id: $id, ')
          ..write('poolId: $poolId, ')
          ..write('recipeId: $recipeId, ')
          ..write('drawTime: $drawTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, poolId, recipeId, drawTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrawHistoryData &&
          other.id == this.id &&
          other.poolId == this.poolId &&
          other.recipeId == this.recipeId &&
          other.drawTime == this.drawTime);
}

class DrawHistoriesCompanion extends UpdateCompanion<DrawHistoryData> {
  final Value<int> id;
  final Value<String> poolId;
  final Value<String> recipeId;
  final Value<DateTime> drawTime;
  const DrawHistoriesCompanion({
    this.id = const Value.absent(),
    this.poolId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.drawTime = const Value.absent(),
  });
  DrawHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required String poolId,
    required String recipeId,
    required DateTime drawTime,
  })  : poolId = Value(poolId),
        recipeId = Value(recipeId),
        drawTime = Value(drawTime);
  static Insertable<DrawHistoryData> custom({
    Expression<int>? id,
    Expression<String>? poolId,
    Expression<String>? recipeId,
    Expression<DateTime>? drawTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poolId != null) 'pool_id': poolId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (drawTime != null) 'draw_time': drawTime,
    });
  }

  DrawHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? poolId,
      Value<String>? recipeId,
      Value<DateTime>? drawTime}) {
    return DrawHistoriesCompanion(
      id: id ?? this.id,
      poolId: poolId ?? this.poolId,
      recipeId: recipeId ?? this.recipeId,
      drawTime: drawTime ?? this.drawTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (poolId.present) {
      map['pool_id'] = Variable<String>(poolId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (drawTime.present) {
      map['draw_time'] = Variable<DateTime>(drawTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('poolId: $poolId, ')
          ..write('recipeId: $recipeId, ')
          ..write('drawTime: $drawTime')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _soundEnabledMeta =
      const VerificationMeta('soundEnabled');
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
      'sound_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sound_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _animationEnabledMeta =
      const VerificationMeta('animationEnabled');
  @override
  late final GeneratedColumn<bool> animationEnabled = GeneratedColumn<bool>(
      'animation_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("animation_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _excludeRecentCountMeta =
      const VerificationMeta('excludeRecentCount');
  @override
  late final GeneratedColumn<int> excludeRecentCount = GeneratedColumn<int>(
      'exclude_recent_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _luckyStarEnabledMeta =
      const VerificationMeta('luckyStarEnabled');
  @override
  late final GeneratedColumn<bool> luckyStarEnabled = GeneratedColumn<bool>(
      'lucky_star_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("lucky_star_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        soundEnabled,
        animationEnabled,
        excludeRecentCount,
        theme,
        luckyStarEnabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
          _soundEnabledMeta,
          soundEnabled.isAcceptableOrUnknown(
              data['sound_enabled']!, _soundEnabledMeta));
    }
    if (data.containsKey('animation_enabled')) {
      context.handle(
          _animationEnabledMeta,
          animationEnabled.isAcceptableOrUnknown(
              data['animation_enabled']!, _animationEnabledMeta));
    }
    if (data.containsKey('exclude_recent_count')) {
      context.handle(
          _excludeRecentCountMeta,
          excludeRecentCount.isAcceptableOrUnknown(
              data['exclude_recent_count']!, _excludeRecentCountMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('lucky_star_enabled')) {
      context.handle(
          _luckyStarEnabledMeta,
          luckyStarEnabled.isAcceptableOrUnknown(
              data['lucky_star_enabled']!, _luckyStarEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      soundEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sound_enabled'])!,
      animationEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}animation_enabled'])!,
      excludeRecentCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}exclude_recent_count'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      luckyStarEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}lucky_star_enabled'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingsData extends DataClass implements Insertable<SettingsData> {
  final int id;
  final bool soundEnabled;
  final bool animationEnabled;
  final int excludeRecentCount;
  final String theme;
  final bool luckyStarEnabled;
  const SettingsData(
      {required this.id,
      required this.soundEnabled,
      required this.animationEnabled,
      required this.excludeRecentCount,
      required this.theme,
      required this.luckyStarEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['animation_enabled'] = Variable<bool>(animationEnabled);
    map['exclude_recent_count'] = Variable<int>(excludeRecentCount);
    map['theme'] = Variable<String>(theme);
    map['lucky_star_enabled'] = Variable<bool>(luckyStarEnabled);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      soundEnabled: Value(soundEnabled),
      animationEnabled: Value(animationEnabled),
      excludeRecentCount: Value(excludeRecentCount),
      theme: Value(theme),
      luckyStarEnabled: Value(luckyStarEnabled),
    );
  }

  factory SettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsData(
      id: serializer.fromJson<int>(json['id']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      animationEnabled: serializer.fromJson<bool>(json['animationEnabled']),
      excludeRecentCount: serializer.fromJson<int>(json['excludeRecentCount']),
      theme: serializer.fromJson<String>(json['theme']),
      luckyStarEnabled: serializer.fromJson<bool>(json['luckyStarEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'animationEnabled': serializer.toJson<bool>(animationEnabled),
      'excludeRecentCount': serializer.toJson<int>(excludeRecentCount),
      'theme': serializer.toJson<String>(theme),
      'luckyStarEnabled': serializer.toJson<bool>(luckyStarEnabled),
    };
  }

  SettingsData copyWith(
          {int? id,
          bool? soundEnabled,
          bool? animationEnabled,
          int? excludeRecentCount,
          String? theme,
          bool? luckyStarEnabled}) =>
      SettingsData(
        id: id ?? this.id,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        animationEnabled: animationEnabled ?? this.animationEnabled,
        excludeRecentCount: excludeRecentCount ?? this.excludeRecentCount,
        theme: theme ?? this.theme,
        luckyStarEnabled: luckyStarEnabled ?? this.luckyStarEnabled,
      );
  SettingsData copyWithCompanion(SettingsCompanion data) {
    return SettingsData(
      id: data.id.present ? data.id.value : this.id,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      animationEnabled: data.animationEnabled.present
          ? data.animationEnabled.value
          : this.animationEnabled,
      excludeRecentCount: data.excludeRecentCount.present
          ? data.excludeRecentCount.value
          : this.excludeRecentCount,
      theme: data.theme.present ? data.theme.value : this.theme,
      luckyStarEnabled: data.luckyStarEnabled.present
          ? data.luckyStarEnabled.value
          : this.luckyStarEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsData(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('animationEnabled: $animationEnabled, ')
          ..write('excludeRecentCount: $excludeRecentCount, ')
          ..write('theme: $theme, ')
          ..write('luckyStarEnabled: $luckyStarEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, soundEnabled, animationEnabled,
      excludeRecentCount, theme, luckyStarEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsData &&
          other.id == this.id &&
          other.soundEnabled == this.soundEnabled &&
          other.animationEnabled == this.animationEnabled &&
          other.excludeRecentCount == this.excludeRecentCount &&
          other.theme == this.theme &&
          other.luckyStarEnabled == this.luckyStarEnabled);
}

class SettingsCompanion extends UpdateCompanion<SettingsData> {
  final Value<int> id;
  final Value<bool> soundEnabled;
  final Value<bool> animationEnabled;
  final Value<int> excludeRecentCount;
  final Value<String> theme;
  final Value<bool> luckyStarEnabled;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.animationEnabled = const Value.absent(),
    this.excludeRecentCount = const Value.absent(),
    this.theme = const Value.absent(),
    this.luckyStarEnabled = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.animationEnabled = const Value.absent(),
    this.excludeRecentCount = const Value.absent(),
    this.theme = const Value.absent(),
    this.luckyStarEnabled = const Value.absent(),
  });
  static Insertable<SettingsData> custom({
    Expression<int>? id,
    Expression<bool>? soundEnabled,
    Expression<bool>? animationEnabled,
    Expression<int>? excludeRecentCount,
    Expression<String>? theme,
    Expression<bool>? luckyStarEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (animationEnabled != null) 'animation_enabled': animationEnabled,
      if (excludeRecentCount != null)
        'exclude_recent_count': excludeRecentCount,
      if (theme != null) 'theme': theme,
      if (luckyStarEnabled != null) 'lucky_star_enabled': luckyStarEnabled,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? soundEnabled,
      Value<bool>? animationEnabled,
      Value<int>? excludeRecentCount,
      Value<String>? theme,
      Value<bool>? luckyStarEnabled}) {
    return SettingsCompanion(
      id: id ?? this.id,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationEnabled: animationEnabled ?? this.animationEnabled,
      excludeRecentCount: excludeRecentCount ?? this.excludeRecentCount,
      theme: theme ?? this.theme,
      luckyStarEnabled: luckyStarEnabled ?? this.luckyStarEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (animationEnabled.present) {
      map['animation_enabled'] = Variable<bool>(animationEnabled.value);
    }
    if (excludeRecentCount.present) {
      map['exclude_recent_count'] = Variable<int>(excludeRecentCount.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (luckyStarEnabled.present) {
      map['lucky_star_enabled'] = Variable<bool>(luckyStarEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('animationEnabled: $animationEnabled, ')
          ..write('excludeRecentCount: $excludeRecentCount, ')
          ..write('theme: $theme, ')
          ..write('luckyStarEnabled: $luckyStarEnabled')
          ..write(')'))
        .toString();
  }
}

class $CookingRecordsTable extends CookingRecords
    with TableInfo<$CookingRecordsTable, CookingRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordDateMeta =
      const VerificationMeta('recordDate');
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
      'record_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, recordDate, createdAt, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_records';
  @override
  VerificationContext validateIntegrity(Insertable<CookingRecordData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_date')) {
      context.handle(
          _recordDateMeta,
          recordDate.isAcceptableOrUnknown(
              data['record_date']!, _recordDateMeta));
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingRecordData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}record_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $CookingRecordsTable createAlias(String alias) {
    return $CookingRecordsTable(attachedDatabase, alias);
  }
}

class CookingRecordData extends DataClass
    implements Insertable<CookingRecordData> {
  final int id;
  final DateTime recordDate;
  final DateTime? createdAt;
  final String? note;
  const CookingRecordData(
      {required this.id, required this.recordDate, this.createdAt, this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_date'] = Variable<DateTime>(recordDate);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CookingRecordsCompanion toCompanion(bool nullToAbsent) {
    return CookingRecordsCompanion(
      id: Value(id),
      recordDate: Value(recordDate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CookingRecordData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingRecordData(
      id: serializer.fromJson<int>(json['id']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  CookingRecordData copyWith(
          {int? id,
          DateTime? recordDate,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      CookingRecordData(
        id: id ?? this.id,
        recordDate: recordDate ?? this.recordDate,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        note: note.present ? note.value : this.note,
      );
  CookingRecordData copyWithCompanion(CookingRecordsCompanion data) {
    return CookingRecordData(
      id: data.id.present ? data.id.value : this.id,
      recordDate:
          data.recordDate.present ? data.recordDate.value : this.recordDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingRecordData(')
          ..write('id: $id, ')
          ..write('recordDate: $recordDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordDate, createdAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingRecordData &&
          other.id == this.id &&
          other.recordDate == this.recordDate &&
          other.createdAt == this.createdAt &&
          other.note == this.note);
}

class CookingRecordsCompanion extends UpdateCompanion<CookingRecordData> {
  final Value<int> id;
  final Value<DateTime> recordDate;
  final Value<DateTime?> createdAt;
  final Value<String?> note;
  const CookingRecordsCompanion({
    this.id = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  CookingRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordDate,
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
  }) : recordDate = Value(recordDate);
  static Insertable<CookingRecordData> custom({
    Expression<int>? id,
    Expression<DateTime>? recordDate,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordDate != null) 'record_date': recordDate,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
    });
  }

  CookingRecordsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? recordDate,
      Value<DateTime?>? createdAt,
      Value<String?>? note}) {
    return CookingRecordsCompanion(
      id: id ?? this.id,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('recordDate: $recordDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CookingRecordItemsTable extends CookingRecordItems
    with TableInfo<$CookingRecordItemsTable, CookingRecordItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingRecordItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dishNameMeta =
      const VerificationMeta('dishName');
  @override
  late final GeneratedColumn<String> dishName = GeneratedColumn<String>(
      'dish_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordId, dishName, price, note, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_record_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<CookingRecordItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('dish_name')) {
      context.handle(_dishNameMeta,
          dishName.isAcceptableOrUnknown(data['dish_name']!, _dishNameMeta));
    } else if (isInserting) {
      context.missing(_dishNameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingRecordItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingRecordItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id'])!,
      dishName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dish_name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $CookingRecordItemsTable createAlias(String alias) {
    return $CookingRecordItemsTable(attachedDatabase, alias);
  }
}

class CookingRecordItemData extends DataClass
    implements Insertable<CookingRecordItemData> {
  final int id;
  final int recordId;
  final String dishName;
  final double? price;
  final String? note;
  final String? category;
  const CookingRecordItemData(
      {required this.id,
      required this.recordId,
      required this.dishName,
      this.price,
      this.note,
      this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    map['dish_name'] = Variable<String>(dishName);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  CookingRecordItemsCompanion toCompanion(bool nullToAbsent) {
    return CookingRecordItemsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      dishName: Value(dishName),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory CookingRecordItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingRecordItemData(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      dishName: serializer.fromJson<String>(json['dishName']),
      price: serializer.fromJson<double?>(json['price']),
      note: serializer.fromJson<String?>(json['note']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'dishName': serializer.toJson<String>(dishName),
      'price': serializer.toJson<double?>(price),
      'note': serializer.toJson<String?>(note),
      'category': serializer.toJson<String?>(category),
    };
  }

  CookingRecordItemData copyWith(
          {int? id,
          int? recordId,
          String? dishName,
          Value<double?> price = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<String?> category = const Value.absent()}) =>
      CookingRecordItemData(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        dishName: dishName ?? this.dishName,
        price: price.present ? price.value : this.price,
        note: note.present ? note.value : this.note,
        category: category.present ? category.value : this.category,
      );
  CookingRecordItemData copyWithCompanion(CookingRecordItemsCompanion data) {
    return CookingRecordItemData(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      dishName: data.dishName.present ? data.dishName.value : this.dishName,
      price: data.price.present ? data.price.value : this.price,
      note: data.note.present ? data.note.value : this.note,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingRecordItemData(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('dishName: $dishName, ')
          ..write('price: $price, ')
          ..write('note: $note, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, dishName, price, note, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingRecordItemData &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.dishName == this.dishName &&
          other.price == this.price &&
          other.note == this.note &&
          other.category == this.category);
}

class CookingRecordItemsCompanion
    extends UpdateCompanion<CookingRecordItemData> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<String> dishName;
  final Value<double?> price;
  final Value<String?> note;
  final Value<String?> category;
  const CookingRecordItemsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.dishName = const Value.absent(),
    this.price = const Value.absent(),
    this.note = const Value.absent(),
    this.category = const Value.absent(),
  });
  CookingRecordItemsCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required String dishName,
    this.price = const Value.absent(),
    this.note = const Value.absent(),
    this.category = const Value.absent(),
  })  : recordId = Value(recordId),
        dishName = Value(dishName);
  static Insertable<CookingRecordItemData> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<String>? dishName,
    Expression<double>? price,
    Expression<String>? note,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (dishName != null) 'dish_name': dishName,
      if (price != null) 'price': price,
      if (note != null) 'note': note,
      if (category != null) 'category': category,
    });
  }

  CookingRecordItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recordId,
      Value<String>? dishName,
      Value<double?>? price,
      Value<String?>? note,
      Value<String?>? category}) {
    return CookingRecordItemsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      dishName: dishName ?? this.dishName,
      price: price ?? this.price,
      note: note ?? this.note,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (dishName.present) {
      map['dish_name'] = Variable<String>(dishName.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingRecordItemsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('dishName: $dishName, ')
          ..write('price: $price, ')
          ..write('note: $note, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $CookingTemplatesTable extends CookingTemplates
    with TableInfo<$CookingTemplatesTable, CookingTemplateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, itemsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_templates';
  @override
  VerificationContext validateIntegrity(
      Insertable<CookingTemplateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingTemplateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingTemplateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json']),
    );
  }

  @override
  $CookingTemplatesTable createAlias(String alias) {
    return $CookingTemplatesTable(attachedDatabase, alias);
  }
}

class CookingTemplateData extends DataClass
    implements Insertable<CookingTemplateData> {
  final int id;
  final String name;
  final String? itemsJson;
  const CookingTemplateData(
      {required this.id, required this.name, this.itemsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || itemsJson != null) {
      map['items_json'] = Variable<String>(itemsJson);
    }
    return map;
  }

  CookingTemplatesCompanion toCompanion(bool nullToAbsent) {
    return CookingTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      itemsJson: itemsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(itemsJson),
    );
  }

  factory CookingTemplateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingTemplateData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      itemsJson: serializer.fromJson<String?>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'itemsJson': serializer.toJson<String?>(itemsJson),
    };
  }

  CookingTemplateData copyWith(
          {int? id,
          String? name,
          Value<String?> itemsJson = const Value.absent()}) =>
      CookingTemplateData(
        id: id ?? this.id,
        name: name ?? this.name,
        itemsJson: itemsJson.present ? itemsJson.value : this.itemsJson,
      );
  CookingTemplateData copyWithCompanion(CookingTemplatesCompanion data) {
    return CookingTemplateData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingTemplateData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, itemsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingTemplateData &&
          other.id == this.id &&
          other.name == this.name &&
          other.itemsJson == this.itemsJson);
}

class CookingTemplatesCompanion extends UpdateCompanion<CookingTemplateData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> itemsJson;
  const CookingTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.itemsJson = const Value.absent(),
  });
  CookingTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.itemsJson = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CookingTemplateData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? itemsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (itemsJson != null) 'items_json': itemsJson,
    });
  }

  CookingTemplatesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String?>? itemsJson}) {
    return CookingTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      itemsJson: itemsJson ?? this.itemsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $SeasoningsTable seasonings = $SeasoningsTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $PoolsTable pools = $PoolsTable(this);
  late final $PoolRecipesTable poolRecipes = $PoolRecipesTable(this);
  late final $DrawHistoriesTable drawHistories = $DrawHistoriesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $CookingRecordsTable cookingRecords = $CookingRecordsTable(this);
  late final $CookingRecordItemsTable cookingRecordItems =
      $CookingRecordItemsTable(this);
  late final $CookingTemplatesTable cookingTemplates =
      $CookingTemplatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        recipes,
        ingredients,
        seasonings,
        recipeSteps,
        pools,
        poolRecipes,
        drawHistories,
        settings,
        cookingRecords,
        cookingRecordItems,
        cookingTemplates
      ];
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  required String id,
  required String name,
  Value<int?> difficulty,
  Value<int?> cookingTime,
  Value<int?> servings,
  Value<String?> description,
  Value<String?> imagePath,
  Value<bool> isFavorite,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> categoriesJson,
  Value<String?> flavorsJson,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> difficulty,
  Value<int?> cookingTime,
  Value<int?> servings,
  Value<String?> description,
  Value<String?> imagePath,
  Value<bool> isFavorite,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> categoriesJson,
  Value<String?> flavorsJson,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flavorsJson => $composableBuilder(
      column: $table.flavorsJson, builder: (column) => ColumnFilters(column));
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flavorsJson => $composableBuilder(
      column: $table.flavorsJson, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson, builder: (column) => column);

  GeneratedColumn<String> get flavorsJson => $composableBuilder(
      column: $table.flavorsJson, builder: (column) => column);
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeData,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeData, BaseReferences<_$AppDatabase, $RecipesTable, RecipeData>),
    RecipeData,
    PrefetchHooks Function()> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> difficulty = const Value.absent(),
            Value<int?> cookingTime = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> categoriesJson = const Value.absent(),
            Value<String?> flavorsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            name: name,
            difficulty: difficulty,
            cookingTime: cookingTime,
            servings: servings,
            description: description,
            imagePath: imagePath,
            isFavorite: isFavorite,
            createdAt: createdAt,
            updatedAt: updatedAt,
            categoriesJson: categoriesJson,
            flavorsJson: flavorsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> difficulty = const Value.absent(),
            Value<int?> cookingTime = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> categoriesJson = const Value.absent(),
            Value<String?> flavorsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            name: name,
            difficulty: difficulty,
            cookingTime: cookingTime,
            servings: servings,
            description: description,
            imagePath: imagePath,
            isFavorite: isFavorite,
            createdAt: createdAt,
            updatedAt: updatedAt,
            categoriesJson: categoriesJson,
            flavorsJson: flavorsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeData,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeData, BaseReferences<_$AppDatabase, $RecipesTable, RecipeData>),
    RecipeData,
    PrefetchHooks Function()>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String recipeId,
  required String name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> recipeId,
  Value<String> name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
});

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientData,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (
      IngredientData,
      BaseReferences<_$AppDatabase, $IngredientsTable, IngredientData>
    ),
    IngredientData,
    PrefetchHooks Function()> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            recipeId: recipeId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recipeId,
            required String name,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            recipeId: recipeId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientData,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (
      IngredientData,
      BaseReferences<_$AppDatabase, $IngredientsTable, IngredientData>
    ),
    IngredientData,
    PrefetchHooks Function()>;
typedef $$SeasoningsTableCreateCompanionBuilder = SeasoningsCompanion Function({
  Value<int> id,
  required String recipeId,
  required String name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
});
typedef $$SeasoningsTableUpdateCompanionBuilder = SeasoningsCompanion Function({
  Value<int> id,
  Value<String> recipeId,
  Value<String> name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
});

class $$SeasoningsTableFilterComposer
    extends Composer<_$AppDatabase, $SeasoningsTable> {
  $$SeasoningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$SeasoningsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeasoningsTable> {
  $$SeasoningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$SeasoningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeasoningsTable> {
  $$SeasoningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SeasoningsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SeasoningsTable,
    SeasoningData,
    $$SeasoningsTableFilterComposer,
    $$SeasoningsTableOrderingComposer,
    $$SeasoningsTableAnnotationComposer,
    $$SeasoningsTableCreateCompanionBuilder,
    $$SeasoningsTableUpdateCompanionBuilder,
    (
      SeasoningData,
      BaseReferences<_$AppDatabase, $SeasoningsTable, SeasoningData>
    ),
    SeasoningData,
    PrefetchHooks Function()> {
  $$SeasoningsTableTableManager(_$AppDatabase db, $SeasoningsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasoningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasoningsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasoningsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              SeasoningsCompanion(
            id: id,
            recipeId: recipeId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recipeId,
            required String name,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              SeasoningsCompanion.insert(
            id: id,
            recipeId: recipeId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SeasoningsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SeasoningsTable,
    SeasoningData,
    $$SeasoningsTableFilterComposer,
    $$SeasoningsTableOrderingComposer,
    $$SeasoningsTableAnnotationComposer,
    $$SeasoningsTableCreateCompanionBuilder,
    $$SeasoningsTableUpdateCompanionBuilder,
    (
      SeasoningData,
      BaseReferences<_$AppDatabase, $SeasoningsTable, SeasoningData>
    ),
    SeasoningData,
    PrefetchHooks Function()>;
typedef $$RecipeStepsTableCreateCompanionBuilder = RecipeStepsCompanion
    Function({
  Value<int> id,
  required String recipeId,
  required int stepNumber,
  required String description,
  Value<String?> imagePath,
});
typedef $$RecipeStepsTableUpdateCompanionBuilder = RecipeStepsCompanion
    Function({
  Value<int> id,
  Value<String> recipeId,
  Value<int> stepNumber,
  Value<String> description,
  Value<String?> imagePath,
});

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$RecipeStepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeStepsTable,
    RecipeStepData,
    $$RecipeStepsTableFilterComposer,
    $$RecipeStepsTableOrderingComposer,
    $$RecipeStepsTableAnnotationComposer,
    $$RecipeStepsTableCreateCompanionBuilder,
    $$RecipeStepsTableUpdateCompanionBuilder,
    (
      RecipeStepData,
      BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStepData>
    ),
    RecipeStepData,
    PrefetchHooks Function()> {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<int> stepNumber = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
          }) =>
              RecipeStepsCompanion(
            id: id,
            recipeId: recipeId,
            stepNumber: stepNumber,
            description: description,
            imagePath: imagePath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recipeId,
            required int stepNumber,
            required String description,
            Value<String?> imagePath = const Value.absent(),
          }) =>
              RecipeStepsCompanion.insert(
            id: id,
            recipeId: recipeId,
            stepNumber: stepNumber,
            description: description,
            imagePath: imagePath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipeStepsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeStepsTable,
    RecipeStepData,
    $$RecipeStepsTableFilterComposer,
    $$RecipeStepsTableOrderingComposer,
    $$RecipeStepsTableAnnotationComposer,
    $$RecipeStepsTableCreateCompanionBuilder,
    $$RecipeStepsTableUpdateCompanionBuilder,
    (
      RecipeStepData,
      BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStepData>
    ),
    RecipeStepData,
    PrefetchHooks Function()>;
typedef $$PoolsTableCreateCompanionBuilder = PoolsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$PoolsTableUpdateCompanionBuilder = PoolsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$PoolsTableFilterComposer extends Composer<_$AppDatabase, $PoolsTable> {
  $$PoolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PoolsTableOrderingComposer
    extends Composer<_$AppDatabase, $PoolsTable> {
  $$PoolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PoolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoolsTable> {
  $$PoolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PoolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PoolsTable,
    PoolData,
    $$PoolsTableFilterComposer,
    $$PoolsTableOrderingComposer,
    $$PoolsTableAnnotationComposer,
    $$PoolsTableCreateCompanionBuilder,
    $$PoolsTableUpdateCompanionBuilder,
    (PoolData, BaseReferences<_$AppDatabase, $PoolsTable, PoolData>),
    PoolData,
    PrefetchHooks Function()> {
  $$PoolsTableTableManager(_$AppDatabase db, $PoolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PoolsCompanion(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PoolsCompanion.insert(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PoolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PoolsTable,
    PoolData,
    $$PoolsTableFilterComposer,
    $$PoolsTableOrderingComposer,
    $$PoolsTableAnnotationComposer,
    $$PoolsTableCreateCompanionBuilder,
    $$PoolsTableUpdateCompanionBuilder,
    (PoolData, BaseReferences<_$AppDatabase, $PoolsTable, PoolData>),
    PoolData,
    PrefetchHooks Function()>;
typedef $$PoolRecipesTableCreateCompanionBuilder = PoolRecipesCompanion
    Function({
  required String poolId,
  required String recipeId,
  Value<double?> weight,
  Value<int> rowid,
});
typedef $$PoolRecipesTableUpdateCompanionBuilder = PoolRecipesCompanion
    Function({
  Value<String> poolId,
  Value<String> recipeId,
  Value<double?> weight,
  Value<int> rowid,
});

class $$PoolRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $PoolRecipesTable> {
  $$PoolRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get poolId => $composableBuilder(
      column: $table.poolId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));
}

class $$PoolRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $PoolRecipesTable> {
  $$PoolRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get poolId => $composableBuilder(
      column: $table.poolId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));
}

class $$PoolRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoolRecipesTable> {
  $$PoolRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get poolId =>
      $composableBuilder(column: $table.poolId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);
}

class $$PoolRecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PoolRecipesTable,
    PoolRecipe,
    $$PoolRecipesTableFilterComposer,
    $$PoolRecipesTableOrderingComposer,
    $$PoolRecipesTableAnnotationComposer,
    $$PoolRecipesTableCreateCompanionBuilder,
    $$PoolRecipesTableUpdateCompanionBuilder,
    (PoolRecipe, BaseReferences<_$AppDatabase, $PoolRecipesTable, PoolRecipe>),
    PoolRecipe,
    PrefetchHooks Function()> {
  $$PoolRecipesTableTableManager(_$AppDatabase db, $PoolRecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoolRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoolRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoolRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> poolId = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PoolRecipesCompanion(
            poolId: poolId,
            recipeId: recipeId,
            weight: weight,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String poolId,
            required String recipeId,
            Value<double?> weight = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PoolRecipesCompanion.insert(
            poolId: poolId,
            recipeId: recipeId,
            weight: weight,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PoolRecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PoolRecipesTable,
    PoolRecipe,
    $$PoolRecipesTableFilterComposer,
    $$PoolRecipesTableOrderingComposer,
    $$PoolRecipesTableAnnotationComposer,
    $$PoolRecipesTableCreateCompanionBuilder,
    $$PoolRecipesTableUpdateCompanionBuilder,
    (PoolRecipe, BaseReferences<_$AppDatabase, $PoolRecipesTable, PoolRecipe>),
    PoolRecipe,
    PrefetchHooks Function()>;
typedef $$DrawHistoriesTableCreateCompanionBuilder = DrawHistoriesCompanion
    Function({
  Value<int> id,
  required String poolId,
  required String recipeId,
  required DateTime drawTime,
});
typedef $$DrawHistoriesTableUpdateCompanionBuilder = DrawHistoriesCompanion
    Function({
  Value<int> id,
  Value<String> poolId,
  Value<String> recipeId,
  Value<DateTime> drawTime,
});

class $$DrawHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DrawHistoriesTable> {
  $$DrawHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get poolId => $composableBuilder(
      column: $table.poolId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get drawTime => $composableBuilder(
      column: $table.drawTime, builder: (column) => ColumnFilters(column));
}

class $$DrawHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DrawHistoriesTable> {
  $$DrawHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get poolId => $composableBuilder(
      column: $table.poolId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get drawTime => $composableBuilder(
      column: $table.drawTime, builder: (column) => ColumnOrderings(column));
}

class $$DrawHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrawHistoriesTable> {
  $$DrawHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poolId =>
      $composableBuilder(column: $table.poolId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get drawTime =>
      $composableBuilder(column: $table.drawTime, builder: (column) => column);
}

class $$DrawHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DrawHistoriesTable,
    DrawHistoryData,
    $$DrawHistoriesTableFilterComposer,
    $$DrawHistoriesTableOrderingComposer,
    $$DrawHistoriesTableAnnotationComposer,
    $$DrawHistoriesTableCreateCompanionBuilder,
    $$DrawHistoriesTableUpdateCompanionBuilder,
    (
      DrawHistoryData,
      BaseReferences<_$AppDatabase, $DrawHistoriesTable, DrawHistoryData>
    ),
    DrawHistoryData,
    PrefetchHooks Function()> {
  $$DrawHistoriesTableTableManager(_$AppDatabase db, $DrawHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrawHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrawHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrawHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> poolId = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<DateTime> drawTime = const Value.absent(),
          }) =>
              DrawHistoriesCompanion(
            id: id,
            poolId: poolId,
            recipeId: recipeId,
            drawTime: drawTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String poolId,
            required String recipeId,
            required DateTime drawTime,
          }) =>
              DrawHistoriesCompanion.insert(
            id: id,
            poolId: poolId,
            recipeId: recipeId,
            drawTime: drawTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DrawHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DrawHistoriesTable,
    DrawHistoryData,
    $$DrawHistoriesTableFilterComposer,
    $$DrawHistoriesTableOrderingComposer,
    $$DrawHistoriesTableAnnotationComposer,
    $$DrawHistoriesTableCreateCompanionBuilder,
    $$DrawHistoriesTableUpdateCompanionBuilder,
    (
      DrawHistoryData,
      BaseReferences<_$AppDatabase, $DrawHistoriesTable, DrawHistoryData>
    ),
    DrawHistoryData,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> soundEnabled,
  Value<bool> animationEnabled,
  Value<int> excludeRecentCount,
  Value<String> theme,
  Value<bool> luckyStarEnabled,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> soundEnabled,
  Value<bool> animationEnabled,
  Value<int> excludeRecentCount,
  Value<String> theme,
  Value<bool> luckyStarEnabled,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get animationEnabled => $composableBuilder(
      column: $table.animationEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get excludeRecentCount => $composableBuilder(
      column: $table.excludeRecentCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get luckyStarEnabled => $composableBuilder(
      column: $table.luckyStarEnabled,
      builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get animationEnabled => $composableBuilder(
      column: $table.animationEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get excludeRecentCount => $composableBuilder(
      column: $table.excludeRecentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get luckyStarEnabled => $composableBuilder(
      column: $table.luckyStarEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => column);

  GeneratedColumn<bool> get animationEnabled => $composableBuilder(
      column: $table.animationEnabled, builder: (column) => column);

  GeneratedColumn<int> get excludeRecentCount => $composableBuilder(
      column: $table.excludeRecentCount, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get luckyStarEnabled => $composableBuilder(
      column: $table.luckyStarEnabled, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    SettingsData,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (SettingsData, BaseReferences<_$AppDatabase, $SettingsTable, SettingsData>),
    SettingsData,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> animationEnabled = const Value.absent(),
            Value<int> excludeRecentCount = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<bool> luckyStarEnabled = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            soundEnabled: soundEnabled,
            animationEnabled: animationEnabled,
            excludeRecentCount: excludeRecentCount,
            theme: theme,
            luckyStarEnabled: luckyStarEnabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> animationEnabled = const Value.absent(),
            Value<int> excludeRecentCount = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<bool> luckyStarEnabled = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            soundEnabled: soundEnabled,
            animationEnabled: animationEnabled,
            excludeRecentCount: excludeRecentCount,
            theme: theme,
            luckyStarEnabled: luckyStarEnabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    SettingsData,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (SettingsData, BaseReferences<_$AppDatabase, $SettingsTable, SettingsData>),
    SettingsData,
    PrefetchHooks Function()>;
typedef $$CookingRecordsTableCreateCompanionBuilder = CookingRecordsCompanion
    Function({
  Value<int> id,
  required DateTime recordDate,
  Value<DateTime?> createdAt,
  Value<String?> note,
});
typedef $$CookingRecordsTableUpdateCompanionBuilder = CookingRecordsCompanion
    Function({
  Value<int> id,
  Value<DateTime> recordDate,
  Value<DateTime?> createdAt,
  Value<String?> note,
});

class $$CookingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CookingRecordsTable> {
  $$CookingRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
      column: $table.recordDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$CookingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingRecordsTable> {
  $$CookingRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
      column: $table.recordDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$CookingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingRecordsTable> {
  $$CookingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
      column: $table.recordDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$CookingRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CookingRecordsTable,
    CookingRecordData,
    $$CookingRecordsTableFilterComposer,
    $$CookingRecordsTableOrderingComposer,
    $$CookingRecordsTableAnnotationComposer,
    $$CookingRecordsTableCreateCompanionBuilder,
    $$CookingRecordsTableUpdateCompanionBuilder,
    (
      CookingRecordData,
      BaseReferences<_$AppDatabase, $CookingRecordsTable, CookingRecordData>
    ),
    CookingRecordData,
    PrefetchHooks Function()> {
  $$CookingRecordsTableTableManager(
      _$AppDatabase db, $CookingRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> recordDate = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              CookingRecordsCompanion(
            id: id,
            recordDate: recordDate,
            createdAt: createdAt,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime recordDate,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              CookingRecordsCompanion.insert(
            id: id,
            recordDate: recordDate,
            createdAt: createdAt,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CookingRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CookingRecordsTable,
    CookingRecordData,
    $$CookingRecordsTableFilterComposer,
    $$CookingRecordsTableOrderingComposer,
    $$CookingRecordsTableAnnotationComposer,
    $$CookingRecordsTableCreateCompanionBuilder,
    $$CookingRecordsTableUpdateCompanionBuilder,
    (
      CookingRecordData,
      BaseReferences<_$AppDatabase, $CookingRecordsTable, CookingRecordData>
    ),
    CookingRecordData,
    PrefetchHooks Function()>;
typedef $$CookingRecordItemsTableCreateCompanionBuilder
    = CookingRecordItemsCompanion Function({
  Value<int> id,
  required int recordId,
  required String dishName,
  Value<double?> price,
  Value<String?> note,
  Value<String?> category,
});
typedef $$CookingRecordItemsTableUpdateCompanionBuilder
    = CookingRecordItemsCompanion Function({
  Value<int> id,
  Value<int> recordId,
  Value<String> dishName,
  Value<double?> price,
  Value<String?> note,
  Value<String?> category,
});

class $$CookingRecordItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CookingRecordItemsTable> {
  $$CookingRecordItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dishName => $composableBuilder(
      column: $table.dishName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));
}

class $$CookingRecordItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingRecordItemsTable> {
  $$CookingRecordItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dishName => $composableBuilder(
      column: $table.dishName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$CookingRecordItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingRecordItemsTable> {
  $$CookingRecordItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get dishName =>
      $composableBuilder(column: $table.dishName, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$CookingRecordItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CookingRecordItemsTable,
    CookingRecordItemData,
    $$CookingRecordItemsTableFilterComposer,
    $$CookingRecordItemsTableOrderingComposer,
    $$CookingRecordItemsTableAnnotationComposer,
    $$CookingRecordItemsTableCreateCompanionBuilder,
    $$CookingRecordItemsTableUpdateCompanionBuilder,
    (
      CookingRecordItemData,
      BaseReferences<_$AppDatabase, $CookingRecordItemsTable,
          CookingRecordItemData>
    ),
    CookingRecordItemData,
    PrefetchHooks Function()> {
  $$CookingRecordItemsTableTableManager(
      _$AppDatabase db, $CookingRecordItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingRecordItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookingRecordItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookingRecordItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recordId = const Value.absent(),
            Value<String> dishName = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              CookingRecordItemsCompanion(
            id: id,
            recordId: recordId,
            dishName: dishName,
            price: price,
            note: note,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recordId,
            required String dishName,
            Value<double?> price = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              CookingRecordItemsCompanion.insert(
            id: id,
            recordId: recordId,
            dishName: dishName,
            price: price,
            note: note,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CookingRecordItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CookingRecordItemsTable,
    CookingRecordItemData,
    $$CookingRecordItemsTableFilterComposer,
    $$CookingRecordItemsTableOrderingComposer,
    $$CookingRecordItemsTableAnnotationComposer,
    $$CookingRecordItemsTableCreateCompanionBuilder,
    $$CookingRecordItemsTableUpdateCompanionBuilder,
    (
      CookingRecordItemData,
      BaseReferences<_$AppDatabase, $CookingRecordItemsTable,
          CookingRecordItemData>
    ),
    CookingRecordItemData,
    PrefetchHooks Function()>;
typedef $$CookingTemplatesTableCreateCompanionBuilder
    = CookingTemplatesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> itemsJson,
});
typedef $$CookingTemplatesTableUpdateCompanionBuilder
    = CookingTemplatesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> itemsJson,
});

class $$CookingTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $CookingTemplatesTable> {
  $$CookingTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));
}

class $$CookingTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingTemplatesTable> {
  $$CookingTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));
}

class $$CookingTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingTemplatesTable> {
  $$CookingTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$CookingTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CookingTemplatesTable,
    CookingTemplateData,
    $$CookingTemplatesTableFilterComposer,
    $$CookingTemplatesTableOrderingComposer,
    $$CookingTemplatesTableAnnotationComposer,
    $$CookingTemplatesTableCreateCompanionBuilder,
    $$CookingTemplatesTableUpdateCompanionBuilder,
    (
      CookingTemplateData,
      BaseReferences<_$AppDatabase, $CookingTemplatesTable, CookingTemplateData>
    ),
    CookingTemplateData,
    PrefetchHooks Function()> {
  $$CookingTemplatesTableTableManager(
      _$AppDatabase db, $CookingTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookingTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookingTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> itemsJson = const Value.absent(),
          }) =>
              CookingTemplatesCompanion(
            id: id,
            name: name,
            itemsJson: itemsJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> itemsJson = const Value.absent(),
          }) =>
              CookingTemplatesCompanion.insert(
            id: id,
            name: name,
            itemsJson: itemsJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CookingTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CookingTemplatesTable,
    CookingTemplateData,
    $$CookingTemplatesTableFilterComposer,
    $$CookingTemplatesTableOrderingComposer,
    $$CookingTemplatesTableAnnotationComposer,
    $$CookingTemplatesTableCreateCompanionBuilder,
    $$CookingTemplatesTableUpdateCompanionBuilder,
    (
      CookingTemplateData,
      BaseReferences<_$AppDatabase, $CookingTemplatesTable, CookingTemplateData>
    ),
    CookingTemplateData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$SeasoningsTableTableManager get seasonings =>
      $$SeasoningsTableTableManager(_db, _db.seasonings);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$PoolsTableTableManager get pools =>
      $$PoolsTableTableManager(_db, _db.pools);
  $$PoolRecipesTableTableManager get poolRecipes =>
      $$PoolRecipesTableTableManager(_db, _db.poolRecipes);
  $$DrawHistoriesTableTableManager get drawHistories =>
      $$DrawHistoriesTableTableManager(_db, _db.drawHistories);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$CookingRecordsTableTableManager get cookingRecords =>
      $$CookingRecordsTableTableManager(_db, _db.cookingRecords);
  $$CookingRecordItemsTableTableManager get cookingRecordItems =>
      $$CookingRecordItemsTableTableManager(_db, _db.cookingRecordItems);
  $$CookingTemplatesTableTableManager get cookingTemplates =>
      $$CookingTemplatesTableTableManager(_db, _db.cookingTemplates);
}
