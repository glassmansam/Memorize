// swift-tools-version: 5.8
//
//  Package.swift
//  Memorize
//

import PackageDescription

let package = Package(
    name: "Flashcards",
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main"),
        .package(url: "https://git.aparoksha.dev/aparoksha/localized", branch: "main"),
        .package(url: "https://github.com/truizlop/FuzzyFind", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "CWebKit",
            path: "Sources/CWebKit",
            sources: ["webkit_wrapper.c"],
            publicHeadersPath: ".",
            cSettings: [
                .unsafeFlags(["-I/usr/include/webkitgtk-6.0", "-I/usr/include/gtk-4.0", "-I/usr/include/glib-2.0", "-I/usr/lib/x86_64-linux-gnu/glib-2.0/include"])
            ],
            linkerSettings: [
                .linkedLibrary("webkitgtk-6.0")
            ]
        ),
        .executableTarget(
            name: "Flashcards",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift"),
                .product(name: "Localized", package: "Localized"),
                .product(name: "FuzzyFind", package: "FuzzyFind"),
                "CWebKit"
            ],
            path: "Sources",
            exclude: ["CWebKit"],
            resources: [.process("Model/Localized.yml")],
            plugins: [.plugin(name: "GenerateLocalized", package: "Localized")]
        )
    ]
)
