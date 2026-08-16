#!/usr/bin/env bash
# 打包 Android release APK（可直接 adb install / 侧载安装，个人使用）。
# 用法： bash scripts/build_android.sh
#
# 注意：沙箱内无 Flutter SDK，本脚本须在本机（已装 Flutter >=3.22 / Dart >=3.4）运行。
set -e

DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DIR"

# 在 PATH 中查找 flutter；找不到则尝试常见安装位置（含本机已装的 SDK）
if ! command -v flutter >/dev/null 2>&1; then
  for p in \
    "$HOME/.local/share/flutter-sdk/flutter/bin" \
    "$HOME/development/flutter/bin" \
    "$HOME/flutter/bin" \
    "/opt/flutter/bin" ; do
    if [ -x "$p/flutter" ]; then
      export PATH="$p:$PATH"
      echo "==> 在 $p 找到 flutter，已临时加入 PATH"
      break
    fi
  done
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ 未检测到 flutter，请先安装 Flutter SDK (>=3.22) 并纳入 PATH。"
  echo "   本机已知安装位置： $HOME/.local/share/flutter-sdk/flutter"
  exit 1
fi

# 校验版本（要求 >=3.22）
FLUTTER_VER="$(flutter --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [ -n "$FLUTTER_VER" ]; then
  if [ "$(printf '%s\n' '3.22.0' "$FLUTTER_VER" | sort -V | head -1)" != '3.22.0' ]; then
    echo "❌ flutter 版本过低（$FLUTTER_VER），需要 >=3.22。"
    exit 1
  fi
fi

# 解析 JAVA_HOME（flutter 的 android 构建依赖 Gradle，Gradle 需要 JDK >=17）
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
  for j in \
    "/usr/local/opt/openjdk@21" \
    "/usr/local/opt/openjdk@17" \
    "/opt/homebrew/opt/openjdk@21" \
    "/opt/homebrew/opt/openjdk@17" ; do
    if [ -x "$j/bin/java" ]; then
      export JAVA_HOME="$j"
      break
    fi
  done
fi
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
  for d in /Library/Java/JavaVirtualMachines/*/Contents/Home /usr/lib/jvm/*; do
    if [ -x "$d/bin/java" ]; then
      export JAVA_HOME="$d"
      break
    fi
  done
fi
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
  echo "❌ 未检测到 JDK（Gradle 需要 >=17）。请先安装： brew install openjdk@21"
  exit 1
fi
export PATH="$JAVA_HOME/bin:$PATH"

# 1) 确保 android 平台目录存在（仅取平台壳，不覆盖 lib/ 与 pubspec.yaml）
if [ ! -d android ]; then
  echo "==> 生成 android 平台目录（项目名 what_to_eat → 包名 com.example.what_to_eat）"
  TMP="$(mktemp -d)"
  flutter create --platforms=android --project-name what_to_eat "$TMP/_boot"
  cp -R "$TMP/_boot/android" "$DIR/"
  rm -rf "$TMP"
else
  echo "==> android 目录已存在，跳过生成"
fi

# 2) 安装依赖 + 生成 Drift 代码（app_database.g.dart）
echo "==> flutter pub get"
flutter pub get
echo "==> dart run build_runner build"
dart run build_runner build --delete-conflicting-outputs

# 3) 自动定位 JDK（Gradle/Android 打包必须，Flutter 3.x 不再内置 JDK）
if [ -z "$JAVA_HOME" ]; then
  if command -v /usr/libexec/java_home >/dev/null 2>&1 && /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
  fi
fi
if [ -z "$JAVA_HOME" ]; then
  echo "❌ 未检测到 JDK。Android 打包需要 JDK 17+，请先安装其一："
  echo "   brew install --cask zulu@17      # 推荐（Azul Zulu JDK，含 JRE）"
  echo "   brew install openjdk@17          # 或 OpenJDK 17"
  echo "   或从 https://adoptium.net 下载 Temurin 17 的 .pkg 安装"
  echo "安装后重新运行本脚本即可（会自动定位 JDK）。"
  exit 1
fi
echo "==> 使用 JDK: $JAVA_HOME"

# 4) 打包 release APK（默认使用 debug 签名，可直接安装；不适合上架 Play 商店）
echo "==> flutter build apk --release"
flutter build apk --release

echo ""
echo "✅ 完成。APK 位于："
echo "   $DIR/build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "下一步："
echo "  安装到手机： adb install build/app/outputs/flutter-apk/app-release.apk"
echo "  体积更小（按 ABI 拆分）： flutter build apk --release --split-per-abi"
echo "  上架 Play 商店（AAB + 正式签名）： bash scripts/build_appbundle.sh"
echo ""
echo "提示：若你之前跑过 bootstrap.sh，包名可能是 com.example._boot；"
echo "      想改成自己的，编辑 android/app/build.gradle 的 applicationId 即可。"
