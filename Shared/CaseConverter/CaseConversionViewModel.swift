//
//  CaseConversionViewModel.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 04.06.22.
//

import SwiftUI

class CaseConversionViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var outputText: String = ""

    func convert(from inputCase: WordGroupCase, to outputCase: WordGroupCase) {
        convertGeneric(InputStyle: inputCase.textStyle(), OutputStyle: outputCase.textStyle())
    }

    func convertGeneric(InputStyle: TextStyle.Type, OutputStyle: TextStyle.Type) {
//        var outputList = [String]()
        let outputList = inputText.split(separator: "\n").map { word -> String in
            let input = InputStyle.init(String(word))
            let inputSplit = input.split()
            let output = OutputStyle.init(from: inputSplit)
            return output.content
        }
        outputText = outputList.joined(separator: "\n")
    }
}
