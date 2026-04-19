//
//  TestAJA.swift
//  grounded
//
//  Created by Zildjian Vito  on 15/04/26.
//

import SwiftUI

struct TestAJA: View {
    var formula: AttributedString {
        let h = AttributedString("H")
        var two = AttributedString("2")
        let o = AttributedString("O")

        two.font = .system(size: 12)
        two.baselineOffset = -4

        return h + two + o
    }

    
    
    var body: some View {
        Text("Vito ganteng")
            .foregroundStyle(Color.red)
        
        HStack {
            Label("Fajar maniak gym", systemImage: "1.square.fill")
                .foregroundStyle(Color.blue)
        }
        .foregroundStyle(Color.yellow)
    }
}

#Preview {
    TestAJA()
}
