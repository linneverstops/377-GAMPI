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
    @IBOutlet weak var restart_button: UIButton!
    
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
        self.restart_game()
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
        if notification.userInfo != nil {
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
            //print("Swiped up")
            //call game controller's move function
            game_controller.move(direction: "UP")
            //render the new images according to the new tiles at new positions
            render_gameboard()
            //update the game state
            game_controller.updateGameState()
        case UISwipeGestureRecognizer.Direction.down:
            //print("Swiped down")
            game_controller.move(direction: "DOWN")
            render_gameboard()
            game_controller.updateGameState()
        case UISwipeGestureRecognizer.Direction.left:
            //print("Swiped left")
            game_controller.move(direction: "LEFT")
            render_gameboard()
            game_controller.updateGameState()
        case UISwipeGestureRecognizer.Direction.right:
            //print("Swiped right")
            game_controller.move(direction: "RIGHT")
            render_gameboard()
            game_controller.updateGameState()
        default:
            break
        }
        //update the number of moves?
        //Why bother...
    }
    
    //restart button for debug
    //might not stay for actual game
    //hmmmmm, we will see...
    @IBAction func restart_button_pressed(_ sender: UIButton) {
        self.restart_game()
    }
    
    
    private func restart_game() {
        //call game controller's restart game
        self.game_controller.reset_game()
        //render the images for goal and game boards
        self.render_gameboard()
        self.render_goalboard()
    }
    
    private func render_goalboard() {
        for row in 0...2 {
            for column in 0...2 {
                self.goal_board[row][column].image = UIImage(named: "\(game_controller.goal_board[row][column]).png")
            }
        }
    }
    
    private func render_gameboard() {
        for row in 0...4 {
            for column in 0...4 {
                self.game_board[row][column].image = UIImage(named: "\(game_controller.game_board[row][column]).png")
            }
        }
    }
    
    private func quit_game() {
        dismiss(animated: true, completion: nil)
    }

}
