import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/backup.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 设置：音效、动画、最近不重复次数。
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _sound = true;
  bool _animation = true;
  int _exclude = 1;

  @override
  Widget build(BuildContext context) {
    final sAsync = ref.watch(settingsProvider);
    return AppScaffold(
      title: '设置',
      showBack: true,
      body: sAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (s) {
          // 仅在首次有数据时同步一次本地状态
          if (s != null && !_synced) {
            _sound = s.soundEnabled;
            _animation = s.animationEnabled;
            _exclude = s.excludeRecentCount;
            _synced = true;
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('抽签音效'),
                  subtitle: const Text('抽签时播放提示音'),
                  value: _sound,
                  activeColor: AppTheme.wood,
                  onChanged: (v) => setState(() => _sound = v),
                ),
                SwitchListTile(
                  title: const Text('签筒动画'),
                  subtitle: const Text('关闭后直接显示结果'),
                  value: _animation,
                  activeColor: AppTheme.wood,
                  onChanged: (v) => setState(() => _animation = v),
                ),
                ListTile(
                  title: const Text('最近不重复'),
                  subtitle: Text('最近 $_exclude 次抽过的菜不再出现（0 表示不限制）'),
                ),
                Slider(
                  value: _exclude.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '$_exclude',
                  activeColor: AppTheme.wood,
                  onChanged: (v) => setState(() => _exclude = v.round()),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.upload_file_outlined),
                        title: const Text('导出备份'),
                        subtitle: const Text('把菜谱 / 签池 / 设置 / 历史导出为 JSON 文件'),
                        onTap: _export,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.file_download_outlined),
                        title: const Text('导入备份'),
                        subtitle: const Text('从 JSON 文件恢复数据（按 id 覆盖，历史增量合并）'),
                        onTap: _import,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('保存设置'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _synced = false;

  Future<void> _save() async {
    await ref.read(databaseProvider).updateSettings(
          soundEnabled: _sound,
          animationEnabled: _animation,
          excludeRecentCount: _exclude,
        );
    ref.invalidate(settingsProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存')),
      );
    }
  }

  Future<void> _export() async {
    final msg = await exportBackup(ref.read(databaseProvider));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _import() async {
    final msg = await importBackup(ref.read(databaseProvider));
    // 导入后让相关列表刷新
    for (final p in [
      allRecipesProvider,
      favoriteRecipesProvider,
      historyProvider,
      allPoolsProvider,
      poolRecipesProvider,
      settingsProvider,
    ]) {
      ref.invalidate(p);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
