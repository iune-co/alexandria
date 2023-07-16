// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "NetworkServiceInterface",
            targets: ["NetworkServiceInterface"]
        ),
        .library(
            name: "NetworkServiceMocks",
            targets: ["NetworkServiceMocks"]
        )
    ],
    dependencies: [
        .package(path: "../..Tools/BuildPhasesPlugins"),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [
                .target(name: "NetworkServiceInterface")
            ]
        ),
        .target(
            name: "NetworkServiceInterface",
            dependencies: []
        ),
        .target(
            name: "NetworkServiceMocks",
            dependencies: [
                "NetworkServiceInterface"
            ]
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: [
                "NetworkService",
                "NetworkServiceMocks"
            ]
        ),
    ]
)

package.targets.forEach {
    $0.dependencies.append(
        .product(name: "BuildPhasesPlugins", package: "BuildPhasesPlugins")
    )
}
