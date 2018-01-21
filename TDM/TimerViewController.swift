//
//  TimerViewController.swift
//  TDM
//
//  Created by Jere Laine on 19/11/2017.
//  Copyright © 2017 Jere Laine. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var roundButton: UIView!
    @IBOutlet weak var roundButtonInnerRing: UIView!
    @IBOutlet weak var roundButtonOuterRing: UIView!

    
    var seconds = 0.00 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var forceTouched = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: #selector(TimerViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 0.01
        Time.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let hundreths = Int(time*100) % 100
        return String(format:"%02i:%02i:%02i", minutes, seconds, hundreths)
    }

    var is3DTouchAvailable: Bool {
        return view.traitCollection.forceTouchCapability == .available
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first {
            guard is3DTouchAvailable, roundButton.frame.contains(touch.location(in: view)) else { return }
            
            let maximumForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = (force / maximumForce);
            if normalizedForce > 0.9 {
                forceTouched = true
                AudioServicesPlaySystemSound(1519)
                seconds = 0
                timer.invalidate()
                isTimerRunning = false
                self.roundButton.backgroundColor = UIColor(rgb: 0xFF3B30)
                roundButtonOuterRing.backgroundColor = UIColor(rgb: 0xFF3B30)
                buttonLabel.text = "Reset"
                Time.text = "00:00:00"
            }
            
        }
    }
    
    func timerStart() {
        runTimer()
        isTimerRunning = true
        roundButton.backgroundColor = UIColor(rgb: 0xFF9500)
        roundButtonOuterRing.backgroundColor = UIColor(rgb: 0xFF9500)
        buttonLabel.text = "Pause"
        forceTouched = false
    }
    
    func timerStop() {
        timer.invalidate()
        isTimerRunning = false
        roundButton.backgroundColor = UIColor(rgb: 0x4CD964)
        roundButtonOuterRing.backgroundColor = UIColor(rgb: 0x4CD964)
        buttonLabel.text = "Start"
        forceTouched = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if (forceTouched == true) || (isTimerRunning == true) {
            timerStop()
        }
            
        else {
            timerStart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButton.layer.cornerRadius = 100
        roundButtonInnerRing.layer.cornerRadius = 102
        roundButtonOuterRing.layer.cornerRadius = 104

        // Do any additional setup after loading the view.
    }

}
