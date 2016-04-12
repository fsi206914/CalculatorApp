//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Liang Tang on 4/7/16.
//  Copyright © 2016 Tinker. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

class CalculatorBrain{
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case Memory(String)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        
        var description: String {
            get{
                switch self {
                case .Operand(let operand): return "\(operand)"
                case .Memory(let str): return str;
                case .UnaryOperation(let symbol, _): return symbol
                case .BinaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]();
    
    private var knownOps = [String:Op]();
    var variableValues: Dictionary<String,Double>
        = [String:Double]();
    
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
            
            case .Memory(_):
                if let value = variableValues["M"]{
                    return (value, remainingOps)
                }
                return(nil, ops);
                
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
        print("\(opStack) = \(result) with (remainder) left over")
        return result;
    }

    func pushOperand(symbol: String) -> Double?{
    
       opStack.append(Op.Memory(symbol));
       return evaluate();
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
    
    var description: String {
        get{
            var retStr = "";
            var remainOps: [Op]? = opStack;
            while 1 == 1 {
                var (res, remainOpsAfter) = genExpression(remainOps!);
                
                // Remove the out parenthesis
                if res![0] == "(" {
                    res = (res! as NSString).substringWithRange(NSRange(location: 1, length: res!.characters.count-2))
                }
                retStr =  res! + "," + retStr;

                if !remainOpsAfter.isEmpty {
                    remainOps = remainOpsAfter;
                }
                else {break;}
            }
            return retStr.substringToIndex(retStr.startIndex.advancedBy(retStr.characters.count-1))
        }
    }
    
    private func genExpression(currOps: [Op]) -> (res: String?, remainOps: [Op]){
        if !currOps.isEmpty{
            var remainingOps = currOps;
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return ("\(operand)", remainingOps);
            
            case .Memory(let str):
                return (str, remainingOps);
            
            case .UnaryOperation(let opName, _):
                let operandStr = genExpression(remainingOps);
                if let retStr = operandStr.res {
                    return ("(" + opName + retStr + ")", operandStr.remainOps);
                }
            case .BinaryOperation(let opName, _):
                let operand1Str = genExpression(remainingOps);
                if let operand1 = operand1Str.res {
                    let operand2Str = genExpression(operand1Str.remainOps);
                    if let operand2 = operand2Str.res {
                        return ("(" + operand2 + opName + operand1 + ")", operand2Str.remainOps);
                    }
                }
                
            }
        }
        return (nil, currOps);
    }
    
    
    
}