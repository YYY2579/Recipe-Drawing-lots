# 今日吃什么 · 菜谱抽签 App（基础地基）

> 个人本地优先的菜谱抽签 App。核心三件事：
> 1. **本地 Flutter 架构、好维护**（Offline-first，数据全在本地）
> 2. **菜单可自定义 + 预留扩展接口**（自己加菜谱、图片、做法）
> 3. **自带超多菜谱**（默认种子库，目前含 141 道结构化菜谱，覆盖 9 大分类）

本目录目前完成的是**不依赖 Flutter SDK 也能写、也能验证的核心地基**：
- 抽签引擎 `DrawEngine`（纯 Dart）
- 默认菜谱种子库（结构化 JSON）
- 工程依赖清单 `pubspec.yaml`

UI / Drift 数据库 / Riverpod 状态层建议你用 `flutter-scaffolding` 起骨架后接入（见下）。

---

## 目录结构（当前）

```
菜谱随机抽签/
├── pubspec.yaml              # 技术栈与依赖（Flutter + Riverpod + GoRouter + Drift + Freezed）
├── lib/
│   └── core/
│       └── draw/
│           └── draw_engine.dart   # 抽签引擎（纯 Dart，对应文档 §11/§12/§13/§16/§29/§30）
├── assets/
│   └── seed/
│       ├── recipes.json     # 默认菜谱（30 道川菜，结构化）
│       └── pools.json       # 默认签池（川菜/家常菜/下饭菜/肉菜/素菜/快手菜）
└── README.md
```

## DrawEngine 设计要点（对应规划文档）

| 文档章节 | 实现 |
|---|---|
| §11 抽签算法 V1 | 普通随机 `Random` |
| §12 候选不足处理 | 排除条件自动降级，保证一定有结果 |
| §13 抽签算法 V2 | 已预留 `RecipeRef.weight`，权重越高概率越大 |
| §16 / §29 算法与动画分离 | `DrawEngine` 只出结果，不碰 UI |
| §30 DrawResult | 统一结果结构，含 `animationSeed` 供动画复现/调试 |

调用示例（纯 Dart，可单测）：

```dart
import 'package:what_to_eat/core/draw/draw_engine.dart';

final engine = DrawEngine();
final result = engine.draw(
  candidates: [
    for (final r in poolRecipeRefs) RecipeRef(r.id, r.name),
  ],
  recentRecipeIds: history.map((h) => h.recipeId).toList(),
  excludeRecentCount: settings.excludeRecentCount, // 最近 N 次不重复
  poolId: currentPool.id,
);
print(result.recipeName); // → 例如 "鱼香肉丝"
```

## 菜谱数据格式（可扩展）

`recipes.json` 每条就是文档 §4 的 `Recipe` 结构（字段全部可选，方便你以后加图片/自定义字段）。
新增菜谱只需往数组里加对象，或在 App 内手动/文本导入（文档 §5/§21）。

`pools.json` 是文档 §9 的默认签池：菜谱与签池**解耦**（同一道菜可同时属于多个池）。

---

## 下一步（在你本机有 Flutter 的环境下）

1. 用脚手架起工程（栈已对齐）：
   ```bash
   npx maxsim-flutter create what_to_eat   # 选 database + theme + i18n 模块
   # 或参考 RainVu(github.com/astraen-dev/RainVu) 的 Drift 表 + JSON 导入导出
   ```
2. 把本目录的 `lib/`、`assets/` 拷进工程，在 `pubspec.yaml` 里已声明 `assets/seed/`。
3. 安装依赖并生成代码：
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
4. 把 `recipes.json` / `pools.json` 写成 Drift 初始种子（首次启动写入 SQLite）。
5. 接入签筒动画（参考 `fortune_wheel` 的 `spinToBackendResult`：先定结果，再播放动画）。

## 在本地运行（需要有 Flutter SDK 的机器）

本仓库**不含** Android / iOS 平台目录，也没有 `app_database.g.dart`（由 build_runner 生成）。
首次运行请执行引导脚本：

```bash
bash scripts/bootstrap.sh      # 生成平台目录 + flutter pub get + build_runner
flutter run                   # 启动（默认 iOS / Android 模拟器）
```

脚本仅从临时工程复制 `android/ /ios/ .metadata .gitignore`，**不会覆盖**你已有的 `pubspec.yaml` 与 `lib/`。

## 打包 Android App

> 沙箱无 Flutter SDK，以下命令均须在本机（已装 Flutter ≥3.22 / Dart ≥3.4）运行。

### 方式一：本地安装用的 APK（一键）

```bash
bash scripts/build_android.sh
```

脚本会自动：生成 android 目录（项目名 `what_to_eat`，包名 `com.example.what_to_eat`）→ `flutter pub get` → `build_runner` → `flutter build apk --release`。
产出：`build/app/outputs/flutter-apk/app-release.apk`（默认 debug 签名，可直接 `adb install` 或蓝牙/网盘侧载，**不能上架 Play 商店**）。

