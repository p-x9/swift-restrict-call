//
//  ReporterProtocol.swift
//  swift-weak-self-check
//
//  Created by p-x9 on 2025/04/20
//  
//

import Foundation

public protocol ReporterProtocol {
    func report(
        _ report: Report
    )
}

extension ReporterProtocol {
    public func report(
        file: String? = nil,
        line: Int? = nil,
        column: Int? = nil,
        type: ReportType,
        content: String
    ) {
        self.report(
            .init(
                position: .init(
                    file: file,
                    line: line,
                    column: column
                ),
                type: type,
                content: content
            )
        )
    }
}
