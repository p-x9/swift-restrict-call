//
//  CallbackReporter.swift
//  swift-weak-self-check
//
//  Created by p-x9 on 2025/04/23
//  
//

import Foundation

public struct CallbackReporter: ReporterProtocol {
    public typealias Callback = (Report) -> Void

    let callback: Callback

    public init(callback: @escaping Callback) {
        self.callback = callback
    }

    public func report(_ report: Report) {
        callback(report)
    }
}
