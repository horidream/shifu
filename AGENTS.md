# Repository Guidelines

## Project Structure & Module Organization

`Shifu/Classes/` contains the main Swift library, grouped by responsibility: `SwiftUI/`, `UI/`, `Model/`, `Extensions/`, `Utils/`, and `core/`. Runtime assets and localizations live under `Shifu/assets/`, `Shifu/en.lproj/`, and `Shifu/zh-Hans.lproj/`. Optional modules are maintained in `Lottie/`, `WebServer/`, and `Services/`, with matching podspecs at the repository root.

`Example/` is the CocoaPods-based sample application and hosts XCTest coverage in `Example/ShifuExampleTests/`. The Vue/Vite markdown frontend lives in `web/src/`; its build output is written to `Shifu/web/` and consumed by the iOS library. Treat generated bundles and dependency lockfiles as outputs of their respective tools.

## Build, Test, and Development Commands

- `cd Example && pod install`: install pods and prepare `Shifu.xcworkspace`.
- `xcodebuild -workspace Example/Shifu.xcworkspace -scheme ShifuExample -sdk iphonesimulator build`: build the example app from the command line.
- `xcodebuild test -workspace Example/Shifu.xcworkspace -scheme ShifuExample -destination 'platform=iOS Simulator,name=iPhone 16'`: run iOS tests; adjust the simulator name to an installed device.
- `cd web && yarn install`: install web dependencies. The local `grogu` dependency must exist at `../../grogu`.
- `cd web && yarn dev`: serve the web app on port `1125`.
- `cd web && yarn build`: rebuild assets consumed from `Shifu/web/`.
- `cd web && yarn test`: run Karma unit tests.

## Coding Style & Naming Conventions

Follow existing Swift style: four-space indentation, `UpperCamelCase` types, `lowerCamelCase` members, and one primary type or related feature group per file. Name extensions by target, such as `StringExtension.swift`; name SwiftUI views with a `View` suffix. Keep public APIs explicitly `public` and avoid unrelated formatting churn. JavaScript under `web/src/` uses ES modules and the surrounding file's formatting. No repository-wide formatter is configured.

## Testing Guidelines

Use XCTest for Swift changes. Place tests in `Example/ShifuExampleTests/`, name files `FeatureTests.swift`, and methods `testExpectedBehavior()`. Add focused regression coverage for shared utilities, notifications, lifecycle behavior, and public APIs. Run affected XCTest and web suites before submitting.

## Commit & Pull Request Guidelines

Recent history uses Conventional Commit prefixes: `feat:`, `fix:`, `refactor:`, and `chore:`. Keep subjects imperative and scoped to one change. Pull requests should explain behavior and validation, link relevant issues, and include screenshots or recordings for UI changes. Call out generated assets, pod changes, and lockfile updates explicitly.
