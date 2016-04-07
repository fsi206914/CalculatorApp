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
    var decimalEnable: Bool = false
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit == "pi"){
            display.text = "3.1415926";
            enter();
            return;
        }
        
        if userIsInTheMiddleOfTypingNumber{
            if(digit == "."){
                if(decimalEnable == false){
                    display.text = display.text! + digit;
                }
            }
            else{
                display.text = display.text! + digit;
            }
        }
        else{
            display.text = digit;
            userIsInTheMiddleOfTypingNumber = true;
        }
        if(digit==".") {
            decimalEnable = true;
        }
    }
    
    @IBOutlet weak var opDisplay: UILabel!
    
    var operandStack = Array<Double>();
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false;
        decimalEnable = false;
        operandStack.append(displayValue);
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;
        if userIsInTheMiddleOfTypingNumber{
            enter();
        }
        let ct = operandStack.count;
        if(operation == "✕" || operation == "÷" || operation == "+" || operation == "−"){
            opDisplay.text = String(format:"%f", operandStack[ct-2]) + "  " + operation + "  " +  String(format:"%f", operandStack[ct-1]);
        }
        else{
            opDisplay.text = operation + "  " + String(format:"%f", operandStack[ct-1]);
        }
        
        switch operation{
        case "✕": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performSingleOperation{ sqrt($0) }
        case "sin": performSingleOperation{ sin($0) }
        case "cos": performSingleOperation{ cos($0) }
        default: break
        }
        
        
        
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count>=2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast());
            enter()
        }
    }

    func performSingleOperation(operation: Double -> Double){
        if operandStack.count>=1 {
            displayValue = operation(operandStack.removeLast());
            enter()
        }
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)";
//            userIsInTheMiddleOfTypingNumber = false;
        }
    }
}

