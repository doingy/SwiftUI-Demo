//
//  CalculatorBrain.swift
//  SwiftUI-Demo
//
//  Created by 杨冬青 on 2020/6/10.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation

enum CalculatorBrain {
    case left(String)
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    case error
}
