// 
//  VaporOutputEditorView.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 11.06.22.
//

import SwiftUI
import MacSwiftUI

struct VaporOutputEditorView: View {
    @Binding var text: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
            MacEditorControllerView(text: $text)
                .disableAutocorrection(true)
                .font(.monospaced(.body)())
                .shadow(radius: 2)
                .padding(.horizontal)
        } // <-VStack
    }
}
