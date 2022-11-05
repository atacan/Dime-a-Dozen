// https://github.com/atacan/
// 29.05.22
//

import Combine
import Dependencies
import Prelude
import SwiftUI

extension String {
    func escapingSpaces() -> Self {
        replacingOccurrences(of: " ", with: #"\ "#)
    }
}

struct FileModel: Identifiable {
    let id = UUID()
    let path: String
    var url: URL {
        URL(fileURLWithPath: path)
    }
}

class FileSearch: ObservableObject {
    @Published var searchText: String = ""
    @Published var pickedPath = ""
    @Published var foundFiles: [FileModel] = []
    @Published var selectedFile: FileModel? = nil // .init(name: "")
//    @Published var selectedFileContent: String = ""
    @Published var selectedFileContent: AttributedString = ""
    @Published var isSearching = false
    @Published var contentBackgroundColor = Color(nsColor: .textBackgroundColor)
    var cancellables: Set<AnyCancellable> = []

    @Dependency(\.swiftHighlightClient) var swiftHighlightClient
    @Dependency(\.jsonClient) var jsonClient

    init() {
        makePublishers()
    }

    func filePicker() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            foundFiles = [FileModel(path: "insert a text to search for")]
            return
        }
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.begin { [weak self] result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let selectedPath = openPanel.url?.path.escapingSpaces() {
                    self?.isSearching = true
                    self?.pickedPath = selectedPath
                }
            }
        }
    }

    func selectedFile(_ id: UUID?) {
        if let file = foundFiles.first(where: { $0.id == id }) {
            selectedFile = file
        }
    }

    func runCommand(_ command: String) async -> [FileModel] {
        do {
            let shellOutput = try safeShell(command)
            guard !shellOutput.isEmpty else { return [] }

            let lines = shellOutput.components(separatedBy: "\n")
            return lines.map { name in
                FileModel(path: name)
            }
        } catch {
            return [FileModel(path: error.localizedDescription)]
        }
    }

    @MainActor
    func readFile(contentsOfFile url: URL) async {
        do {
            selectedFileContent = ""
            for try await line in url.lines {
//                selectedFileContent.append(line + "\n")
                selectedFileContent.append(AttributedString(stringLiteral: line + "\n"))
            }
            switch selectedFile?.url.pathExtension {
            case "swift":
                let text = (selectedFileContent |> String.init).removingSuffix("{\n}")
                selectedFileContent = try AttributedString(swiftHighlightClient.convert(text))
            case "json", "resolved":
                let text = (selectedFileContent |> String.init).removingSuffix("{\n}")
                selectedFileContent = try await AttributedString(jsonClient.convert(text))
            default:
                break
            }
        } catch {
            selectedFileContent = AttributedString(stringLiteral: error.localizedDescription)
        }
    }

    func readFile(contentsOfFile path: String) -> String {
        do {
            let content = try String(contentsOfFile: path)
            return content
        } catch {
            return error.localizedDescription
        }
    }

    func makePublishers() {
        $selectedFile
//            .receive(on: RunLoop.main)
                .asyncMap { file in
                    if let fileUnwrap = file {
                        await self.readFile(contentsOfFile: fileUnwrap.url)
                    }
                }
                .sink(receiveValue: { _ in
                    //
                })
                .store(in: &cancellables)

        $pickedPath
            .asyncMap { selectedPath -> [FileModel] in
                guard !selectedPath.isEmpty else {
                    return [FileModel(path: "No directory selected")]
                }
                let command = "grep -rl '\(self.searchText)' \(selectedPath)"
                let files = await self.runCommand(command)

                if files.isEmpty {
                    return [FileModel(path: "No files found in \(selectedPath)")]
                }
                return files
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] files in
                self?.foundFiles = files
                self?.isSearching = false
            }
            .store(in: &cancellables)
    }
}

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
