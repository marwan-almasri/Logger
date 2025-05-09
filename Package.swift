// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Logger",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Logger",
            targets: ["Logger"]
        ),
        .library(
            name: "LoggerInterface",
            targets: ["LoggerInterface"]
        ),
        .library(
            name: "LoggerMocks",
            targets: ["LoggerMocks"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: [
                "LoggerInterface"
            ]
        ),
        .target(
            name: "LoggerInterface",
            dependencies: []
        ),
        .target(
            name: "LoggerMocks",
            dependencies: [
                "LoggerInterface"
            ]
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: [
                "Logger",
                "LoggerMocks",
                .product(name: "Testing", package: "swift-testing")
            ]
        ),
    ]
)
