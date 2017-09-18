//
//  ViewController.swift
//  Calculator
//
//  Created by Yuren Huang on 9/11/17.
//  Copyright © 2017 Yuren Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var brain = CalculatorBrain()
    @IBOutlet weak var sequence: UILabel!
    @IBOutlet weak var display: UILabel!
    private var displayValue: Double? {
        get {
            return Double(display.text!)!
        }
        set {
            if let val = newValue {
                display.text = format(val)
            }
            sequence.text = brain.description.isEmpty ? "" : brain.description + (brain.resultIsPending ? "..." : "=")
        }
    }
    private var isTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isTyping {
            let currentDisplay = display.text!
            if !(digit == "." && currentDisplay.contains(".")) {
                display.text = currentDisplay + digit
            }
        } else {
            display.text = digit
            isTyping = true
        }
    }
    @IBAction func touchClear(_ sender: UIButton) {
        brain.clear()
        isTyping = false
        displayValue = 0
    }
    @IBAction func touchOperation(_ sender: UIButton) {
        let op = sender.currentTitle!
        if isTyping {
            if let val = displayValue {
                brain.setOperand(val)
            }
            isTyping = false
        }
        brain.doOperation(op)
        displayValue = brain.result
    }
}
