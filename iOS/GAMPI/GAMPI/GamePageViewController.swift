//
//  GamePageViewController.swift
//  GAMPI
//
//  Created by Dennis Lin on 4/22/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import UIKit

class GamePageViewController: UIViewController {
    
    
    @IBOutlet var game_board_row1: [UIImageView]!
    @IBOutlet var game_board_row2: [UIImageView]!
    @IBOutlet var game_board_row3: [UIImageView]!
    @IBOutlet var game_board_row4: [UIImageView]!
    @IBOutlet var game_board_row5: [UIImageView]!
    
    @IBOutlet var goal_board_row1: [UIImageView]!
    @IBOutlet var goal_board_row2: [UIImageView]!
    @IBOutlet var goal_board_row3: [UIImageView]!
    
    @IBOutlet weak var player_no_label: UILabel!
    
    var game_board : [[UIImageView]]
    
    var goal_board : [[UIImageView]]
    
    var game_controller : GAMPIGameController
    
    var is_multiplayer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSwipeGestures()
        //initialize the boards by appending the rows to it
        game_board.append(game_board_row1)
        game_board.append(game_board_row2)
        game_board.append(game_board_row3)
        game_board.append(game_board_row4)
        game_board.append(game_board_row5)
        goal_board.append(goal_board_row1)
        goal_board.append(goal_board_row2)
        goal_board.append(goal_board_row3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.game_board = [[UIImageView]]()
        self.goal_board = [[UIImageView]]()
        self.game_controller = GAMPIGameController()
        super.init(coder: aDecoder)
        let aSelector : Selector = #selector(GamePageViewController.handleNotificationGameDidEnd(_: ))
        NotificationCenter.default.addObserver(self, selector: aSelector, name: NSNotification.Name(rawValue: "GAMPI Game Over"), object: game_controller)
    }
    
    //a function to trigger the gameover notification
    @objc func handleNotificationGameDidEnd(_ notification: Notification) {
        if let userInfo = notification.userInfo{
            let message = "Puzzles completed! \nPlay again?"
            let alert = UIAlertController(title: "Good Job!", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Yep", style: .default, handler: ({(_: UIAlertAction) -> Void in self.restart_game()}))
            let quitAction = UIAlertAction(title: "Nope", style: .default, handler: ({(_: UIAlertAction) -> Void in self.quit_game()}))
            alert.addAction(restartAction)
            alert.addAction(quitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func initializeSwipeGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeResponse(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeResponse(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeResponse(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeResponse(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeResponse(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.up:
            print("Swiped up")
            //call game controller's move function
            //render the new images according to the new tiles at new positions
            //update the game state
        case UISwipeGestureRecognizer.Direction.down:
            print("Swiped down")

        case UISwipeGestureRecognizer.Direction.left:
            print("Swiped left")

        case UISwipeGestureRecognizer.Direction.right:
            print("Swiped right")

        default:
            break
        }
        //update the number of moves
    }
    
    private func restart_game() {
        //call game controller's restart game
        //render the images
    }
    
    private func render_goalboard() {
        for row in 0...2 {
            for column in 0...2 {
                //self.goal_board[row][column].image = UIImage(named: "\(game_controller.goalboard[row][column]).png")
            }
        }
    }
    
    private func render_gameboard() {
        for row in 0...4 {
            for column in 0...4 {
                //self.game_board[row][column].image = UIImage(named: "\(game_controller.gameboard[row][column]).png")
            }
        }
    }
    
    private func quit_game() {
        dismiss(animated: true, completion: nil)
    }

}
