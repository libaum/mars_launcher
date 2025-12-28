<h1>
  Mars Launcher 🚀
  <a href="https://play.google.com/store/apps/details?id=com.cloudcatcher.mars_launcher">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" align="right" height="45" />
  </a>
</h1>

<!-- > **M**inimalist **a**nd **r**eally **s**imple Android Launcher. -->

<!-- [![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE) -->

<!-- <br><br> -->

<!-- <div align="center">
  <img src="https://github.com/droggl/mars_launcher/assets/65762534/c646b4d1-178b-4527-be4c-ec416c330316" width="100%" alt="Mars Launcher Showcase">
</div> -->

<!-- --- -->


**Mars Launcher** (**M**inimalist **a**nd **r**eally **s**imple) is a distraction-free home screen replacement for Android built with **Flutter**. It is designed to help users reduce screen time and reclaim their focus. By removing colorful icons and clutter, it leaves only what is essential, following the philosophy of digital minimalism.

![Mars Launcher Showcase](https://github.com/droggl/mars_launcher/assets/65762534/c646b4d1-178b-4527-be4c-ec416c330316)

## 🎯 Motivation

Modern smartphones are designed to be addictive. Bright colors and notification badges constantly fight for attention. Mars Launcher brings peace back to the device by:
* **Removing app icons** (text-only interface).
* **Replacing the status bar** with minimal, functional widgets (clock, battery, weather, calendar events) that can be linked to any app for quick access.
* **Focusing on utility** with quick access only to the tools you actually need.

## ✨ Key Features

* **Minimalistic Home Screen:** Displays only your most essential apps as a clean text list.
* **Smart Widget Bar:** Top row shows functional widgets (clock, battery, weather, calendar, events) instead of the status bar.
    * **Linkable Widgets:** Each widget can be linked to an app for one-tap access (e.g., tap clock to open your preferred clock app, tap battery for settings).
* **Gesture Control:**
    * `Swipe Left/Right`: Quick access to customizable app shortcuts (configurable via Settings).
    * `Swipe Up`: Super fast app search.
    * `Double Tap`: Toggle instantly between **Light** and **Dark Mode**.
    * `Long Press`: Open Settings.
* **Integrated Productivity:** Built-in minimal To-Do list (access via long-press on calendar date).
* **Privacy Respecting:** Open-source and transparent. Weather data is fetched from [Open-Meteo](https://open-meteo.com/) (no API key or tracking). All data is stored locally on your device.
* **Customization:** Hide or rename apps for a cleaner look (e.g., "Social" instead of "Instagram"). Enable/disable widgets as needed.

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **Architecture:** Service Locator Pattern with Manager Classes
* **State Management:** ValueNotifier (Flutter built-in)
* **Local Storage:** SharedPreferences (for Settings & To-Dos)

## 📥 Installation & Setup

If you want to build the project from source:

1.  **Prerequisites:** Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/libaum/mars_launcher.git
    cd mars_launcher
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! If you have an idea for a feature that aligns with the minimalist philosophy, feel free to fork the repo and submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.