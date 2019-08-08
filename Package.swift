// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleProxy",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "SimpleProxy", targets: ["SimpleProxy"]),
        .executable(name: "SimpleProxy-Sim", targets: ["SimpleProxy-Sim"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
		.package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
		.package(url: "https://github.com/swift-server/async-http-client.git", .branch("master"))
	],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SimpleProxy",
            dependencies: [
            	"SwiftSoup",
            	"NIO",
            	"AsyncHTTPClient"
	]),
		
        .target(
            name: "SimpleProxy-Sim",
            dependencies: ["SimpleProxy"]),
        .testTarget(
            name: "SimpleProxyTests",
            dependencies: ["SimpleProxy"]),
    ]
)
