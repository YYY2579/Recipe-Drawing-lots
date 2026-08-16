#!/usr/bin/env bash
set -u
export JAVA_HOME=/usr/local/opt/openjdk@21
export ANDROID_HOME=/Users/yyy/Library/Android/sdk
export PATH="/Users/yyy/.local/share/flutter-sdk/flutter/bin:$PATH"
# 关键：去掉代理，让 Gradle 走直连（代理会把依赖下载卡死）
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY
cd /Users/yyy/Desktop/菜谱随机抽签
LOG=/Users/yyy/Desktop/菜谱随机抽签/build_apk2.log
echo "[$(date)] 开始 flutter build apk --release (直连模式)" | tee -a "$LOG"
flutter build apk --release >> "$LOG" 2>&1
rc=$?
echo "BUILD_EXIT=$rc" | tee -a "$LOG"
if [ -f build/app/outputs/flutter-apk/app-release.apk ]; then
  echo "APK_OK" | tee -a "$LOG"
  ls -la build/app/outputs/flutter-apk/app-release.apk | tee -a "$LOG"
else
  echo "APK_MISSING" | tee -a "$LOG"
  tail -c 3000 "$LOG" | tee -a "$LOG"
fi