- 体积更小（按 CPU 架构拆分）：`flutter build apk --release --split-per-abi`
- 改包名：编辑 `android/app/build.gradle` 的 `applicationId`（若之前跑过 `bootstrap.sh`，可能是 `com.example._boot`）

### 方式二：上架 Google Play 的 AAB（正式签名）

```bash
bash scripts/build_appbundle.sh
```

首次会交互式生成上传密钥 `~/upload-keystore.jks`、写 `android/key.properties`，并打印**一次性**粘贴进 `android/app/build.gradle` 的签名片段；之后 `flutter build appbundle --release`。
产出：`build/app/outputs/bundle/release/app-release.aab`，上传到 Play Console 即可。

### Android 注意事项

- **无需联网权限**：本 App 离线优先，默认不申请 `INTERNET`，正常。
- **file_picker 存储权限**：Android 13（API 33）及以上用系统文件选择器，无需额外权限；若需兼容 Android 12 及以下，在 `android/app/src/main/AndroidManifest.xml` 加：
  `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>`（按需 `WRITE_EXTERNAL_STORAGE` 并 `android:maxSdkVersion="32"`）。导出/导入若在选择文件时失败，多为该权限问题。
- **签名文件保密**：`android/key.properties` 与 `~/upload-keystore.jks` 含私钥，请勿提交进 git（建议加入 `.gitignore`）。

## 目录结构（当前）

```
菜谱随机抽签/
├── pubspec.yaml              # 技术栈（Flutter + Riverpod + GoRouter + Drift）
├── analysis_options.yaml
├── lib/
│   ├── main.dart            # 入口：Drift 播种 + ProviderScope
│   ├── app/
│   │   ├── app.dart         # MaterialApp.router
│   │   ├── router.dart      # 见 providers.dart 中的 routerProvider
│   │   └── theme.dart       # 暖米白 / 木色 / 红印章
│   ├── core/
│   │   ├── constants/app_constants.dart
│   │   ├── database/
│   │   │   ├── tables.dart          # 8 张 Drift 表（§25）
│   │   │   ├── app_database.dart     # 查询方法 + 连接（生成 app_database.g.dart）
│   │   │   └── seed.dart            # 读 assets/seed/*.json 首次播种
│   │   ├── draw/
│   │   │   ├── draw_engine.dart     # 纯 Dart 抽签引擎（§11/§12/§13/§16/§29/§30）
│   │   │   └── draw_service.dart    # DrawNotifier（状态机，先定结果再播动画）
│   │   └── models/          # （暂用 Drift 数据类，无需额外模型）
│   ├── features/draw/
│   │   ├── pages/           # 首页抽签 / 结果页 / 轻量详情页
│   │   └── widgets/bamboo_tube.dart  # 签筒 CustomPainter（§14/§15 时间轴）
│   ├── shared/widgets/      # AppScaffold（底部 4 Tab）+ 占位页
│   └── providers.dart       # 全部 Riverpod Provider + routerProvider
├── assets/seed/
│   ├── recipes.json         # 141 道结构化菜谱（多分类）
│   └── pools.json           # 6 个签池（按分类自动推导关联）
├── scripts/
│   ├── gen_seed.mjs         # 重新生成种子数据（保留 30 川菜 + 追加）
│   └── bootstrap.sh         # 本地起工程 + 装依赖 + 生成代码
└── ui_preview/              # 8 张 UI 设计稿 PNG（供审核）
```

## DrawEngine 设计要点（对应规划文档）

| 文档章节 | 实现 |
|---|---|
| §11 抽签算法 V1 | 普通随机 `Random` |
| §12 候选不足处理 | 排除条件自动降级，保证一定有结果 |
| §13 抽签算法 V2 | 已预留 `RecipeRef.weight`，权重越高概率越大 |
| §16 / §29 算法与动画分离 | `DrawEngine` 只出结果，`DrawController`/`AnimationController` 再播放 |
| §30 DrawResult | 统一结果结构，含 `animationSeed` 供动画复现/调试 |

调用示例（纯 Dart，可单测）：

```dart
import 'package:what_to_eat/core/draw/draw_engine.dart';

final engine = DrawEngine();
final result = engine.draw(
  candidates: [
    for (final r in poolRecipeRefs) RecipeRef(r.id, r.name),
  ],
  recentRecipeIds: history.map((h) => h.recipeId).toList(),
  excludeRecentCount: settings.excludeRecentCount, // 最近 N 次不重复
  poolId: currentPool.id,
);
print(result.recipeName); // → 例如 "鱼香肉丝"
```

## 菜谱数据格式（可扩展）

