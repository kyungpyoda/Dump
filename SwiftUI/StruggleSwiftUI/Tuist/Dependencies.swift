//
//  Dependencies.swift
//  
//
//  Created by 홍경표 on 2022/09/18.
//

import ProjectDescription

/// Fetch dependencies, make frameworks
let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
//        .remote(url: "https://github.com/devxoul/Then", requirement: .exact("3.0.0")),
    ],
    platforms: [.iOS]
)
