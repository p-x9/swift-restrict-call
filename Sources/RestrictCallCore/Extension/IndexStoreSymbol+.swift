//
//  IndexStoreSymbol+.swift
//
//
//  Created by p-x9 on 2024/06/14
//
//

import Foundation
import SwiftIndexStore

extension IndexStoreSymbol {
    var demangledName: String? {
        guard let usr else { return nil }

        // swift symbol
        if usr.hasPrefix("s:") {
            let index = usr.lastIndex(of: ":").map { usr.index($0, offsetBy: -1) }
            if let index {
                var symbol = String(usr[index...])
                symbol.replaceSubrange(symbol.startIndex...symbol.index(symbol.startIndex, offsetBy: 1), with: "$S")
                return stdlib_demangleName(symbol)
            }
        }
        return stdlib_demangleName(usr)
    }
}
