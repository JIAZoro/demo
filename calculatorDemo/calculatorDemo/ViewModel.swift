//
//  ViewModel.swift
//  calculatorDemo
//
//  Created by mrjia on 2020/4/23.
//  Copyright © 2020 jiajingwei. All rights reserved.
//

import Foundation
import SwiftUI

enum CalculatorButtonItem {
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "x"
        case equal = "="
    }

    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }

    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem: Hashable {}
extension CalculatorButtonItem {
    var title: String {
        switch self {
        case let .digit(value):
            return String(value)
        case .dot:
            return "."
        case let .op(op):
            return op.rawValue
        case let .command(command):
            return command.rawValue
        }
    }

    var size: CGSize {
        if case let .digit(value) = self, case value = 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }

    var backgroundColorName: String {
        switch self {
        case .digit, .dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
}

enum CalcutorBrain {
    case left(String)
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    case error

    var output: String {
        let result: String
        switch self {
        case let .left(left):
            result = left
        case let .leftOp(left, _):
            result = left
        case let .leftOpRight(_, _, right):
            result = right
        case .error:
            result = "Error"
        }
        guard let value = Double(result) else { return "Error" }
        return formatter.string(from: value as NSNumber)!
    }

    func apply(item: CalculatorButtonItem) -> CalcutorBrain {
        switch item {
        case let .digit(num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case let .op(op):
            return apply(op: op)
        case let .command(command):
            return apply(command: command)
        }
    }

    private func apply(num: Int) -> CalcutorBrain {
        switch self {
        case let .left(left):
            return .left(left.apply(num: num))
        case let .leftOp(left, op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case let .leftOpRight(left, op, right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }

    private func applyDot() -> CalcutorBrain {
        switch self {
        case let .left(left):
            return .left(left.applyDot())
        case let .leftOp(left, op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case let .leftOpRight(left, op, right):
            return .leftOpRight(left: left, op: op, right: right)
        case .error:
            return .left("0".applyDot())
        }
    }

    private func apply(op: CalculatorButtonItem.Op) -> CalcutorBrain {
        switch self {
        case let .left(left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case let .leftOp(left, currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        case let .leftOpRight(left, currentOp, right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }

    private func apply(command: CalculatorButtonItem.Command) -> CalcutorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case let .left(left):
                return .left(left.flipped())
            case let .leftOp(left, op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case let .leftOpRight(left: left, op, right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case let .left(left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case let .leftOpRight(left: left, op, right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    var containsDot: Bool {
        return contains(".")
    }

    var starWithNegative: Bool {
        return starts(with: "-")
    }

    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }

    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }

    func flipped() -> String {
        if starWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }

    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
    func calculate(l: String, r: String) -> String? {
        guard let left = Double(l), let right = Double(r) else {
            return nil
        }

        let result: Double?
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = right == 0 ? nil : left / right
        case .equal: fatalError()
        }
        return result.map { String($0) }
    }
}

typealias CalculatorState = CalcutorBrain
typealias CalculatorStateAction = CalculatorButtonItem

struct Reducer {
    static func reduce(state: CalculatorState,action: CalculatorStateAction) -> CalculatorState {
        return state.apply(item: action)
    }
}
