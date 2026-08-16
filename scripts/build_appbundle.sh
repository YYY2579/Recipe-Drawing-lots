#!/usr/bin/env bash
# 上架 Google Play 商店用的 Android App Bundle（AAB）打包，含正式签名。
# 用法： bash scripts/build_appbundle.sh
#
# 第一次运行会交互式生成上传密钥并写 android/key.properties（密码明文存于本机，勿提交 git）。
# 还需要你一次性把下方「build.gradle 改动」粘贴进 android/app/build.gradle（仅首次）。
set -e

DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ 未检测到 flutter，请先安装 Flutter SDK (>=3.22)。"
  exit 1
fi
if [ ! -d android ]; then
  echo "❌ 尚未生成 android 目录，请先运行： bash scripts/build_android.sh"
  exit 1
fi

# 1) 生成上传密钥（只需一次；已存在则跳过）
KEYSTORE="$HOME/upload-keystore.jks"
if [ ! -f "$KEYSTORE" ]; then
  echo "==> 生成上传密钥： $KEYSTORE"
  echo "    按提示输入密钥库密码与证书信息，alias 用 upload"
  keytool -genkey -v -keystore "$KEYSTORE" -keyalg RSA -keysize 2048 -validity 10000 -alias upload
else
  echo "==> 上传密钥已存在，跳过生成"
fi

# 2) 写入 android/key.properties（本机签名配置）
echo "==> 写入 android/key.properties"
read -r -s -p "请输入上面设置的密钥库密码（同时作为 keyPassword）: " KP
echo ""
cat > android/key.properties <<EOF
storePassword=$KP
keyPassword=$KP
keyAlias=upload
storeFile=$KEYSTORE
EOF
echo "✅ key.properties 已写入（请勿提交进 git，建议加入 .gitignore）"

# 3) 提示一次性修改 build.gradle 签名配置
echo ""
echo "=============================================================="
echo "请一次性把下面这段加进 android/app/build.gradle："
echo "--------------------------------------------------------------"
echo "在文件顶部（buildscript / apply 之后，android { 之前）加："
echo ""
echo "def keystoreProperties = Properties()"
echo "def keystorePropertiesFile = rootProject.file('key.properties')"
echo "if (keystorePropertiesFile.exists()) {"
echo "    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))"
echo "}"
echo ""
echo "在 android { 内、buildTypes 之前加："
echo ""
echo "    signingConfigs {"
echo "        release {"
echo "            keyAlias keystoreProperties['keyAlias']"
echo "            keyPassword keystoreProperties['keyPassword']"
echo "            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null"
echo "            storePassword keystoreProperties['storePassword']"
echo "        }"
echo "    }"
echo ""
echo "把 buildTypes 里的 release 改为："
echo "        release { signingConfig signingConfigs.release }"
echo "--------------------------------------------------------------"
echo "（改动后以后重新打包无需再改）"
echo "=============================================================="

# 4) 自动定位 JDK（Gradle 必须，Flutter 3.x 不再内置 JDK）
if [ -z "$JAVA_HOME" ]; then
  if command -v /usr/libexec/java_home >/dev/null 2>&1 && /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
  fi
fi
if [ -z "$JAVA_HOME" ]; then
  echo "❌ 未检测到 JDK。Android 打包需要 JDK 17+，请先安装其一："
  echo "   brew install --cask zulu@17      # 推荐"
  echo "   brew install openjdk@17"
  echo "   或从 https://adoptium.net 下载 Temurin 17 的 .pkg 安装"
  exit 1
fi
echo "==> 使用 JDK: $JAVA_HOME"

# 5) 打包 AAB
echo "==> flutter build appbundle --release"
flutter build appbundle --release

echo ""
echo "✅ 完成。AAB 位于："
echo "   $DIR/build/app/outputs/bundle/release/app-release.aab"
echo "   上传到 Google Play Console 的 App bundle 处即可。"
