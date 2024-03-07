import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/temperature_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class Temperature extends StatelessWidget {
  final temperatureManager = getIt<TemperatureManager>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: temperatureManager.temperatureNotifier,
        builder: (context, temperature, child) {
          return Text(temperature,
              style: const TextStyle(
                fontSize: FONT_SIZE_TEMPERATURE,
                fontFamily: FONT_REGULAR,
              ));
        });
  }
}
