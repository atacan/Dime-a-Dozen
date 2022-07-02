//
// https://github.com/atacan
// 02.07.22
	

import SwiftUI

struct MacProgressSpinner: NSViewRepresentable {
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let myProgressIndicator = NSProgressIndicator()
        myProgressIndicator.style = .spinning
        myProgressIndicator.controlSize = .small
        myProgressIndicator.startAnimation(nil)
        return myProgressIndicator
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        //
    }
    
    typealias NSViewType = NSProgressIndicator
    
    
}
