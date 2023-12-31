# template_flutter_app

Template with basic boilerplate code for Flutter apps

### How to start

Complete steps below for easily start coding your own app

0. create new repo using this repo as template
1. clone repo to your device
2. run `flutter create .` in repo directory
3. replace all `template_app` and `Template App` with your `app_name` using IDE tools
4. add all tokens if your need
   1. `goggle_api_key.json` - google clouds service key. used for translating your app localization texts.
   2. fill `.env` with variables from `.env.example`
5. upgrade `.vscode/launch.json` with your own device ids

That's all, enjoy!

### What structure this repo use:

- `features` for all features in sliced model. each feature should have same structure, e.g. next:
  - `data`
  - `hooks`
  - `widgets`
  - `*_screen.dart`
- `core` for most common things as theme and navigation
- `services` for integrating with third-party services along with dart pubs, api and other things
  - `logger` for DevLogger service configuration
  - `file_system` for configure basic operations with device file system
  - `i18n` for configure languages in `easy_localization`
- `shared` for all things which use in more than one feature
  - `widgets` contains common widgets
  - `models` contains domain models and other model classes
  - `repositories` contains classes which manage data, stored in isar
  - `services` contains classes which operate business logic
  - `pubs` contains common pubs like `global_state`
  - `extensions` contains the most common extensions

### What pubs does this repo use:

- `easy_localization` with fixed code generation, adapted for using csv as source file
  - all texts stored in `assets/translations/source.csv`
  - run `make locale` for translation all your texts, generate JSON files, generate static keys. If you want to do only part of this actions, check `Makefile`
- `isar` for local database. Its like `hive`, written by their authors, but much better (it's not my opinion, but `hive/isar` author opinion)
  - use `base_repository` for creating new repositories with predefined methods
- `go_router` for app routing
- `logger` for logging
  - by default logging is read as enabled from shared_preferences. Don't forget update this
- `flex_color_scheme` for theming
- `google_fonts` for using any google font
- `freezed` for models code generation
- `lottie` for cool animations
- `flutter-animate` for animating widgets with flutter
- `flutter_native_splash` for setting loading splash screen
