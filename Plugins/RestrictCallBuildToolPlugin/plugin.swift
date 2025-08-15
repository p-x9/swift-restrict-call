//
//  IndexStoreDebugBuildToolPlugin.swift
//
//
//  Created by p-x9 on 2025/08/09
//
//

import Foundation
import PackagePlugin

@main
struct RestrictCallBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        createBuildCommands(
            packageDirectory: context.package.directoryURL,
            workingDirectory: context.pluginWorkDirectoryURL,
            tool: try context.tool(named: "restrict-call")
        )
    }

    private func createBuildCommands(
        packageDirectory: URL,
        workingDirectory: URL,
        tool: PluginContext.Tool
    ) -> [Command] {
        let configuration = packageDirectory.firstConfigurationFileInParentDirectories()

        var arguments: [String] = []

        if let configuration {
            arguments += [
                "--config", configuration.path
            ]
        }

        return [
            .buildCommand(
                displayName: "RestrictCallBuildToolPlugin",
                executable: tool.url,
                arguments: arguments
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension RestrictCallBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return createBuildCommands(
            packageDirectory: context.xcodeProject.directoryURL,
            workingDirectory: context.pluginWorkDirectoryURL,
            tool: try context.tool(named: "restrict-call")
        )
    }
}
#endif

// ref: https://github.com/realm/SwiftLint/blob/main/Plugins/SwiftLintPlugin/Path%2BHelpers.swift
extension URL {
    func firstConfigurationFileInParentDirectories() -> URL? {
        let defaultConfigurationFileNames = [
            ".swift-restrict-call.yml"
        ]
        let proposedDirectories = sequence(
            first: self,
            next: { path in
                guard path.pathComponents.count > 1 else {
                    // Check we're not at the root of this filesystem, as `removingLastComponent()`
                    // will continually return the root from itself.
                    return nil
                }

                return path.deletingLastPathComponent()
            }
        )

        for proposedDirectory in proposedDirectories {
            for fileName in defaultConfigurationFileNames {
                let potentialConfigurationFile = proposedDirectory.appending(path: fileName)
                if potentialConfigurationFile.isAccessible() {
                    return potentialConfigurationFile
                }
            }
        }
        return nil
    }

    /// Safe way to check if the file is accessible from within the current process sandbox.
    private func isAccessible() -> Bool {
        let result = path.withCString { pointer in
            access(pointer, R_OK)
        }

        return result == 0
    }
}
