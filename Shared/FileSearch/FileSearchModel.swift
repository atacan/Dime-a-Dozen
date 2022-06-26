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
    var url: URL  {
        URL(fileURLWithPath: path)
    }
}

class FileSearch: ObservableObject {
    @Published var searchText: String = ""
    var pickedPath = ""
//    @Published var foundFiles: [String] = []
    @Published var foundFiles: [FileModel] = []
//    @Published var selectedFile: String = ""
    @Published var selectedFile: FileModel? = nil // .init(name: "")
    @Published var selectedFileContent: String = ""
    var cancellables: Set<AnyCancellable> = []

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
                if let selectedPath = openPanel.url?.path.escapingSpaces(), let searchText = self?.searchText {
                    self?.pickedPath = selectedPath
                    let command = "grep -rl '\(searchText)' \(selectedPath)"
                    do {
                        print(command)
                        self?.foundFiles = try safeShell(command).components(separatedBy: "\n").map { name in
                            FileModel(path: name)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func selectedFile(_ id: UUID?) {
        if let file = foundFiles.first(where: { $0.id == id }) {
            selectedFile = file
        }
    }

    func makePublishers() {
        $selectedFile.sink { file in
            do {
                if let fileUnwrap = file {
                    self.selectedFileContent = try String(contentsOfFile: fileUnwrap.path)
                }
            } catch {
                self.selectedFileContent = error.localizedDescription
            }
        }
        .store(in: &cancellables)
    }
}
