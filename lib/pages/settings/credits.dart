import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/pages/settings/utils.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatefulWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Strings.creditsTitle, style: TEXT_STYLE_TITLE),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text.rich(TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(text: "Weather data by "),
                        TextSpan(
                          text: "Open-Meteo.com",
                          style: const TextStyle(
                            color: Colors.blue,

                            /// Set the color of the link
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              /// Define the URL to open when the link is tapped
                              final uri = Uri.parse("https://open-meteo.com/");

                              /// Use the url_launcher package to open the URL
                              launchUrl(uri);
                            },
                        ),
                        TextSpan(text: " (Licence can be found "),
                        TextSpan(
                          text: "here",
                          style: const TextStyle(
                            color: Colors.blue,

                            /// Set the color of the link
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              /// Define the URL to open when the link is tapped
                              final uri = Uri.parse("https://github.com/open-meteo/open-meteo/blob/main/LICENSE");

                              /// Use the url_launcher package to open the URL
                              launchUrl(uri);
                            },
                        ),
                        const TextSpan(text: ")."),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
