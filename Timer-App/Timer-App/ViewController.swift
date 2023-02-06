//
//  ViewController.swift
//  Timer-App
//
//  Created by Catherine Shing on 2/5/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timer: Timer?
    var count: Int = 0
    var timerActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = getFormattingTime(seconds:0)
        startButton.setTitleColor(UIColor.green, for: .normal)
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        if (timerActive) {
            timer?.invalidate()
            timerActive = false
            startButton.setTitle("START", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
            
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            timerActive = true
            startButton.setTitle("STOP", for: .normal)
            startButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    @objc func countDown() {
        count+=1
        timerLabel.text = getFormattingTime(seconds: count)
        print(count)
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Timer", message: "Do you want to reset the timer?", preferredStyle: .alert)
            
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> (Void) in
            self.count = 0
            self.timerActive = false
            self.timerLabel.text = self.getFormattingTime(seconds: 0)
       })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
         alert.addAction(cancel)
        self.present(alert, animated: true)

    }
    
    private func getFormattingTime(seconds:Int) -> String {
        let hours = seconds/3600
        let minutes = (seconds%3600)/60
        let seconds = (seconds%3600)%60
        return String(format: "%02d:%02d:%02d",hours,minutes,seconds)
    }
}
