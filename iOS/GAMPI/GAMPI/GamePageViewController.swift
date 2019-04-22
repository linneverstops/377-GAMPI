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
    
    var game_board : [[UIImageView]]
    
    var goal_board : [[UIImageView]]
    
    var game_controller : GAMPIGameController

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

}
