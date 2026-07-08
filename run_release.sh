#!/usr/bin/env bash
set -euo pipefail
# Run the RELEASE build of Mars Launcher on a connected device.
#   applicationId: com.cloudcatcher.mars_launcher  (release-signed, with shader warmup)
# Requires the release keystore (android/key.properties) to be configured.

cd "$(dirname "$0")"

if [ -z "$(adb devices | sed '1d' | grep -w device || true)" ]; then
  echo "No device connected (check 'adb devices')." >&2
  exit 1
fi

echo "==> Running release build"
flutter run --release "$@"
