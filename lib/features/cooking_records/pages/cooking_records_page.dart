import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/features/cooking_records/categories.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 记账：按天时间线 + 右下角记一笔。统计入口移至右上角「收支统计」。
class CookingRecordsPage extends ConsumerStatefulWidget {
  const CookingRecordsPage({super.key});

  @override
  ConsumerState<CookingRecordsPage> createState() => _CookingRecordsPageState();
}

class _CookingRecordsPageState extends ConsumerState<CookingRecordsPage> {
  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(cookingRecordsProvider);
    final totalAsync = ref.watch(cookingTotalProvider);

    return AppScaffold(
      title: '记账',
      actions: [
        IconButton(
          tooltip: '收支统计',
          icon: const Icon(Icons.bar_chart_outlined),
          onPressed: () => context.push('/cooking-stats'),
        ),
      ],
      body: Column(
        children: [
          _TotalBanner(totalAsync: totalAsync),
          Expanded(
            child: recordsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败：$e')),
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                      child: Text('还没有记录，点右下角 + 记一笔吧'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _DayCard(record: records[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSheet(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
    );
  }

  void _openSheet(BuildContext context, WidgetRef ref,
      CookingRecordData? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CookingRecordSheet(record: existing),
    ).then((_) {
      ref.invalidate(cookingRecordsProvider);
      ref.invalidate(cookingTemplatesProvider);
      ref.invalidate(cookingTotalProvider);
      ref.invalidate(cookingStatsProvider);
    });
  }
}

/// 单日记录卡片（时间线一项）。
class _DayCard extends ConsumerWidget {
  final CookingRecordData record;
  const _DayCard({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(cookingItemsProvider(record.id));
    final total = (itemsAsync.valueOrNull ?? [])
        .fold<double>(0, (s, it) => s + (it.price ?? 0));

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                        '${record.recordDate.month}/${record.recordDate.day}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_weekday(record.recordDate),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('共 ¥${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppTheme.gray, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {
                    final sheet = context
                        .findAncestorStateOfType<_CookingRecordsPageState>();
                    sheet?._openSheet(context, ref, record);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () async {
                    await ref
                        .read(databaseProvider)
                        .deleteCookingRecord(record.id);
                    ref.invalidate(cookingRecordsProvider);
                    ref.invalidate(cookingTotalProvider);
                    ref.invalidate(cookingStatsProvider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            itemsAsync.when(
              data: (items) => Column(
                children: items
                    .map((it) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 6,
                                  color: AppTheme.wood),
                              const SizedBox(width: 8),
                              Expanded(child: Text(it.dishName)),
                              if (it.price != null)
                                Text('¥${it.price!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: AppTheme.darkBrown)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              loading: () => const Text('加载中…'),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  String _weekday(DateTime d) {
    const names = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final w = names[(d.weekday - 1) % 7];
    final hm =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '${d.year}年${d.month}月${d.day}日 $hm · $w';
  }
}

/// 单条支出行的分类下拉选择（与全局 kExpenseCategories 一致）。
class _CategoryPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _CategoryPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor(value).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: categoryColor(value).withOpacity(0.5)),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        isDense: true,
        icon: const Icon(Icons.arrow_drop_down, size: 18),
        items: kExpenseCategories
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => v == null ? null : onChanged(v),
      ),
    );
  }
}

/// 新增 / 编辑记录的底部弹窗。
class CookingRecordSheet extends ConsumerStatefulWidget {
  final CookingRecordData? record;
  const CookingRecordSheet({super.key, this.record});

  @override
  ConsumerState<CookingRecordSheet> createState() =>
      _CookingRecordSheetState();
}

class _CookingRecordSheetState extends ConsumerState<CookingRecordSheet> {
  late DateTime _date;
  final List<_DishRow> _rows = [];
  final _templateName = TextEditingController();
  bool _saveAsTemplate = false;

  @override
  void initState() {
    super.initState();
    _date = widget.record?.recordDate ?? DateTime.now();
    if (widget.record != null) {
      // 编辑已有记录：载入其条目。
      _loadExistingItems();
    } else {
      // 新增：每次都是一条独立新记录，不预填、不叠加当天已有数据。
      _rows.add(_DishRow());
    }
  }

  Future<void> _loadExistingItems() async {
    final db = ref.read(databaseProvider);
    final start = DateTime(_date.year, _date.month, _date.day);
    final rec = (await (db.select(db.cookingRecords)
              ..where((t) => t.recordDate.equals(start)))
            .getSingleOrNull());
    if (!mounted) return;
    if (rec != null) {
      final items = await db.itemsForRecord(rec.id);
      if (!mounted) return;
      setState(() {
        if (items.isEmpty) {
          _rows.add(_DishRow());
        } else {
          for (final it in items) {
            _rows.add(_DishRow()
              ..name.text = it.dishName
              ..price.text = it.price?.toStringAsFixed(2) ?? ''
              ..category = it.category ?? '其他');
          }
        }
      });
    } else {
      setState(() => _rows.add(_DishRow()));
    }
  }

  @override
  void dispose() {
    for (final r in _rows) r.dispose();
    _templateName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final int rid;
    if (widget.record != null) {
      // 编辑：更新该条记录的条目（先清空再重插）。
      rid = widget.record!.id;
      await db.deleteItemsForRecord(rid);
    } else {
      // 新增：插入一条独立新记录（带时分秒），不按天复用。
      rid = await db.insertCookingRecord(_date);
    }
    for (final r in _rows) {
      final name = r.name.text.trim();
      if (name.isEmpty) continue;
      final price = double.tryParse(r.price.text.trim());
      await db.insertCookingItem(rid, name,
          price: price, category: r.category);
    }
    if (_saveAsTemplate && _templateName.text.trim().isNotEmpty) {
      final items = _rows
          .where((r) => r.name.text.trim().isNotEmpty)
          .map((r) => {
                'dishName': r.name.text.trim(),
                'price': double.tryParse(r.price.text.trim()),
              })
          .toList();
      await db.insertCookingTemplate(
          _templateName.text.trim(), jsonEncode(items));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(cookingTemplatesProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.record == null ? '记一笔' : '编辑记录',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                FilledButton(onPressed: _save, child: const Text('保存')),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                  _rows.clear();
                  _loadExistingItems();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text('${_date.year}年${_date.month}月${_date.day}日'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            templatesAsync.when(
              data: (templates) => templates.isNotEmpty
                  ? Row(
                      children: [
                        const Text('套用模板：',
                            style: TextStyle(color: AppTheme.gray)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            children: templates
                                .map((t) => ActionChip(
                                      label: Text(t.name),
                                      onPressed: () => _applyTemplate(t),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 12),
            const Text('支出明细',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._rows.asMap().entries.map((e) {
              final i = e.key;
              final r = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: r.name,
                            decoration: const InputDecoration(
                                hintText: '项目', isDense: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: r.price,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                                hintText: '金额', isDense: true),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: AppTheme.red, size: 20),
                          onPressed: () {
                            if (_rows.length > 1) {
                              setState(() {
                                r.dispose();
                                _rows.removeAt(i);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _CategoryPicker(
                      value: r.category,
                      onChanged: (v) => setState(() => r.category = v),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: () => setState(() => _rows.add(_DishRow())),
              icon: const Icon(Icons.add),
              label: const Text('再加一笔'),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('存为模板（方便下次一键套用）'),
              value: _saveAsTemplate,
              onChanged: (v) => setState(() => _saveAsTemplate = v ?? false),
            ),
            if (_saveAsTemplate)
              TextField(
                controller: _templateName,
                decoration: const InputDecoration(
                    labelText: '模板名称', isDense: true),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _applyTemplate(CookingTemplateData t) {
    final list = (jsonDecode(t.itemsJson ?? '[]') as List)
        .cast<Map<String, dynamic>>();
    setState(() {
      for (final r in _rows) r.dispose();
      _rows.clear();
      for (final m in list) {
        _rows.add(_DishRow()
          ..name.text = m['dishName'] as String? ?? ''
          ..price.text =
              (m['price'] == null ? '' : (m['price'] as num).toString()));
      }
      if (_rows.isEmpty) _rows.add(_DishRow());
    });
  }
}

/// 顶部累计支出横幅（随新增/删除实时刷新）。
class _TotalBanner extends StatelessWidget {
  final AsyncValue<double> totalAsync;
  const _TotalBanner({required this.totalAsync});

  @override
  Widget build(BuildContext context) {
    final total = totalAsync.when(
      data: (v) => '¥${v.toStringAsFixed(2)}',
      loading: () => '…',
      error: (_, __) => '¥0.00',
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB98252), Color(0xFF8A5A2B)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text('累计支出',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          const Spacer(),
          Text(total,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DishRow {
  final name = TextEditingController();
  final price = TextEditingController();
  String category = '其他';
  void dispose() {
    name.dispose();
    price.dispose();
  }
}
