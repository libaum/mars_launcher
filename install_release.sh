#!/usr/bin/env bash
set -euo pipefail
# Build, archive and install the RELEASE build of Mars Launcher.
#   applicationId: com.cloudcatcher.mars_launcher  (release-signed)
# Every build is archived under apk_archive/ so a known-good version can be
# reinstalled later without rebuilding — handy when a new build regresses.
#
# Usage:
#   ./install_release.sh              build a fresh release APK, archive it, install
#   ./install_release.sh list         list archived APKs (newest first)
#   ./install_release.sh restore      install the most recent archived APK (no build)
#   ./install_release.sh restore 21   install the archived APK for versionCode 21
cd "$(dirname "$0")"

ARCHIVE_DIR="apk_archive"
APK_OUT="build/app/outputs/flutter-apk/app-release.apk"

require_device() {
  if [ -z "$(adb devices | sed '1d' | grep -w device || true)" ]; then
    echo "No device connected (check 'adb devices')." >&2
    exit 1
  fi
}

install_apk() {
  # -r reinstall keeping data, -d allow version downgrade (so rollbacks work)
  echo "==> Installing $(basename "$1")"
  adb install -r -d "$1"
}

case "${1:-build}" in
  list)
    ls -1t "$ARCHIVE_DIR"/*.apk 2>/dev/null || echo "No archived APKs in $ARCHIVE_DIR/."
    ;;
  restore)
    require_device
    if [ -n "${2:-}" ]; then
      apk=$(ls -1t "$ARCHIVE_DIR"/*"+${2}_"*.apk 2>/dev/null | head -n1 || true)
      [ -z "$apk" ] && { echo "No archived APK for versionCode ${2}." >&2; exit 1; }
    else
      apk=$(ls -1t "$ARCHIVE_DIR"/*.apk 2>/dev/null | head -n1 || true)
      [ -z "$apk" ] && { echo "No archived APKs in $ARCHIVE_DIR/." >&2; exit 1; }
    fi
    install_apk "$apk"
    ;;
  build)
    require_device
    echo "==> Building release APK"
    flutter build apk --release
    mkdir -p "$ARCHIVE_DIR"
    version=$(grep -m1 '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//')
    githash=$(git rev-parse --short HEAD 2>/dev/null || echo nogit)
    stamp=$(date +%Y%m%d-%H%M%S)
    archived="$ARCHIVE_DIR/mars_${version}_${githash}_${stamp}.apk"
    cp "$APK_OUT" "$archived"
    echo "==> Archived $(basename "$archived")"
    install_apk "$archived"
    ;;
  *)
    echo "Usage: $0 [build|list|restore [versionCode]]" >&2
    exit 1
    ;;
esac
