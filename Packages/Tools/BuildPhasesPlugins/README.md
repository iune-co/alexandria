# BuildPhasesPlugins Package
The `BuildPhasesPlugins` package provides a Swift Package Manager plugin that generates build phases commands for linting and generating strings and assets files using SwiftLint and SwiftGen tools.

You can install `BuildPhasesPlugins` using Swift Package Manager. To install it in your Xcode project, follow these steps:

1. Click on File > Add Packages > Add Local.
2. Select the directory that has the `Package.swift` file.
3. Click Add Package.

## Usage
To use the `BuildPhasesPlugins` plugin, you need to add a` BuildToolPlugin` target in your `Package.swift` at the end of the file, as shown below:
```swift
.package(path: "../..Tools/BuildPhasesPlugins"),
```

The `createBuildCommands` function generates build phases commands for the specified target using the `lintCommand` and `swiftGenCommands` helper functions. The `lintCommand` function generates a command to run SwiftLint on the specified target, while the `swiftGenCommands` function generates commands to generate strings and assets files using SwiftGen.

Acknowledgments
The `BuildPhasesPlugins` package uses SwiftLint and SwiftGen tools to generate build phases commands.



