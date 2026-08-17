import 'package:flutter/material.dart';

/// 记账消费分类（与录入弹窗、统计页共用，保证一致性）。
const List<String> kExpenseCategories = [
  '食材采购',
  '外卖',
  '堂食',
  '饮品',
  '其他',
];

/// 各分类的主题配色（用于「分类消费明细」柱状/色块）。
const Map<String, Color> kCategoryColors = {
  '食材采购': Color(0xFF4CAF50),
  '外卖': Color(0xFFF4A23B),
  '堂食': Color(0xFFE26D6A),
  '饮品': Color(0xFF5BA4E6),
  '其他': Color(0xFF9E9E9E),
};

/// 取分类配色，未知分类回落到「其他」灰。
Color categoryColor(String? c) =>
    kCategoryColors[c] ?? kCategoryColors['其他']!;
