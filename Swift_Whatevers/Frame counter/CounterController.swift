//
//  ViewController.swift
//  Frame counter
//
//  Created by Ivan Kozodoy on 25.05.15.
//  Copyright (c) 2015 Surovo Apps. All rights reserved.
//

import UIKit

class CounterController: UIViewController {
  
    @IBOutlet weak var shutterControl   : UISwitch!
    @IBOutlet weak var shootButton      : UIButton!
    @IBOutlet weak var clearCounterRecognizer: UILongPressGestureRecognizer!
    
    private let counterKey      =   "counterKey"
    private let shutterKey      =   "shutterKey"
    private let defaultCount    =   0
    
    private func shoot(var input : Int) -> (Int) {
        return ++input
    }
    
    private func getCount()->(Int) {
        NSUserDefaults.standardUserDefaults().registerDefaults([counterKey : defaultCount])
        NSUserDefaults.standardUserDefaults().synchronize()
        var currentCount = NSUserDefaults.standardUserDefaults().integerForKey(counterKey)
        return currentCount
    }
    
    private func putCount(var input : Int) {
        NSUserDefaults.standardUserDefaults().setInteger(input, forKey: counterKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func getShutter()->(Bool) {
        NSUserDefaults.standardUserDefaults().registerDefaults([shutterKey : false])
        NSUserDefaults.standardUserDefaults().synchronize()
        var currentShutter = NSUserDefaults.standardUserDefaults().boolForKey(shutterKey)
        return currentShutter
    }
    
    private func putShutter(shutter: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(shutter, forKey: shutterKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func shoot() {
        putShutter(false)
        var framesDone = getCount()
        framesDone++
        putCount(framesDone)
    }
    
    private func setUpView() {
        shutterControl.setOn(getShutter(), animated: true);
        shootButton.setTitle(getCount().description, forState: UIControlState.Normal)
        shootButton.setTitle(getCount().description, forState: UIControlState.Highlighted)
        shootButton.setTitle(getCount().description, forState: UIControlState.Selected)
    }
    
    /*****************************************/
    
    @IBAction func userDidShot() {
        shoot()
        setUpView()
    }
    
    @IBAction func userDidCockShutter(sender: UISwitch) {
        putShutter(sender.on)
        setUpView()
    }
    
    @IBAction func clearFrames(sender: UILongPressGestureRecognizer) {
        
        let currentCount = self.getCount()
        if  currentCount <= self.defaultCount {
            return
        }
        
        var alert = UIAlertController(title: "Do you want to reset frame counter", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, I do", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
                case .Default:
                        self.putCount(-1)
                        self.shoot()
                        self.setUpView()
                case .Cancel:
                    println("")
                    
                case .Destructive:
                    println("")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpView()
        shootButton.layer.cornerRadius = shootButton.frame.size.width/2
    }

}

