//
//  TargetDependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍경표 on 2022/09/18.
//

import ProjectDescription

/// Modules
extension TargetDependency {}

/// Package Products
extension TargetDependency {
    public struct SPM {
        public static let Then = TargetDependency.external(name: "Then")
    }
}

/// Source
public extension SourceFileGlob {
    static let sources = SourceFileGlob("Sources/**")
    static let tests = SourceFileGlob("Tests/**")
}

///
public enum ResourceType: String {
    case xibs = "Sources/**/*.xib"
    case storyboards = "Resources/**/*.storyboard"
    case assets = "Resources/**"
}

public extension ResourceFileElements {
    static func resources(with resources: [ResourceType]) -> ResourceFileElements {
        return .init(
            resources: resources.map({ ResourceFileElement(stringLiteral: $0.rawValue) })
        )
    }
}
