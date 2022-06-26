//
//  VaporCodeFinalView.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

import SwiftUI

let toolVaporNewMode = Tool(sidebarName: "Vapor Code Generator", navigationTitle: "Vapor Model, Controller, and Migration for a New Model")

struct VaporCodeFinalView: View {
    @Binding var selectedTool: Tool?
    @StateObject var vm = VaporCodeViewModel()
    
    @State var outputModelCode: String = ""
    @State var outputMigrationCode: String = ""
    @State var outputControllerCode: String = ""
    @State var outputAdmin: String = "Coming soon..."
    
    var generateCodeButton: some View {
        Button {
            vm.createModel()
            outputModelCode = vm.generateModelCode()
            outputMigrationCode = vm.generateMigration()
            outputControllerCode = vm.generateController()
        } label: {
            Text("Generate")
        } // <-Button
    }
    
    var myView: some View {
        VStack {
            TextField(text: $vm.modelName, prompt: Text("ModelName")) {
                Text("Model Name")
                    .font(.body)
            }
            .font(.monospaced(.body)())
            .frame(width: 250, alignment: .center)
            .padding(.top)
            
            Text("Model Properties").font(.title3).padding()
            
            FormVaporPropertyView(properties: $vm.properties) // .equatable()
            
            generateCodeButton.padding(.top)
            
            VSplitView {
                HSplitView {
                    VaporOutputEditorView(text: $outputModelCode, title: "Model")
                    VaporOutputEditorView(text: $outputMigrationCode, title: "Migration")
                } // <-HSplitView
                HSplitView {
                    VaporOutputEditorView(text: $outputControllerCode, title: "Controller")
                    VaporOutputEditorView(text: $outputAdmin, title: "Admin")
                } // <-HSplitView
                .padding(.top)
            } // <-VSplitView
            PoppedButton()
                .padding(.bottom)
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

// struct VaporCodeFinalView_Previews: PreviewProvider {
//    static var previews: some View {
//        VaporCodeFinalView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
