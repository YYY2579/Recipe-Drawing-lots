#!/usr/bin/env bash
# 在「已安装 Flutter SDK（>=3.22）」的机器上运行，用于：
#   1) 生成 Android / iOS 平台目录（不覆盖本项目已有的 pubspec / lib）
#   2) 安装依赖
#   3) 运行 build_runner 生成 Drift 代码（app_database.g.dart）
#   4) 启动应用
#
# 用法：  bash scripts/bootstrap.sh
set -e

DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ 未检测到 flutter，请先安装 Flutter SDK (>=3.22) 并纳入 PATH。"
  exit 1
fi

echo "==> 1) 生成平台目录（临时工程，仅取 android/ios/.metadata/.gitignore）"
TMP="$(mktemp -d)"
flutter create --platforms=android,ios "$TMP/_boot"
cp -R "$TMP/_boot/android" "$TMP/_boot/ios" "$TMP/_boot/.metadata" "$TMP/_boot/.gitignore" "$DIR/"
rm -rf "$TMP"

echo "==> 2) 安装依赖"
flutter pub get

echo "==> 3) 生成代码（Drift / 等）"
dart run build_runner build --delete-conflicting-outputs

echo "✅ 完成。现在可以运行：flutter run"
