# swift-restrict-call

A Swift build tool plugin that reports and restricts calls to specific methods or properties in your Swift codebase.

It is useful for enforcing architectural rules or preventing the use of certain APIs.

It provides more rigorous detection than syntax-based analysis.

## Motivtion

If you want to detect the use of URL.init(string:), the following usage patterns are possible, but it is impossible to detect all of them by syntax-based analysis.

```swift
let url = URL.init(string: "") // Easily detectable even on a syntax basis
let url = URL(string: "")　// This is probably detectable as well.

UIApplication.shared.open(.init(string: "")) // Syntax-based detection would be impossible for such a pattern.
```

The tool makes it possible to check exactly which method of which type is being called in which module by referring to the information in the IndexStore.

## Features

- **Restrict method/property calls**: Detect and report usage of specified methods or properties.
- **Customizable reporting**: Choose to report violations as errors or warnings.
- **Configurable via YAML**: Define restricted targets and exclusions in a YAML config file.
- **Build tool plugin**: Integrate with SwiftPM builds for automated checks.

## Requirements

- macOS 13 or later
- Swift 6.0 or later

## Usage

### Plugin

Place the config file and configure the plugin as follows.
This will result in a report at build time.

Add the plugin to your `Package.swift`:

```swift
.plugins([
    .plugin(name: "RestrictCallBuildToolPlugin", package: "restrict-call")
])
```

### Command Line

```sh
restrict-call --config .swift-restrict-call.yml --index-store-path <path>
```

- `--config`: Path to the YAML config file (default: `.swift-restrict-call.yml`)
- `--index-store-path`: Path to the IndexStore directory

### Configuration

Create a `.swift-restrict-call.yml` file in your project root.
Describe the name of the method or property whose invocation you want to restrict **using a regular expression**.

> [!NOTE]
> The method/property name check is based on the demangled symbol name.

```yaml
defaultReportType: warning
targets:
  - reportType: error
    module: "Foundation"
    type: "URL"
    name: "init\\(string:\\)"
  - reportType: error
    module: "Foundation"
    type: "URL"
    name: "path$"
excludedFiles:
  - ".*/DerivedData/.*"
  - "Tests/*"
```

## License

swift-restrict-call is released under the MIT License. See [LICENSE](./LICENSE)
