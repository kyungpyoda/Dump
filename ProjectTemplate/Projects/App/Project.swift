//
//  Project.swift
//  Manifests
//
//  Created by 홍경표 on 2022/09/18.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
    name: TemplateConstants.appName,
    product: .app,
    packages: [],
    dependencies: [
        .SPM.Then
    ],
    infoPlist: "Supporting/Info.plist",
    sources: [
        .sources,
    ],
    resources: .resources(with: [
        .storyboards,
        .assets
    ]),
    settings: .settings(base: [:]),
    schemes: []
)
