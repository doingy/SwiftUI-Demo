//
//  ContentView.swift
//  SwiftUI-Demo
//
//  Created by 杨冬青 on 2020/6/10.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let row: [CalculatorButtonItem] = [.digit(1), .digit(2), .digit(3), .op(.plus)]
    var body: some View {
        VStack(spacing: 8) {
            CalculatorButtonRow(row: [
                .command(.clear), .command(.flip), .command(.percent), .op(.divide)
            ])
            CalculatorButtonRow(row: [
                .digit(7), .digit(8), .digit(9), .op(.multiply)
            ])
            CalculatorButtonRow(row: [
                .digit(4), .digit(5), .digit(6), .op(.minus)
            ])
            CalculatorButtonRow(row: [
                .digit(1), .digit(2), .digit(3), .op(.plus)
            ])
            CalculatorButtonRow(row: [
                .digit(0), .dot, .digit(3), .op(.plus)
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalculatorButtonRow: View {
    let row: [CalculatorButtonItem]

    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(title: item.title, size: item.size, backgroundColor: item.backgroundColor) {
                    print("")
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
