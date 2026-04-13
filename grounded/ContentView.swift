//
//  ContentView.swift
//  grounded
//
//  Created by Zildjian Vito  on 10/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        PactAppFlow()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(PactPreviewContainer.container)
    }
}

#Preview {
    ContentView()
        .modelContainer(PactPreviewContainer.container)
}
