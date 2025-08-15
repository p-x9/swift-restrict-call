//
//  IndexStoreOccurrence+.swift
//  swift-restrict-call
//
//  Created by p-x9 on 2025/08/16
//  
//

import Foundation
import SwiftIndexStore

extension IndexStoreOccurrence {
    var shouldReportIfSymbolMatched: Bool {
        if [.constructor].contains(symbol.kind) {

        }
        return false
    }
}