`recipes.json` 每条就是文档 §4 的 `Recipe` 结构（字段全部可选，方便你以后加图片/自定义字段）。
新增菜谱只需往数组里加对象，或在 App 内手动/文本导入（文档 §5/§21）。

`pools.json` 是文档 §9 的默认签池：菜谱与签池**解耦**（同一道菜可同时属于多个池）。

---

## 本轮已完成（核心切片）

- [x] Drift 数据层：8 张表 + 播种（30→141 道菜谱）
- [x] Riverpod 状态层 + GoRouter + 底部 4 Tab 导航壳
- [x] 首页签筒抽签 + 签筒 `CustomPainter` 动画（§14/§15/§16，先定结果再播动画）
- [x] 抽签结果页（收藏 / 再抽 / 查看完整菜谱）
- [x] 轻量菜谱详情页（食材 / 调料 / 步骤）

## 第二轮已完成（第二批功能）

- [x] 菜谱库列表页：搜索框 + 9 个分类筛选 chips + 双列卡片网格（`/recipes`）
- [x] 菜谱增删改表单：`/recipes/new` 与 `/recipe/:id/edit`（菜名/难度/时长/份量/简介/分类/口味/食材/调料/步骤动态行）
- [x] 签池管理：`/pools` 列表（新建/编辑/删除签池）+ `/pools/:id` 详情（增删池内菜谱关联）
- [x] 我的：`/profile`（收藏 / 历史 / 设置 / 关于入口）
- [x] 收藏页 `/favorites`、历史页 `/history`（按时间分组、可清空）、设置页 `/settings`（音效/动画/最近不重复）
- [x] `AppDatabase` 扩展 CRUD / 搜索 / 收藏 / 历史查询方法；`providers.dart` 新增 `allRecipesProvider` / `favoriteRecipesProvider` / `historyProvider` / `poolByIdProvider`
- [x] 复用组件 `RecipeCard` / `RecipeGrid`

## V1（MVP 第一版本，文档 §34）已全部完成 ✅

V1 验收标准（文档 §42）：打开 App → 看到签筒 → 选池 → 抽一签 → 签筒晃动 → 抽中 → 看菜谱 → 收藏/再抽 → 记历史。
对照文档 §34「必须完成」逐项：

- [x] Flutter Android / iOS 项目（bootstrap.sh 生成平台壳）
- [x] SQLite 本地数据库（Drift，`what_to_eat.sqlite`）
- [x] 默认菜谱（141 道，多分类）
- [x] 默认川菜签池（`p-sichuan`，含 42 道）+ 其余 5 个分类签池
- [x] 菜谱列表（`/recipes`：双列网格 + 9 分类筛选）
- [x] 菜谱详情（食材 / 调料 / 步骤）
- [x] 搜索菜谱（菜名模糊搜索）
- [x] 添加菜谱（`/recipes/new`）
- [x] 编辑菜谱（`/recipe/:id/edit`）
- [x] 删除菜谱（带确认弹窗）
- [x] 创建签池（`/pools`）
- [x] 编辑签池
- [x] 删除签池
- [x] 添加菜谱到签池（`/pools/:id` 关联管理）
- [x] 抽签算法（DrawEngine，§11 随机 / §12 排除降级）
- [x] 最近结果排除（设置「最近不重复」N 次）
- [x] 签筒动画（CustomPainter 时间轴，先定结果再播，§14/§15/§16）
- [x] 抽签结果（结果页 + 收藏/再抽）
- [x] 收藏（`/favorites`）
- [x] 抽签历史（`/history`，可清空）
- [x] 数据导入（`lib/core/database/backup.dart`：`FilePicker` 选 JSON 恢复）
- [x] 数据导出（`backup.dart`：`FilePicker` 存 JSON 备份）
- [x] 基础设置（`/settings`：音效 / 动画 / 最近不重复）

> V1 原则：Offline-first（无网可用）、数据属于用户（可导出/备份/恢复/迁移）、菜谱与签池解耦、算法与动画解耦、第一版不做后端。

## 仍待补（V2 / V3，文档 §35/§36）

- [ ] 批量添加菜谱
- [ ] 图片管理 / 相机拍摄（详情配图打磨）
- [ ] 文本智能导入 / 菜谱 URL 导入（文档 §21/§22）
- [ ] 分享接收 URL
- [ ] 更丰富的动画 / 抽签音效（音效文件接入）
- [ ] 深色模式
- [ ] 权重抽签（DrawEngine 已预留 `weight` 字段）
- [ ] 自定义标签 / 自定义分类
- [ ] 用开源中餐数据集进一步扩充菜谱库
- [ ] 签池内菜谱排序（PoolRecipes 已有 `weight` 字段，未接 UI）
- [ ] V3：用户账号 / 云同步 / 多设备 / 家庭共享 / AI 解析生成菜单规划
