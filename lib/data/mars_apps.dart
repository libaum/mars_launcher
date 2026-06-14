/// The Mars app family — revealed on swipe down from the home screen.
/// The launcher itself is intentionally omitted (it is the current app).

class MarsApp {
  final String name;
  final String packageName;

  const MarsApp({required this.name, required this.packageName});

  String get playStoreUrl =>
      "https://play.google.com/store/apps/details?id=$packageName";
}

const List<MarsApp> marsApps = [
  MarsApp(name: "Mars Timer", packageName: "com.catchingclouds.marstimer"),
  MarsApp(name: "Mars FX", packageName: "com.catchingclouds.marsfx"),
  MarsApp(name: "Mars Expense", packageName: "com.catchingclouds.marsexpense"),
];
