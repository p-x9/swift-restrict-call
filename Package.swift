// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-restrict-call",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .plugin(
            name: "RestrictCallBuildToolPlugin",
            targets: ["RestrictCallBuildToolPlugin"]
        ),
        .executable(
            name: "restrict-call",
            targets: ["restrict-call"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/kateinoigakukun/swift-indexstore.git",
            from: "0.3.0"
        ),
        .package(
            url: "https://github.com/jpsim/Yams.git",
            from: "5.0.1"
        ),
        .package(
            url: "https://github.com/p-x9/swift-source-reporter.git",
            from: "0.2.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "restrict-call",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftIndexStore", package: "swift-indexstore"),
                .product(name: "Yams", package: "Yams"),
                "RestrictCallCore",
            ]
        ),
        .target(
            name: "RestrictCallCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftIndexStore", package: "swift-indexstore"),
                .product(name: "SourceReporter", package: "swift-source-reporter"),
            ]
        ),
        .plugin(
            name: "RestrictCallBuildToolPlugin",
            capability: .buildTool(),
            dependencies: [
                "restrict-call"
            ]
        ),
    ]
)
