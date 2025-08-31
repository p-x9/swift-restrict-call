//
//  RestrictedTarget.swift
//  swift-restrict-call
//
//  Created by p-x9 on 2025/08/15
//  
//

import Foundation
import SourceReporter

public struct RestrictedTarget: Sendable, Codable {
    public let reportType: ReportType?
    public let module: String?
    public let type: String?
    public let name: String

    public init(
        reportType: ReportType?,
        module: String?,
        type: String?,
        name: String
    ) {
        self.reportType = reportType
        self.module = module
        self.type = type
        self.name = name
    }
}

extension RestrictedTarget {
    var demangledName: String {
        [module, type, name]
            .compactMap { $0 }
            .joined(separator: "\\.")
    }
}
