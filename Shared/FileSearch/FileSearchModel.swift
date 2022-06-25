// https://github.com/atacan/
// 29.05.22
//

import Combine
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
//    @Published var foundFiles: [String] = []
    @Published var foundFiles: [FileModel] = []
//    @Published var selectedFile: String = ""
    @Published var selectedFile: FileModel? = nil // .init(name: "")
    @Published var selectedFileContent: String = ""
    @Published var isSearching = false
    var cancellables: Set<AnyCancellable> = []

    init() {
        makePublishers()
    }

    func filePicker() {
        guard !searchText.isEmpty else {
            foundFiles = [FileModel(path: "Insert a text to search for")]
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

    func readFile(contentsOfFile path: String) async -> String {
        do {
            let content = try String(contentsOfFile: path)
            return content
        } catch {
            return error.localizedDescription
        }
    }

    func makePublishers() {
        $selectedFile
            .asyncMap { file -> String in
                if let fileUnwrap = file {
                    return await self.readFile(contentsOfFile: fileUnwrap.path)
                } else {
                    return "No file selected"
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] content in
                self?.selectedFileContent = content
            }
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
