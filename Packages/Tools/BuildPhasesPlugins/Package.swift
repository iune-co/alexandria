// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildPhasesPlugins",
    products: [
        .plugin(name: "BuildPhasesPlugins", targets: ["BuildPhasesPlugins"]),
        .library(name: "SwiftLint", targets: ["SwiftLint"])
    ],
    dependencies: [],
    targets: [
        .plugin(
            name: "BuildPhasesPlugins",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftLint"),
                .target(name: "swiftgen")
            ]
        ),
        .binaryTarget(
            name: "SwiftLint",
            path: "./ArtifactBundles/SwiftLint.artifactbundle"
        ),
        .binaryTarget(
            name: "swiftgen",
            path: "./ArtifactBundles/swiftgen.artifactbundle"
        )
    ]
)
