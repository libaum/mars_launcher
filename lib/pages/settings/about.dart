import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/theme/theme_constants.dart';
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

  static const String supportEmail = 'contact@catchingclouds.de';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        appBar: defaultTargetPlatform == TargetPlatform.linux
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                iconTheme: IconThemeData(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              )
            : null,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Strings.creditsTitle, style: TEXT_STYLE_SETTINGS_TITLE),
                  const SizedBox(height: 10),
                  // Text(
                  //   'About',
                  //   style: TEXT_STYLE_CREDITS_BODY.copyWith(
                  //     fontSize: 13,
                  //     fontWeight: FontWeight.w600,
                  //     color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                      'Mars Launcher is a small indie project that I initially built for myself because I was overwhelmed by the constant clutter on modern home screens. I believe in the value of digital minimalism, but I need to remind myself about it constantly. Mars Launcher helps me with that every day.',
                    style: TEXT_STYLE_ABOUT_BODY.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Text(
                      'Over time, I have included more and more useful functions, but I am still trying not to change the overall feel. As part of the project\'s philosophy, Mars Launcher will forever be ad-free, open-source and free to use, and will never track users.',
                    style: TEXT_STYLE_ABOUT_BODY.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'contact',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(
                    style: TEXT_STYLE_ABOUT_BODY.copyWith(height: 1.35),
                    children: [
                      const TextSpan(
                          text: 'If you have any suggestions for new features, want to report a bug, or just want to say hello, email me at ',
                      ),
                      TextSpan(
                        text: supportEmail,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final uri = Uri.parse('mailto:$supportEmail?subject=Mars%20Launcher%20feedback');
                            launchUrl(uri);
                          },
                      ),
                      const TextSpan(text: '.'),
                    ],
                  )),
                  const SizedBox(height: 18),
                  // Divider(color: Theme.of(context).dividerColor),
                  // const SizedBox(height: 12),
                  Text(
                    'credits',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(
                    style: TEXT_STYLE_ABOUT_BODY.copyWith(height: 1.35),
                    children: [
                      const TextSpan(text: 'Weather data by '),
                      TextSpan(
                        text: 'open-meteo.com',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final uri = Uri.parse('https://open-meteo.com/');
                            launchUrl(uri);
                          },
                      ),
                      const TextSpan(text: ' (license can be found '),
                      TextSpan(
                        text: 'here',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final uri = Uri.parse('https://github.com/open-meteo/open-meteo/blob/main/LICENSE');
                            launchUrl(uri);
                          },
                      ),
                      const TextSpan(text: ').'),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
