import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/features/cooking_records/categories.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 收支统计：支持 当日 / 本周 / 本月 / 全部 / 自定义时间段。
/// 自定义区间展示：总消费额、分类消费明细、消费趋势。
class CookingStatsPage extends ConsumerStatefulWidget {
  const CookingStatsPage({super.key});

  @override
  ConsumerState<CookingStatsPage> createState() => _CookingStatsPageState();
}

enum _StatsMode { today, week, month, all, custom }

class _CookingStatsPageState extends ConsumerState<CookingStatsPage> {
  _StatsMode _mode = _StatsMode.month;
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = now;
  }

  /// 根据当前模式换算统计区间 (from, to)。
  (DateTime, DateTime) _range() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    // 注意：预设周期返回的 to 必须截断到「天末」之类的确定值，而非 DateTime.now()
    // （带任意微秒）。若 to 含微秒，每次 build 值都不同，family 元组 key
    // (from,to) 永不相等 → provider 反复重建 → 统计一直转圈。自定义模式因
    // end 用 _to(23:59:59) 构造而是确定值，所以只有自定义能用。
    switch (_mode) {
      case _StatsMode.today:
        return (today, dayEnd);
      case _StatsMode.week:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        return (DateTime(monday.year, monday.month, monday.day), dayEnd);
      case _StatsMode.month:
        return (DateTime(now.year, now.month, 1), dayEnd);
      case _StatsMode.all:
        return (DateTime(2000), dayEnd);
      case _StatsMode.custom:
        // 自定义：起始日 00:00 → 结束日 23:59:59，保证整日都纳入。
        final end = DateTime(_to.year, _to.month, _to.day, 23, 59, 59);
        return (DateTime(_from.year, _from.month, _from.day), end);
    }
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial = isFrom ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => isFrom ? _from = picked : _to = picked);
  }

  @override
  Widget build(BuildContext context) {
    final (from, to) = _range();
    final statsAsync = ref.watch(cookingRangeStatsProvider((from, to)));

    return AppScaffold(
      title: '收支统计',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 周期 / 自定义切换
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(label: '当日', selected: _mode == _StatsMode.today,
                  onTap: () => setState(() => _mode = _StatsMode.today)),
              _Chip(label: '本周', selected: _mode == _StatsMode.week,
                  onTap: () => setState(() => _mode = _StatsMode.week)),
              _Chip(label: '本月', selected: _mode == _StatsMode.month,
                  onTap: () => setState(() => _mode = _StatsMode.month)),
              _Chip(label: '全部', selected: _mode == _StatsMode.all,
                  onTap: () => setState(() => _mode = _StatsMode.all)),
              _Chip(label: '自定义', selected: _mode == _StatsMode.custom,
                  onTap: () => setState(() => _mode = _StatsMode.custom)),
            ],
          ),

          // 自定义日期选择
          if (_mode == _StatsMode.custom) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DateBox(
                      label: '起始', date: _from, onTap: () => _pickDate(true)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward, size: 18,
                      color: AppTheme.gray),
                ),
                Expanded(
                  child: _DateBox(
                      label: '结束', date: _to, onTap: () => _pickDate(false)),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // 总消费额
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.wood,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('累计支出', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                statsAsync.when(
                  data: (s) => Text('¥${s.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800)),
                  loading: () => const CircularProgressIndicator(
                      color: Colors.white),
                  error: (e, _) => const Text('加载失败',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 分类消费明细
          const Text('分类消费明细',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          statsAsync.when(
            data: (s) => _CategoryBreakdown(byCategory: s.byCategory),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),

          const SizedBox(height: 24),

          // 消费趋势
          const Text('消费趋势',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          statsAsync.when(
            data: (s) => _TrendChart(trend: s.trend),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}

/// 周期切换小标签。
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.wood,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.darkBrown,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// 日期选择块（自定义模式）。
class _DateBox extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateBox(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.wood.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: AppTheme.gray, fontSize: 12)),
            const SizedBox(height: 4),
            Text('${date.year}/${date.month}/${date.day}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

/// 分类消费明细：按金额降序，色块条 + 金额 + 占比。
class _CategoryBreakdown extends StatelessWidget {
  final Map<String, double> byCategory;
  const _CategoryBreakdown({required this.byCategory});

  @override
  Widget build(BuildContext context) {
    if (byCategory.isEmpty) {
      return const Text('该区间暂无消费记录',
          style: TextStyle(color: AppTheme.gray));
    }
    final entries = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final max = entries.first.value;
    final total = entries.fold<double>(0, (s, e) => s + e.value);

    return Column(
      children: entries.map((e) {
        final pct = total > 0 ? e.value / total : 0.0;
        final barPct = max > 0 ? e.value / max : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: categoryColor(e.key),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(e.key,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('¥${e.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkBrown)),
                  const SizedBox(width: 8),
                  Text('${(pct * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          color: AppTheme.gray, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.wood.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: barPct.clamp(0.02, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: categoryColor(e.key),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// 消费趋势：按日柱状图（横向可滚动，适配长区间）。
class _TrendChart extends StatelessWidget {
  final List<(DateTime, double)> trend;
  const _TrendChart({required this.trend});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return const Text('该区间暂无消费记录',
          style: TextStyle(color: AppTheme.gray));
    }
    final max = trend.map((t) => t.$2).reduce((a, b) => a > b ? a : b);
    const barW = 34.0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.wood.withOpacity(0.18)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: trend.map((t) {
            final day = t.$1;
            final h = max > 0 ? (t.$2 / max) * 120 : 0.0;
            return SizedBox(
              width: barW,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 18,
                    height: h.clamp(2.0, 120.0),
                    decoration: BoxDecoration(
                      color: AppTheme.wood,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${day.month}/${day.day}',
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.gray)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
