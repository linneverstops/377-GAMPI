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
        self.shuffle(n: 30)
        //make sure the empty tile is not inside the center square
        if (self.isEmptyInsideCenterSquare()) {
            self.moveEmptyOut()
        }
        self.goal_board = self.retrieveCenterSquare()
        self.shuffle(n: 10)
        self.num_moves = 0
        self.game_state = .in_progress
    }
    
    //shuffle the game_board
    func shuffle(n: Int) {
        var directions = getAvailableMoves()
        var random_number  = Int.random(in: 0..<directions.count)
        for _ in 0..<n {
            move(direction: directions[random_number])
            self.updateEmptyTileCoord()
            directions = getAvailableMoves()
            random_number = Int.random(in: 0..<directions.count)
        }
        self.updateEmptyTileCoord()
    }
    
    private func isEmptyInsideCenterSquare() -> Bool {
        return (empty_row > 1 || empty_row < 4) && (empty_col > 1 || empty_col < 4)
    }
    
    private func moveEmptyOut() {
        let vert_move = empty_col
        let hor_move = empty_row
        for _ in 0...vert_move {
            self.move(direction: "UP")
        }
        for _ in 0...hor_move {
            self.move(direction: "LEFT")
        }
        self.updateEmptyTileCoord()
    }
    
    //retrieving the center 3x3 square of the current game board
    private func retrieveCenterSquare() -> [[String]]{
        var center_square = [["","",""],["","",""],["","",""]]
        for row in 1...3 {
            for column in 1...3 {
                center_square[row-1][column-1] = self.game_board[row][column]
            }
        }
        return center_square
    }
    
    //move the blank tile UP, DOWN, LEFT and RIGHT
    //updating the gameboard accordingly
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
            if empty_row < 4 {
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
            if empty_col < 4 {
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
        self.updateEmptyTileCoord()
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
    private func updateEmptyTileCoord() {
        for row in 0...4 {
            for column in 0...4 {
                if game_board[row][column] == "e" {
                    self.empty_row = row
                    self.empty_col = column
                }
            }
        }
    }

    
    func updateGameState() {
        switch game_state {
        case .in_progress:
            if self.hasWon() {
                self.updateToGameOver()
            }
            break
        case .gameover:
            self.generate_gameover_notification()
            break
        }
    }
    
    //the player has won if the current gameboard center matches the goal board
    private func hasWon() -> Bool {
        let current_center = self.retrieveCenterSquare()
        self.print_goalboard()
        return current_center == self.goal_board
    }
    
    private func updateToGameOver() {
        game_state = .gameover
        self.generate_gameover_notification()
    }
    
    func generate_gameover_notification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GAMPI Game Over"), object: self, userInfo: ["number of moves": self.num_moves])
    }
    
    //for debugging purposes: print the gameboard
    private func print_gameboard() {
        for row in game_board {
            print(row)
        }
        print("\n")
    }
    
    private func print_goalboard() {
        for row in goal_board {
            print(row)
        }
        print("\n")
    }
    
}
