// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-restrict-call",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            "509.0.0"..<"602.0.0"
        ),
        .package(
            url: "https://github.com/kateinoigakukun/swift-indexstore.git",
            from: "0.3.0"
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
            ]
        ),
        .target(
            name: "RestrictCallCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftIndexStore", package: "swift-indexstore"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SourceReporter", package: "swift-source-reporter"),
            ]
        ),
    ]
)
