//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Yuren Huang on 9/16/17.
//  Copyright © 2017 Yuren Huang. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator: Double?
    var result: Double? {
        get {
            return accumulator
        }
    }
    private enum Operator {
        case mathConst(Double)
        case unaryOp((Double) -> Double)
        case binaryOp((Double, Double) -> Double)
        case equal
        case clear
    }
    private var opDict: Dictionary<String, Operator> = [
        "𝐞": .mathConst(M_E),
        "𝛑": .mathConst(Double.pi),
        "√": .unaryOp(sqrt),
        "+": .binaryOp({ $0 + $1 }),
        "−": .binaryOp({ $0 - $1 }),
        "×": .binaryOp({ $0 * $1 }),
        "÷": .binaryOp({ $0 / $1 }),
        "=": .equal,
        "C": .clear
    ]
    private struct PendingBinaryOp {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func compute(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    private var pendingBinaryOp: PendingBinaryOp?
    var resultIsPending: Bool {
        get {
            return pendingBinaryOp != nil
        }
    }
    var description = ""
    
    mutating func doOperation(_ symbol: String) {
        if let op = opDict[symbol] {
            switch op {
            case .mathConst(let val):
                accumulator = val
            case .unaryOp(let op):
                if accumulator != nil {
                    if resultIsPending {
                        if description.hasSuffix("...") {
                            description.removeLast(3)
                        }
                        description += symbol + "(\(accumulator!))..."
                    } else {
                        if description.hasSuffix("=") {
                            description.removeLast()
                        } else {
                            description = String(accumulator!)
                        }
                        description = symbol + "(\(description))="
                    }
                    accumulator = op(accumulator!)
                }
            case .binaryOp(let op):
                if accumulator != nil {
                    if resultIsPending {
                        accumulator = pendingBinaryOp!.compute(with: accumulator!)
                    }
                    pendingBinaryOp = PendingBinaryOp(function: op, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equal:
                if resultIsPending && accumulator != nil {
                    accumulator = pendingBinaryOp!.compute(with: accumulator!)
                    pendingBinaryOp = nil
                }
            case .clear:
                accumulator = nil
                description = ""
                pendingBinaryOp = nil
            }
        }
    }
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
