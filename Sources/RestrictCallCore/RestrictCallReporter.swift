//
//  RestrictCallReporter.swift
//  swift-restrict-call
//
//  Created by p-x9 on 2025/08/15
//  
//

import Foundation
import SwiftIndexStore
import SourceReporter

public final class RestrictCallReporter {
    public let defaultReportType: ReportType
    public let reporter: any ReporterProtocol
    public let targets: [RestrictedTarget]
    public let excludedFiles: [String]
    public let indexStore: IndexStore

    public init(
        defaultReportType: ReportType,
        reporter: any ReporterProtocol,
        targets: [RestrictedTarget],
        excludedFiles: [String],
        indexStore: IndexStore
    ) {
        self.defaultReportType = defaultReportType
        self.reporter = reporter
        self.targets = targets
        self.excludedFiles = excludedFiles
        self.indexStore = indexStore
    }
}

extension RestrictCallReporter {
    public func run() throws {
        try indexStore.forEachUnits(includeSystem: false) { unit in
            try indexStore.forEachRecordDependencies(for: unit) { dependency in
                guard case let .record(record) = dependency else {
                    return true
                }
                try indexStore.forEachOccurrences(for: record) { occurrence in
                    reportIfNeeded(for: occurrence)
                    return true
                } // forEachOccurrences
                return true
            } // forEachRecordDependencies
            return true
        } // forEachUnits
    }
}

extension RestrictCallReporter {
    private func reportIfNeeded(for occurrence: IndexStoreOccurrence) {
        if let path = occurrence.location.path,
           excludedFiles.contains(where: { path.matches(pattern: $0) }) {
            return
        }

        let symbol = occurrence.symbol
        let demangledName = symbol.demangledName ?? symbol.name ?? ""

        for target in self.targets {
            let roles = occurrence.roles
            guard symbol.matches(target: target),
                  roles.contains([.reference, .call]) else {
                continue
            }
            reporter.report(
                file: occurrence.location.path,
                line: numericCast(occurrence.location.line),
                column: numericCast(occurrence.location.column),
                type: target.reportType ?? defaultReportType,
                content: "[restrict-call] `\(target.demangledName)` calls are restricted."
            )
            break
        }
    }
}
