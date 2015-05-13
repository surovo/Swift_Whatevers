//
//  CalculatorBrain.swift
//  Swift_Whatevers
//
//  Created by Ivan Kozodoy on 13.05.15.
//  Copyright (c) 2015 Surovo Apps. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum Op {
        case Operand            (Double)
        case UnaryOperation     (String, Double -> Double)              // Double -> Double == принимает функцию с одним аргументом, которая возвращает Double
        case BinaryOperation    (String, (Double, Double) -> Double)    // (Double, Double) -> Double == принимает функцию с двумя аргументами, которая возвращает Double
    }
    
    var operandsArray = [Op]()
    
    var supportedMathOperations = [String : Op]()
    
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
    }
    
    func performOperation(symbol: String) {
        
        if let operation = supportedMathOperations[symbol] {
            operandsArray.append(operation)                             //помещаем в массив только если операция поддерживается (присутствует в supportedMathOperations)
        }
        
    }

}