// 
//  VaporCodeFinalView.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 11.06.22.
//

import SwiftUI

let toolVaporNewMode = Tool(sidebarName: "Vapor Code Generator", navigationTitle: "Vapor Model, Controller, and Migration for a New Model")

struct VaporCodeFinalView: View {
    @Binding var selectedTool: Tool?
    @StateObject var vm = VaporCodeViewModel()
    
    @State var modelName: String = ""
    @State var outputModelCode: String = ""
    
    
    var generateCodeButton: some View {
        Button {
            outputModelCode = vm.generateModelCode()
        } label: {
            Text("Generate")
        } // <-Button
    }
    
    var myView: some View {
        VStack {
            TextField(text: $modelName, prompt: Text("ModelName")) {
                Text("Model Name")
            }
            .frame(width: 250, alignment: .center)
            .padding(.top)
            
            Text("Model Properties").font(.title3).padding()
            
            FormVaporPropertyView(properties: $vm.properties)//.equatable()
            
            generateCodeButton.padding(.top)
            
            VaporOutputEditorView(text: $outputModelCode, title: "Model")
        } // <-VStack
        .navigationTitle(toolVaporNewMode.navigationTitle)
        .toolbar {
            ToolbarItem {
                Button {
                    print("more info clicked")
                } label: {
                    Image(systemName: "info")
                }
                .help("More info...")
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: myView, tag: toolVaporNewMode, selection: $selectedTool) {
            Text(toolVaporNewMode.sidebarName)
        } // <-NavigationLink
    }
}

//struct VaporCodeFinalView_Previews: PreviewProvider {
//    static var previews: some View {
//        VaporCodeFinalView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
