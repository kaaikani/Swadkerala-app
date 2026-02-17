# Fix: "Command PhaseScriptExecution failed with a nonzero exit code" (iOS)

## What we did

1. **flutter clean** – Cleared build artifacts.
2. **flutter pub get** – Restored Dart packages and regenerated `ios/Flutter/Generated.xcconfig`.
3. **pod install with UTF-8** – CocoaPods was failing with `Unicode Normalization not appropriate for ASCII-8BIT`. Running with UTF-8 fixes it:
   ```bash
   cd ios && export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && pod install
   ```

## If the error comes back

### 1. Build from the command line (recommended)

Use Flutter so script phases get the right environment:

```bash
flutter run
# or
flutter build ios
```

Then run or archive from Xcode if needed.

### 2. Set UTF-8 for your shell (fixes CocoaPods encoding)

Add to `~/.zshrc` or `~/.bash_profile`:

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

Reload the shell (`source ~/.zshrc`) and run:

```bash
cd ios && pod install
```

### 3. Full reset

```bash
flutter clean
flutter pub get
cd ios && export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && pod install
cd .. && flutter run
```

### 4. See which script failed (Xcode)

In Xcode: **Report navigator** (last tab) → select the failed build → expand the **Run Script** phase that failed to see the exact error.
