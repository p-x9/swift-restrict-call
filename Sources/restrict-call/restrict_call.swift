import Foundation
import ArgumentParser
import SwiftIndexStore
import Yams
import SourceReporter
import RestrictCallCore

@main
struct restrict_call: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "restrict-call",
        abstract: "Reports and restricts calls to specific methods/properties.",
        shouldDisplay: true,
        helpNames: [.long, .short]
    )

    @Option(help: "Report as `error` or `warning` (default: warning)")
    var reportType: ReportType?

    @Option(
        help: "Config",
        completion: .file(extensions: ["yml", "yaml"])
    )
    var config: String = ".swift-restrict-call.yml"

    @Option(
        help: "Path for IndexStore",
        completion: .directory
    )
    var indexStorePath: String?

    var targets: [RestrictedTarget] = []
    var excludedFiles: [String] = []
    var onlyModules: [String]? = nil
    var excludeModules: [String] = []

    lazy var indexStore: IndexStore? = {
        if let indexStorePath = indexStorePath ?? environmentIndexStorePath,
           FileManager.default.fileExists(atPath: indexStorePath) {
            let url = URL(fileURLWithPath: indexStorePath)
            return try? .open(store: url, lib: .open())
        } else {
            return nil
        }
    }()

    mutating func run() throws {
        guard let indexStore else {
            fatalError("No IndexStore found at specified path or in environment variable BUILD_DIR")
        }
        try readConfig()
        let reporter = RestrictCallReporter(
            defaultReportType: reportType ?? .warning,
            reporter: XcodeReporter(),
            targets: targets,
            excludedFiles: excludedFiles,
            onlyModules: onlyModules,
            excludeModules: excludeModules,
            indexStore: indexStore
        )
        try reporter.run()
    }
}

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
extension restrict_call: AsyncParsableCommand {
    mutating func run() async throws {
        guard let indexStore else {
            fatalError("No IndexStore found at specified path or in environment variable BUILD_DIR")
        }
        try readConfig()
        let reporter = RestrictCallReporter(
            defaultReportType: reportType ?? .warning,
            reporter: XcodeReporter(),
            targets: targets,
            excludedFiles: excludedFiles,
            onlyModules: onlyModules,
            excludeModules: excludeModules,
            indexStore: indexStore
        )
        try await reporter.runConcurrently()
    }
}

extension restrict_call {
    private mutating func readConfig() throws {
        guard FileManager.default.fileExists(atPath: config) else {
            return
        }
        let url = URL(fileURLWithPath: config)
        let decoder = YAMLDecoder()

        let data = try Data(contentsOf: url)
        let config = try decoder.decode(Config.self, from: data)

        targets = config.targets
        excludedFiles = config.excludedFiles ?? []
        onlyModules = config.onlyModules
        excludeModules = config.excludeModules ?? []

        if reportType == nil {
            self.reportType = config.defaultReportType
        }
    }
}

extension restrict_call {
    var environmentIndexStorePath: String? {
        let environment = ProcessInfo.processInfo.environment
        guard let buildDir = environment["BUILD_DIR"] else { return nil }
        let url = URL(fileURLWithPath: buildDir)
        return url
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "Index.noindex/DataStore/")
            .path()
    }
}

extension XcodeReporter: @retroactive @unchecked Sendable {}
