import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';

const _kBatteryRefreshInterval = Duration(minutes: 5);

class BatteryManager {
  final settingsManager = getIt<SettingsManager>();
  final Battery _battery = Battery();
  final batteryLevelNotifier = ValueNotifier(0);

  StreamSubscription<BatteryState>? _stateSubscription;
  Timer? _refreshTimer;

  BatteryManager() {
    settingsManager.batteryWidgetEnabledNotifier.addListener(_handleEnabledChanged);

    if (settingsManager.batteryWidgetEnabledNotifier.value) {
      _activate();
    }
  }

  void _handleEnabledChanged() {
    if (settingsManager.batteryWidgetEnabledNotifier.value) {
      _activate();
    } else {
      _deactivate();
    }
  }

  Future<void> _activate() async {
    await updateBatteryLevel();

    if (_stateSubscription == null) {
      _stateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
        print("Battery state changed: $state");
        updateBatteryLevel();
      });
    }

    _refreshTimer ??= Timer.periodic(_kBatteryRefreshInterval, (_) => updateBatteryLevel());
  }

  void _deactivate() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> updateBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (level != batteryLevelNotifier.value) {
      print("BATTERY LEVEL: $level");
      batteryLevelNotifier.value = level;
    }
  }
}
