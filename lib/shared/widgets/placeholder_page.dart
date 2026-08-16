import 'package:flutter/material.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 占位页（第二批功能）。
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String note;

  const PlaceholderPage({super.key, required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(note, style: const TextStyle(color: AppTheme.gray)),
          ],
        ),
      ),
    );
  }
}
