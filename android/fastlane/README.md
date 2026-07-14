fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android alpha

```sh
[bundle exec] fastlane android alpha
```

Build & upload a new version to Alpha (draft)

### android production

```sh
[bundle exec] fastlane android production
```

Build & upload a new version to Production

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Update the store listing only (texts, images, screenshots)

### android alpha_upload

```sh
[bundle exec] fastlane android alpha_upload
```

Upload the existing AAB to Alpha (no rebuild, draft)

### android production_upload

```sh
[bundle exec] fastlane android production_upload
```

Upload the existing AAB to Production (no rebuild)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
