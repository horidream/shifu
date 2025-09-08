# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Shifu is a cross-platform library that provides a web-based markdown editor and viewer with native iOS integration. It consists of three main components:

1. **iOS/macOS Library** - Swift-based CocoaPods library with UI components and native bridge
2. **Web Application** - Vue.js-based markdown editor with syntax highlighting and theming
3. **Example Project** - iOS app demonstrating library features

## Commands

### Web Development
```bash
# Navigate to web directory first
cd web

# Development server (recommended for active development)
yarn go              # Runs dev server + build watch + lib watch concurrently

# Individual commands
yarn dev             # Start development server on port 1125
yarn build           # Build and watch for changes
yarn lib             # Build library configuration and watch
yarn build-cloud     # Production build
yarn test            # Run Karma unit tests
```

### iOS Development
```bash
# Install CocoaPods dependencies
cd Example && pod install

# Build and test
pod lib lint Shifu.podspec
```

## Architecture

### Web Application (`web/`)
- **Framework**: Vue.js 3 with Vite build system
- **Entry Point**: `src/main.js` - Sets up Vue app with markdown functionality
- **Core Model**: `src/model.js` - Integrates grogu library for native communication
- **Build Output**: `../Shifu/web/` directory (consumed by iOS library)
- **Key Features**:
  - Real-time markdown editing with live preview
  - Syntax highlighting via highlight.js
  - KaTeX math rendering
  - Theme switching (auto/dark/light)
  - Native bridge communication via webkit

### iOS Library (`Shifu/Classes/`)
- **Core Components**:
  - `core/` - JSON handling, icons, buildable protocols
  - `Animation/` - Tween animations and layer effects
  - `Utils/` - Bridge communication, theme management, cloud utilities
  - `UI/` - Custom UI components (tab bars, flow layouts, drawing views)
- **Dependencies**: ReachabilitySwift, SwiftUIIntrospect, RxSwift
- **Resources**: Embeds web build output for WebKit rendering

### Native-Web Bridge
- **Communication**: JavaScript `postToNative()` function for iOS ↔ Web messaging
- **Shared State**: Theme preferences, content synchronization
- **Debug Mode**: Enabled when not running in webkit context

## Key Files

- `web/vite.config.js` - Build configuration with custom output paths
- `Shifu.podspec` - CocoaPods specification (v0.7.12)
- `Package.swift` - Swift Package Manager configuration
- `web/src/main.js` - Vue app initialization with native integration
- `web/src/model.js` - Core markdown processing and native bridge setup

## Development Workflow

1. **Web Changes**: Use `yarn go` in `web/` directory for live reloading
2. **iOS Integration**: Build web assets first, then test in Example project
3. **Testing**: Run web tests with `yarn test`, iOS testing via Xcode/pod lint
4. **Distribution**: Version managed in `Shifu.podspec` for CocoaPods releases