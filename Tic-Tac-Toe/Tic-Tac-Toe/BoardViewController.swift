//
//  BoardViewController.swift
//  Tic-Tac-Toe
//
//  Created by Catherine Shing on 1/1/23.
//

import UIKit

class BoardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupStyle()
        initializeBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayMessage(title: "\(player1) is Player X \n \(player2) is Player O", alertButtonMsg: "Got it")
    }
    
    var player1: String = ""
    var player2: String = ""
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var row0col0: UIButton!
    @IBOutlet var row0col1: UIButton!
    @IBOutlet var row0col2: UIButton!
    @IBOutlet var row1col0: UIButton!
    @IBOutlet var row1col1: UIButton!
    @IBOutlet var row1col2: UIButton!
    @IBOutlet var row2col0: UIButton!
    @IBOutlet var row2col1: UIButton!
    @IBOutlet var row2col2: UIButton!
    @IBOutlet var restartButton: UIButton!
    
    enum Player {
        case X
        case O
    }
    var board = [UIButton]()
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]]
    var playerX: [Int] = [Int](repeating: 0, count: 9)
    var playerO: [Int] = [Int](repeating: 0, count: 9)
    var winner: String = ""
    var currPlayer = Player.X
    let CROSS = "X"
    let NOUGHT = "O"
    
    private func initializeBoard() {
        board.append(row0col0)
        board.append(row0col1)
        board.append(row0col2)
        board.append(row1col0)
        board.append(row1col1)
        board.append(row1col2)
        board.append(row2col0)
        board.append(row2col1)
        board.append(row2col2)
    }
    
    @IBAction func boardTap(_ sender: UIButton) {
        let btnIdx = sender.tag
        winner = "Player \(currPlayer)"
        if(currPlayer == Player.O) {
            sender.setTitle(NOUGHT, for: .normal)
            sender.backgroundColor = UIColor.cyan
            playerO[btnIdx] = 1
            if checkWinner(player: playerO) {
                displayMessage(title: "Winner is Player \(currPlayer)", alertButtonMsg: "Restart")
            }
            currPlayer = Player.X
            playerLabel.text = CROSS
        }
        else if(currPlayer == Player.X)
        {
            sender.setTitle(CROSS, for: .normal)
            playerX[btnIdx] = 1
            sender.backgroundColor = UIColor.orange
            if checkWinner(player: playerX) {
                displayMessage(title: "Winner is Player \(currPlayer)", alertButtonMsg: "Restart")
            }
            currPlayer = Player.O
            playerLabel.text = NOUGHT
        }
        sender.isEnabled = false
        isBoardFull()
    }
    
    private func checkWinner(player: [Int]) -> Bool {
        for combo in winningCombinations {
            let first = combo[0]
            let second = combo[1]
            let third = combo[2]
            if player[first] == 0 || player[second] == 0 || player[third] == 0 {
                continue
            }
            if player[first] == 1 && player[second] == 1 && player[third] == 1 {
                return true
            }
        }
        return false
    }
    
    private func displayMessage(title: String, alertButtonMsg: String) {
        print("inside")
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(alertButtonMsg, comment: "Default action"), style: .default, handler: { _ in
            self.reset()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        playerX = [Int](repeating: 0, count: 9)
        playerO = [Int](repeating: 0, count: 9)
        for cell in board {
            cell.setTitle(nil, for: .normal)
            cell.isEnabled = true
            cell.backgroundColor = UIColor.white
        }
    }
    
    private func isBoardFull() {
        let boardFull = board.allSatisfy({ $0.isEnabled == false })
        if boardFull {
            displayMessage(title: "Game over", alertButtonMsg: "Restart")
            reset()
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        reset()
    }
    
    private func setupStyle() {
        restartButton.layer.cornerRadius = 5.0
    }
}
