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
    
    var operandsStack = Array<Double> ()
    
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
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

