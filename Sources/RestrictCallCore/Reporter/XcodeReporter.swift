//
//  Reporter.swift
//
//
//  Created by p-x9 on 2024/06/04
//  
//

import Foundation

public struct XcodeReporter: ReporterProtocol {
    public init() {}
    
    public func report(
        _ report: Report
    ) {
        let type = report.type
        let position = report.position
        let content = report.content

        if let file = position.file {
            if let line = position.line {
                if let column = position.column {
                    print("\(file):\(line):\(column): \(type): \(content)")
                } else {
                    print("\(file):\(line): \(type): \(content)")
                }
            } else {
                print("\(file): \(type): \(content)")
            }
        } else {
            print("\(type): \(content)")
        }
    }
}
