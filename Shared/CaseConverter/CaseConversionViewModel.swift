//
//  CaseConversionViewModel.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 04.06.22.
//

import SwiftUI

class CaseConversionViewModel: ObservableObject {
    
    func convert(inputText: String, from inputCase: WordGroupCase, to outputCase: WordGroupCase)  -> String {
        convertGeneric(inputText: inputText, InputStyle: inputCase.textStyle(), OutputStyle: outputCase.textStyle())
    }
    
    func convertGeneric(inputText: String, InputStyle: TextStyle.Type, OutputStyle: TextStyle.Type)  -> String {
        //        var outputList = [String]()
        let outputList = inputText.split(separator: "\n").map { word -> String in
            let input = InputStyle.init(String(word))
            let inputSplit = input.split()
            let output = OutputStyle.init(from: inputSplit)
            return output.content
        }
        return outputList.joined(separator: "\n")
    }
}
