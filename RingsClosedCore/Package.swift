// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "RingsClosedCore",
    platforms: [
        .iOS(
            .v17
        ),
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "AppDelegateFeature",
            targets: ["AppDelegateFeature"]
        ),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "LoggingClient",
            targets: ["LoggingClient"]
        ),
        .library(
            name: "LogsFeature",
            targets: ["LogsFeature"]
        ),
        .library(
            name: "ShareFeature",
            targets: ["ShareFeature"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/CheekyGhost-Labs/OSLogClient.git",
            from: "0.5.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.10.4"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies.git",
            from: "1.3.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-tagged.git",
            from: "0.10.0"
        ),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "AppDelegateFeature",
                "LoggingClient",
                "LogsFeature",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "AppDelegateFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "DesignSystem"
        ),
        .target(
            name: "LoggingClient",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                ),
                .product(
                    name: "DependenciesMacros",
                    package: "swift-dependencies"
                ),
                .product(
                    name: "OSLogClient",
                    package: "OSLogClient"
                ),
            ]
        ),
        .target(
            name: "LogsFeature",
            dependencies: [
                "DesignSystem",
                "LoggingClient",
                "ShareFeature",
                .product(
                    name: "Algorithms",
                    package: "swift-algorithms"
                ),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "Tagged",
                    package: "swift-tagged"
                ),
            ]
        ),
        .target(
            name: "ShareFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
    ]
)
