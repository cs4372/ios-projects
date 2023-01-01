//
//  InitialViewController.swift
//  Tic-Tac-Toe
//
//  Created by Catherine Shing on 1/1/23.
//

import UIKit

class InitialViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        player1TextField.delegate = self
        player2TextField.delegate = self
        startBtn.isEnabled = false
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        startBtn.isEnabled = [player1TextField, player2TextField].allSatisfy({ !$0.text!.isEmpty })
    }
    @IBOutlet var player1TextField: UITextField!
    @IBOutlet var player2TextField: UITextField!
    
    @IBOutlet var startBtn: UIButton!
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        player1TextField.resignFirstResponder()
        player2TextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         view.endEditing(true)
     }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! BoardViewController
        secondViewController.player1 = player1TextField.text!
        secondViewController.player2 = player2TextField.text!
    }
}

