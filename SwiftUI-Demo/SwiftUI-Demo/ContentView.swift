//
//  ContentView.swift
//  SwiftUI-Demo
//
//  Created by 杨冬青 on 2020/6/10.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = CalculatorModel()
    
    @State private var editingHistory = false
    
    let scale: CGFloat = UIScreen.main.bounds.width / 414
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历:\(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 24)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            CalculatorButtonPad(model: model)
                .padding(.bottom)
        }
        .scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.colorScheme, .dark)
            ContentView().previewDevice("iPhone SE - 13.5")
        }
    }
}

struct CalculatorButtonPad: View {
    var model: CalculatorModel
    
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
                CalculatorButtonRow(model: self.model, row: row)
            }
        }
    }
}

struct CalculatorButtonRow: View {
    var model: CalculatorModel

    let row: [CalculatorButtonItem]

    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(title: item.title, size: item.size, backgroundColor: item.backgroundColor) {
                    self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(backgroundColor)
                .cornerRadius(44)
        }
    }
}
