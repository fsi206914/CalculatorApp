//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Liang Tang on 4/7/16.
//  Copyright © 2016 Tinker. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
    }
    
    private var opStack = [Op]();
    
    private var knownOps = [String:Op]();
    
    init(){
        knownOps["✕"] = Op.BinaryOperation("✕"){$0 * $1}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+"){$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) ->(result: Double?, remainOps: [Op]) {
        if !ops.isEmpty{
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps);
            
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps);
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainOps);
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps);
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainOps);
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainOps);
                    }
                }
            
            }
        }
        return (nil, ops);
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        return result;
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand));
        return evaluate();
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation);
        }
        return evaluate();
        
    }
}