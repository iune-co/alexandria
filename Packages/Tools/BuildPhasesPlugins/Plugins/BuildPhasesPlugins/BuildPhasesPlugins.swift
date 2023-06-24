import Foundation
import PackagePlugin

@main
struct BuildPhasesPlugins: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        var commands = [Command]()
        try commands.append(lintCommand(context: context, target: target))
        try commands.append(contentsOf: swiftGenCommands(implementationTarget: target, in: context))
        return commands
    }

    private func lintCommand(context: PluginContext, target: Target) throws -> Command {
        let toolPath = try context.tool(named: "swiftlint")

        return Command.prebuildCommand(
            displayName: "Linting \(target.name)",
            executable: toolPath.path,
            arguments: [
                "lint", // Run linting on the specified target
                "--config", // Load the swiftlint rules
                toolPath.path.removingLastComponent().removingLastComponent().appending("swiftlint.yml"),
                "--cache-path", // Lint caching path
                "/private/tmp",
                target.directory.string
            ],
            outputFilesDirectory: context.pluginWorkDirectory
        )
    }

    private func swiftGenCommands(implementationTarget target: Target, in context: PluginContext) throws -> [Command] {
        let isImplementationModule = !(target.name.contains("Interface") || target.name.contains("Mocks") || target.name.contains("Tests"))
        guard isImplementationModule else { return [] }

        let executable = try context.tool(named: "swiftgen").path
        let generatedFilesFolder = target.directory.appending("Generated")
        var swiftGenCommands = [Command]()

        // Find the english localizable file to build the strings from it
        if let strings = try filePaths(in: target.directory.string, suffix: "en.lproj/Localizable.strings") {
            if FileManager.default.fileExists(atPath: generatedFilesFolder.string) == false {
                try FileManager.default.createDirectory(atPath: generatedFilesFolder.string, withIntermediateDirectories: true)
            }

            let inputFile = target.directory.appending(strings)
            let content = try String(
                contentsOf: .init(fileURLWithPath: inputFile.string),
                encoding: .utf8
            )
            if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                let outputFiles = generatedFilesFolder.appending("Strings.swift")
                swiftGenCommands.append(
                    .prebuildCommand(
                        displayName: "Swiftgen strings \(target.name)",
                        executable: executable,
                        arguments: [
                            "run",
                            "strings", // Specified generated . String in this case because we're generating localizables
                            "--templateName",
                            "structured-swift5", // This structres the generated file in enum and inner enums
                            "--param", "enumName=Localizables", // This will make the main enum named `Localizables` instead of `L10n`
                            "--param", "noComments", // This will not add any comments to the localizable file
                            "--output", "\(generatedFilesFolder)/Strings.swift",
                            inputFile
                        ],
                        outputFilesDirectory: outputFiles
                    )
                )
            }
        }

        return swiftGenCommands
    }

    private func filePaths(in urlPath: String, suffix: String) throws -> String? {
        FileManager.default
            .enumerator(atPath: urlPath)?
            .allObjects
            .compactMap { $0 as? String }
            .first { $0.hasSuffix(suffix) }
    }
}

