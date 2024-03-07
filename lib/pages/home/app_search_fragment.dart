/// App search fragment that appears on swipe up

import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';

class AppSearchFragment extends StatefulWidget {
  final AppSearchMode appSearchMode;
  final ValueNotifierWithKey<AppInfo>? specialShortcutAppNotifier;
  final int? shortcutIndex;

  AppSearchFragment({required this.appSearchMode, this.specialShortcutAppNotifier, this.shortcutIndex});

  @override
  _AppSearchFragmentState createState() => _AppSearchFragmentState();
}

class _AppSearchFragmentState extends State<AppSearchFragment> with WidgetsBindingObserver {
  final appSearchManager = getIt<AppSearchManager>();

  @override
  void initState() {
    print("[$runtimeType] INITIALISING");
    appSearchManager.setTemporaryParameters(
      widget.appSearchMode,
      widget.shortcutIndex,
      widget.specialShortcutAppNotifier,
    );

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    appSearchManager.resetFilteredList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFieldSearchApp(appSearchManager: appSearchManager),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ValueListenableBuilder<List<AppInfo>>(
                valueListenable: appSearchManager.filteredAppsNotifier,
                builder: (context, filteredApps, child) {
                  return ListView.builder(
                      itemCount: filteredApps.length,
                      itemBuilder: (context, index) {
                        return appSearchManager.getMemorizedAppCard(filteredApps[index]);
                      });
                }),
          ),
        ),
      ],
    );
  }
}

class TextFieldSearchApp extends StatefulWidget {
  const TextFieldSearchApp({
    Key? key,
    required this.appSearchManager,
  }) : super(key: key);

  final AppSearchManager appSearchManager;

  @override
  State<TextFieldSearchApp> createState() => _TextFieldSearchAppState();
}

class _TextFieldSearchAppState extends State<TextFieldSearchApp> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      focusNode: _focusNode, /// to automatically focus TextField when search is opened
      autofocus: true,
      cursorColor: Colors.white,
      cursorWidth: 0,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 30,
      ),
      onChanged: (value) {
        widget.appSearchManager.updateFilteredApps(context, value);
      },
    );
  }
}
