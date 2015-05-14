//
//  CalculatorBrain.swift
//  Swift_Whatevers
//
//  Created by Ivan Kozodoy on 13.05.15.
//  Copyright (c) 2015 Surovo Apps. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable {           //Printable - протокол, enum'ы наследовать нельзя
        case Operand            (Double)
        case UnaryOperation     (String, Double -> Double)              // Double -> Double == принимает функцию с одним аргументом, которая возвращает Double
        case BinaryOperation    (String, (Double, Double) -> Double)    // (Double, Double) -> Double == принимает функцию с двумя аргументами, которая возвращает Double
        
        // далее создано вычисляемое свойство (Computed property), которое нужно для корректной работы функции println() когда мы хотим вывести Op в консоль
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand) :
                            return "\(operand)"
                    case .BinaryOperation(let symbol, _) :
                            return "\(symbol)"
                    case .UnaryOperation(let symbol, _) :
                            return "\(symbol)"
                }
            }
        }
    }
    
    private var operandsArray = [Op]()
    
    private var supportedMathOperations = [String : Op]()
    
    init () {
        supportedMathOperations["×"] = Op.BinaryOperation("×", *)
        supportedMathOperations["⁒"] = Op.BinaryOperation("⁒", {$1 / $0})
        supportedMathOperations["+"] = Op.BinaryOperation("+", +)
        supportedMathOperations["-"] = Op.BinaryOperation("-", {$1 - $0})
        
        supportedMathOperations["√"] = Op.UnaryOperation("√", sqrt)     /*в качестве аргумента используется функция с одним  Double аргументом, которая возвращает одно Double значение. 
                                                                        И вы знаете, что это — Doubles, при создании унарной операции. Мы можем пользоваться здесь «выводом типа» (inferring type).
                                                                        Тогда выражение { sqrt($0) }  представляет собой функцию типа Double -> Double внутри другой функции Double -> Double. 
                                                                        Поэтому нам не нужно замыкание и аргументы внутри него, мы передаем функцию sqrt как второй параметр в унарную операцию и она может иметь имя или использовать фигурные скобки { }.*/
        
        // + и * можно представить абсолютно так же т.к. это функции вида (Double ,  Double )-> Double
        
        // !!! НО Мы не можем также поступить с делением / и вычитанием —  из-за обратного порядка операндов.
        
    }
    
    func pushOperand(operand: Double) {
        self.operandsArray.append(Op.Operand(operand))
        println("\(self.operandsArray)")
    }
    
    func performOperation(symbol: String)->Double? {
        
        if let operation = supportedMathOperations[symbol] {
            operandsArray.append(operation)                             //помещаем в массив только если операция поддерживается (присутствует в supportedMathOperations)
        }
        
        return calculate()
    }
    
    func calculate() -> Double? {
        let (result, _) = evaluate(operandsArray)            // это всего лишь другой способ получить Tuple, _ означает что мы игнорируем одно из значений. Имена переменных могут отличаться
        return result
    }
    
    private func evaluate (var ops: [Op]) -> (result: Double?, remainingOps: [Op] ) {   // var ops: [Op] - var означает что мы хотим иметь мутабельный (изменяемый массив) внутри функции
        
        if !ops.isEmpty {
            
            //если стек операндов и операци не пуст
            
            let op = ops.removeLast()                                   // Arrays и Dictionaries в Swift не являются классами, это структуры и они передаются по значению!!!
            
            switch op {
                
                case .Operand(let operand) :
                    //В круглых скобках следом за конструкцией  .Operand ( ) вас спрашивают, что вы хотите сделать с ассоциированным значением, если вы обрабатываете этот вариант ( case ), то есть в случае, если это операнд. Я хочу присвоить это ассоциированное значение константе с именем operand.
                    return (operand, ops)
                    
                case .UnaryOperation(_, let function) :                     // _ означает что мы игнорируем это значение
                    let operandEvaluation = evaluate(ops)
                    if let operand = operandEvaluation.result {
                        return (function(operand), operandEvaluation.remainingOps)
                    }
                    
                case .BinaryOperation(_, let doubleOperandsFunction) :      // _ означает что мы игнорируем это значение
                    let op1Evaluation = evaluate(ops)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (doubleOperandsFunction(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
            }
        }
        return (nil, ops)
    }

}