//
//  ContentView.swift
//  calculatorDemo
//
//  Created by mrjia on 2020/4/23.
//  Copyright © 2020 jiajingwei. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let scale: CGFloat = UIScreen.main.bounds.width / 414
    
    @State private var brain: CalcutorBrain = .left("0")
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            CalcutorButtonPad(brain: $brain)
                .padding(.bottom)
        }.scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
