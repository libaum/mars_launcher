#!/usr/bin/env bash
set -euo pipefail
# Run the DEBUG build of Mars Launcher on a connected device (with hot reload).
#   applicationId: com.cloudcatcher.mars_launcher.debug  (app name "Mars Launcher DEBUG")
# Runs side by side with the release build — they have different IDs.

cd "$(dirname "$0")"

if [ -z "$(adb devices | sed '1d' | grep -w device || true)" ]; then
  echo "No device connected (check 'adb devices')." >&2
  exit 1
fi

echo "==> Running debug build"
flutter run --debug "$@"
