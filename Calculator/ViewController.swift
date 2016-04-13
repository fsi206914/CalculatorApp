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
    
    var brain = CalculatorBrain()
    
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
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false;
        decimalEnable = false;
        displayValue = brain.pushOperand(displayValue!)
        opDisplay.text = brain.description;
    }

    @IBAction func storeM(sender: AnyObject) {
        if let currVal = displayValue {
            brain.variableValues["M"] = currVal
            displayValue=brain.assignM(currVal)
        }
        userIsInTheMiddleOfTypingNumber = false;
        decimalEnable = false;
    }
    
    @IBAction func pushM(sender: AnyObject) {
        brain.pushOperand("M")
        opDisplay.text = brain.description;
    }
    
    @IBAction func operate(sender: UIButton) {
        _ = sender.currentTitle!;
        if userIsInTheMiddleOfTypingNumber{
            enter();
        }
//        if(operation == "✕" || operation == "÷" || operation == "+" || operation == "−"){
//            opDisplay.text = String(format:"%f", operandStack[ct-2]) + "  " + operation + "  " +  String(format:"%f", operandStack[ct-1]);
//        }
//        else{
//            opDisplay.text = operation + "  " + String(format:"%f", operandStack[ct-1]);
//        }
        
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
            opDisplay.text = brain.description;
        }
        
    }
    
    @IBAction func clear(sender: AnyObject) {
        userIsInTheMiddleOfTypingNumber = false;
        decimalEnable = false;
    }
    
    @IBAction func backspace(sender: UIButton) {
        let currStr = display.text!;
        if (currStr.characters.count>1){
            display.text = currStr.substringToIndex(currStr.startIndex.advancedBy(currStr.characters.count-1))
        }
        else{
            if(currStr != "0"){
                display.text = "0";
            }
        }
    }
    
    var displayValue: Double? {
        get{
            if let res =  NSNumberFormatter().numberFromString(display.text!){
                return res.doubleValue;
            }
            display.text = "0";
            return nil;
        }
        set{
            if let vl = newValue{
                display.text = "\(vl)";
            }
            else{
                display.text = "0";
            }
            userIsInTheMiddleOfTypingNumber = false;
        }
    }
}

