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
