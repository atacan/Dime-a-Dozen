// 
//  FieldPropertyWrapperView.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

import SwiftUI

struct FieldPropertyWrapperView: View {
    @Binding var input: VaporProperty.FluentPropertyWrapper
    
    var body: some View {
        Picker("", selection: $input) {
            ForEach(VaporProperty.FluentPropertyWrapper.allCases) { fluent in
                Text(fluent.rawValue)
                    .font(.monospaced(.body)())
            }
        }
        .help("Fluent Property Wrapper")
    }
}
