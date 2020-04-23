//
//  CalcutorView.swift
//  calculatorDemo
//
//  Created by mrjia on 2020/4/23.
//  Copyright © 2020 jiajingwei. All rights reserved.
//

import SwiftUI

struct CalculatorButton: View {
    let title: String
    let size: CGSize
    let backgroundColoeName: String

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 38))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height, alignment: .center)
                .background(Color(backgroundColoeName))
                .cornerRadius(size.width / 2)
        }
    }
}

struct CalculatorButtonRow: View {
    @Binding var brain: CalcutorBrain

    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColoeName: item.backgroundColorName) {
                        self.brain = self.brain.apply(item: item)
                }
            }
        }
    }
}


struct CalcutorButtonPad: View {
    @Binding var brain: CalcutorBrain
    
    var body: some View {
        VStack(spacing: 8) {
            CalculatorButtonRow(brain: self.$brain, row: [.command(.clear), .command(.flip), .command(.percent), .op(.divide)])
            CalculatorButtonRow(brain: self.$brain, row: [.digit(7), .digit(8), .digit(9),.op(.multiply)])
            CalculatorButtonRow(brain: self.$brain, row: [.digit(4), .digit(5), .digit(6),.op(.minus)])
            CalculatorButtonRow(brain: self.$brain, row: [.digit(1), .digit(2), .digit(3),.op(.plus)])
            CalculatorButtonRow(brain: self.$brain, row: [.digit(0), .dot ,.op(.equal)])
        }
    }
}
