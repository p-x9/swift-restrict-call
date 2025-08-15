//
//  Config.swift
//  swift-restrict-call
//
//  Created by p-x9 on 2025/08/15
//  
//

import Foundation
import SourceReporter
import RestrictCallCore

struct Config: Codable {
    var defaultReportType: ReportType?
    var targets: [RestrictedTarget]
    var excludedFiles: [String]?
}
