# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_aws_serverless
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps the key screens directly, bypassing `main()` (which calls `Amplify.configure`), so no live AWS backend is required:
  - `SignInPage` with an email typed into the first `TextField` -> `01-sign-in`.
  - `ItemsPage` with `itemsApiProvider` overridden by a `FakeItemsApi` that returns a seeded list of items -> `02-items`.
  - `ItemDetailPage(id: 'a1')` with the same fake API -> `03-item-detail`.
  - `ProfilePage` with `authControllerProvider` overridden by a `FakeAuthController` (no Amplify bootstrap) whose state carries a signed-in email -> `04-profile`.
- Each shot calls `binding.convertFlutterSurfaceToImage()` + `pumpAndSettle()` + `binding.takeScreenshot('NN-name')`.
