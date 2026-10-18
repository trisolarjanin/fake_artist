# Fake Artist (Flutter, EN + PL)

A pass-the-phone game master for *A Fake Artist Goes to New York*.

## Run it

```bash
flutter create fake_artist        # generates android/ios/web folders
cd fake_artist
# copy pubspec.yaml and lib/ from this folder over the generated ones
flutter pub get
flutter run
```

## Customise

- Words: `lib/words.dart` (language -> category -> words)
- UI text: `lib/strings.dart`
- New language: add a key to both maps and a segment in `_setup()`
- Fonts are fetched by `google_fonts` on first launch. To work fully
  offline, bundle Caveat and Nunito as assets and set
  `GoogleFonts.config.allowRuntimeFetching = false`.
