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
    @State var showMoreInfo: Bool = false
    
//    @State var outputModelCode: String = ""
//    @State var outputMigrationCode: String = ""
//    @State var outputControllerCode: String = ""
    @State var outputAdmin: String = "Coming soon..."
    
    enum Focus : Hashable {
        case fieldModelName
    }
       
    @FocusState var focus : Focus?
    
    var generateCodeButton: some View {
        Button {
            vm.generate()
        } label: {
            Text("Generate")
        } // <-Button
        .keyboardShortcut(.defaultAction)
    }
    
    var myView: some View {
        VStack {
            TextField(text: $vm.modelName, prompt: Text("ModelName")) {
                Text("Model Name")
                    .font(.body)
            }
            .font(.monospaced(.body)())
            .font(.bold(.title3)())
            .frame(width: 250, alignment: .center)
            .padding(.top)
            .focused($focus, equals: .fieldModelName) // doesn't work
            
            Text("Model Properties").font(.title3).padding()
            
            FormVaporPropertyView(properties: $vm.properties) // .equatable()
            
            HStack(alignment: .bottom) {
                PoppedButton()
                generateCodeButton.padding(.top)
            }
            
            VSplitView {
                HSplitView {
                    VaporOutputEditorView(text: $vm.codeModel, title: "Model")
                    VaporOutputEditorView(text: $vm.codeMigration, title: "Migration")
                } // <-HSplitView
                HSplitView {
                    VaporOutputEditorView(text: $vm.codeContoller, title: "Controller")
                    VaporOutputEditorView(text: $outputAdmin, title: "Admin")
                } // <-HSplitView
                .padding(.top)
            } // <-VSplitView
            Button("Save to Files") {
                vm.saveFiles()
            }
                .padding(.bottom)
        } // <-VStack
        .onAppear(perform: {
            self.focus = .fieldModelName
        })
        .navigationTitle(toolVaporNewMode.navigationTitle)
        .toolbar {
            ToolbarItem {
                Button {
                    showMoreInfo.toggle()
                } label: {
                    Image(systemName: "info")
                }
                .popover(isPresented: $showMoreInfo, content: {
                    Text("It will generate the code that you can edit before saving")
                        .padding()
                })
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
