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
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
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
    @IBAction func touchOperation(_ sender: UIButton) {
        if isTyping {
            brain.setOperand(displayValue)
            isTyping = false
        }
        brain.doOperation(sender.currentTitle!)
        displayValue = brain.result ?? 0
        sequence.text = brain.description
    }
}
