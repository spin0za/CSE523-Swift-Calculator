//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Yuren Huang on 9/16/17.
//  Copyright © 2017 Yuren Huang. All rights reserved.
//

import Foundation

let formatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.maximumFractionDigits = 6
    return fmt
}()

func format(_ number: Double) -> String {
    return formatter.string(from: NSNumber(value: number)) ?? ""
}

struct CalculatorBrain {
    private var accumulator: Double?
    private var intermediateDesc = ""
    var result: Double? {
        get {
            return accumulator
        }
    }
    private enum Operator {
        case mathConst(Double)
        case unaryOp((Double) -> Double, (String) -> String)
        case binaryOp((Double, Double) -> Double, (String, String) -> String)
        case equal
    }
    private var opDict: Dictionary<String, Operator> = [
        "𝐞": .mathConst(M_E),
        "𝛑": .mathConst(Double.pi),
        "√": .unaryOp(sqrt, {"√(\($0))"}),
        "+": .binaryOp(+, {"\($0)+\($1)"}),
        "−": .binaryOp(-, {"\($0)-\($1)"}),
        "×": .binaryOp(*, {"\($0)×\($1)"}),
        "÷": .binaryOp(/, {"\($0)÷\($1)"}),
        "=": .equal
    ]
    private struct PendingBinaryOp {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let descFunction: (String, String) -> String
        let descFirstOperand: String
        func compute(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        func updateText(with descSecondOperand: String) -> String {
            return descFunction(descFirstOperand, descSecondOperand)
        }
    }
    private var pendingBinaryOp: PendingBinaryOp?
    var resultIsPending: Bool {
        get {
            return pendingBinaryOp != nil
        }
    }
    var description: String {
        get {
            return resultIsPending ? pendingBinaryOp!.updateText(with: intermediateDesc) : intermediateDesc
        }
    }
    
    private mutating func doPendingOp() {
        if resultIsPending && accumulator != nil {
            accumulator = pendingBinaryOp!.compute(with: accumulator!)
            intermediateDesc = pendingBinaryOp!.updateText(with: intermediateDesc)
            pendingBinaryOp = nil
        }
    }
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        intermediateDesc = format(accumulator!)
    }
    mutating func doOperation(_ symbol: String) {
        if let op = opDict[symbol] {
            switch op {
            case .mathConst(let val):
                accumulator = val
                intermediateDesc = symbol
            case .unaryOp(let op, let df):
                if accumulator != nil {
                    accumulator = op(accumulator!)
                    intermediateDesc = df(intermediateDesc)
                }
            case .binaryOp(let op, let df):
                doPendingOp()
                if accumulator != nil {
                    pendingBinaryOp = PendingBinaryOp(function: op, firstOperand: accumulator!, descFunction: df, descFirstOperand: intermediateDesc)
                    accumulator = nil
                    intermediateDesc = ""
                }
            case .equal:
                doPendingOp()
            }
        }
    }
    mutating func clear() {
        accumulator = nil
        intermediateDesc = ""
        pendingBinaryOp = nil
    }
}
