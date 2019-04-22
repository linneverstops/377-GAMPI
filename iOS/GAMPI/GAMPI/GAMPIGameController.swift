//
//  GAMPIGameController.swift
//  GAMPI
//
//  Created by Dennis Lin on 4/22/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import Foundation

enum GAMPIGameState: Int {
    case in_progress = 0, gameover
}

class GAMPIGameController {
    
    var goal_board : [[String]]
    var game_board : [[String]]
    var num_moves : Int
    var empty_row : Int
    var empty_col : Int
    var game_state : GAMPIGameState
    
    init() {
        self.goal_board = [["b", "r", "y"],
                           ["c", "e", "o"],
                            ["o", "g", "r"]]
        self.game_board = [ ["r", "r", "r", "r", "b"],
                            ["g", "c", "y", "y", "b"],
                            ["g", "c", "e", "y", "b"],
                            ["g", "c", "c", "y", "b"],
                            ["g", "o", "o", "o", "o"]]
        self.empty_row = 3
        self.empty_col = 3
        self.num_moves = 0
        self.game_state = .in_progress
    }
    
    func reset_game() {
        self.game_board = [ ["r", "r", "r", "r", "b"],
                            ["g", "c", "y", "y", "b"],
                            ["g", "c", "e", "y", "b"],
                            ["g", "c", "c", "y", "b"],
                            ["g", "o", "o", "o", "o"]]
        self.shuffle(n: 20)
        //retrieve the middle 3x3 and assign it to the goal_board
        self.shuffle(n: 20)
        self.num_moves = 0
        self.game_state = .in_progress
    }
    
    //shuffle the goal_board and the game_board
    func shuffle(n: Int) {
        
    }
    
    //move the blank tile
    func move(direction: String) {
        switch direction {
        case "UP":
            if empty_row > 0 {
                let temp = game_board[empty_row-1][empty_col]
                game_board[empty_row-1][empty_col] = game_board[empty_row][empty_col]
                game_board[empty_row][empty_col] = temp
                num_moves += 1
            }
            break
        case "DOWN":
            if empty_row < 2 {
                let temp = game_board[empty_row+1][empty_col]
                game_board[empty_row+1][empty_col] = game_board[empty_row][empty_col]
                game_board[empty_row][empty_col] = temp
                num_moves += 1
            }
            break
        case "LEFT":
            if empty_col > 0 {
                let temp = game_board[empty_row][empty_col-1]
                game_board[empty_row][empty_col-1] = game_board[empty_row][empty_col]
                game_board[empty_row][empty_col] = temp
                num_moves += 1
            }
            break
        case "RIGHT":
            if empty_col < 2 {
                let temp = game_board[empty_row][empty_col+1]
                game_board[empty_row][empty_col+1] = game_board[empty_row][empty_col]
                game_board[empty_row][empty_col] = temp
                num_moves += 1
            }
            break
        default:
            //throw error
            break
        }
    }
    
    //retrieve a list of valid moves for the player to move the blank tile
    private func getAvailableMoves() -> [String] {
        var directions = [String]()
        if empty_row > 0 {
            directions.append("UP")
        }
        if empty_row < 4 {
            directions.append("DOWN")
        }
        if empty_col > 0 {
            directions.append("LEFT")
        }
        if empty_col < 4 {
            directions.append("RIGHT")
        }
        return directions
    }
    
    //update the coordinates of the empty tile
    private func updateEmptyCoord() {
        for row in 0...4 {
            for column in 0...4 {
                if game_board[row][column] == "e" {
                    self.empty_row = row
                    self.empty_col = column
                }
            }
        }
    }
    
    func gameOverNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GAMPI Game Over"), object: self, userInfo: nil)
    }
    
    func updateGameState() {
        switch game_state {
        case .in_progress:
            if self.hasWon() {
                self.updateToGameOver()
            }
            break
        case .gameover:
            self.gameoverAction()
            break
        }
    }
    
    private func hasWon() -> Bool {
        //retrieve the center 3x3 and compare it to gameboard
        return false
    }
    
    private func updateToGameOver() {
        game_state = .gameover
        gameoverAction()
    }
    
    private func gameoverAction() {
        gameOverNotification()
    }
    
    
    //for debugging purposes: print the gameboard
    private func printBoard() {
        for row in game_board {
            print(row)
        }
        print("\n")
    }
    
}
