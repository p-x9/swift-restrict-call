//
//  String+.swift
//  swift-restrict-call
//
//  Created by p-x9 on 2025/08/15
//  
//

extension String {
    package func matches(pattern: String) -> Bool {
        self.range(of: pattern, options: .regularExpression) != nil
    }
}

extension String {
    package func strippingStaticPrefix() -> String {
        guard hasPrefix("static ") else { return self }
        return String(dropFirst("static ".count))
    }
}
