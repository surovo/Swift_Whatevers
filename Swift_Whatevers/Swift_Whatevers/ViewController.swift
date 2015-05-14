//
//  ViewController.swift
//  Swift_Whatevers
//
//  Created by Ivan Kozodoy on 30.04.15.
//  Copyright (c) 2015 Surovo Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool  = false
    
    var brain = CalculatorBrain()
       
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!        // ! - means Optional String "unwrapping" to String
        println("you pressed \(digit), digit")
        
        if userIsInTheMiddleOfTypingANumber {
            
            self.display.text = self.display.text! + digit
        } else {
            
            self.display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // error?
                displayValue = 0  // задание 2
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
        brain.pushOperand(displayValue)
    }


    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

