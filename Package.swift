// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shifu",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Shifu",
            targets: ["Shifu"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "FMDB", url: "https://github.com/ccgus/fmdb", from: "2.7.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Shifu",
            dependencies: ["FMDB",
                           .product(name: "RxSwift", package: "RxSwift"),
                           .product(name: "RxCocoa", package: "RxSwift")],
            path: "Shifu/Classes"
        ),
            
//        .testTarget(
//            name: "ShifuTest",
//            dependencies: ["Shifu"])
    ]
)
