import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/seed.dart';
import 'providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 单一数据库实例：在 main 里创建并播种，再通过 UncontrolledProviderScope 复用。
  final container = ProviderContainer();
  final db = container.read(databaseProvider);

  final recipesJson = jsonDecode(
        await rootBundle.loadString('assets/seed/recipes.json'),
      ) as List<dynamic>;
  final poolsJson = jsonDecode(
        await rootBundle.loadString('assets/seed/pools.json'),
      ) as List<dynamic>;

  await seedIfEmpty(db, recipes: recipesJson, pools: poolsJson);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
