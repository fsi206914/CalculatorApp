//
//  ViewController.swift
//  Calculator
//
//  Created by Liang Tang on 4/4/16.
//  Copyright © 2016 Tinker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingNumber: Bool = false
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber{
            display.text = display.text! + digit;
        }
        else{
            display.text = digit;
            userIsInTheMiddleOfTypingNumber = true;
        }
    }
    
    var operandStack = Array<Double>();
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false;
        operandStack.append(displayValue);
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;
        if userIsInTheMiddleOfTypingNumber{
            enter();
        }
        switch operation{
        case "✕":
            if (operandStack.count>=2){
                displayValue = operandStack.removeLast() * operandStack.removeLast()
                enter()
            }
//        case "÷":
//        case "+":
//        case "-":
        default: break
        }
    }
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)";
            userIsInTheMiddleOfTypingNumber = false;
        }
    }
}

