//
//  MultiplayerGamePageViewController.swift
//  GAMPI
//
//  Created by Dennis Lin on 5/4/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import UIKit
import CoreBluetooth

class MultiplayerGamePageViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //Game UI
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var green_tick: UIImageView!
    @IBOutlet weak var status_indicator: UIActivityIndicatorView!
    @IBOutlet var board_row1: [UIImageView]!
    @IBOutlet var board_row2: [UIImageView]!
    @IBOutlet var board_row3: [UIImageView]!
    @IBOutlet var board_row4: [UIImageView]!
    @IBOutlet var board_row5: [UIImageView]!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var start_button: UIButton!
    @IBOutlet weak var reload_button: UIButton!
    
    var game_board : [[UIImageView]]
    var game_controller : GAMPIGameController
    var is_multiplayer = true
    //bluetooth service
    var bluetoothManager: CBCentralManager?
    var devicePeripheral: CBPeripheral?
    //characteristics
    var board_colors_characteristic: CBCharacteristic?
    let DEVICE_NAME = "GAMPI b827eb9e4116"
    let LAMP_SERVICE_UUID = "0001A7D3-D8A4-4FEA-8174-1736E808C067"
    let BOARD_COLORS_UUID = "0002A7D3-D8A4-4FEA-8174-1736E808C067"
    //storing new retrieved board
    var new_board : [[String]]
    
    //nightmode
    @IBOutlet var gradient_view: GradientView!
    var is_nightmode : Bool = false
    var background_colors : [UIColor] = [UIColor.purple, UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game_board.append(board_row1)
        game_board.append(board_row2)
        game_board.append(board_row3)
        game_board.append(board_row4)
        game_board.append(board_row5)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.bluetoothManager != nil && self.devicePeripheral != nil {
            self.bluetoothManager?.connect(self.devicePeripheral!, options: nil)
            print("Found \(DEVICE_NAME)")
        }
        if is_nightmode {
            gradient_view.firstColor = UIColor.black
            gradient_view.secondColor = UIColor.black
        }
        else {
            gradient_view.firstColor = self.background_colors[0]
            gradient_view.secondColor = self.background_colors[1]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.game_board = [[UIImageView]]()
        self.new_board = [ ["r", "r", "r", "r", "b"],
                            ["g", "c", "y", "y", "b"],
                            ["g", "c", "e", "y", "b"],
                            ["g", "c", "c", "y", "b"],
                            ["g", "o", "o", "o", "o"]]
        self.game_controller = GAMPIGameController()
        super.init(coder: aDecoder)
        self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        let aSelector : Selector = #selector(GamePageViewController.handleNotificationGameDidEnd(_: ))
        NotificationCenter.default.addObserver(self, selector: aSelector, name: NSNotification.Name(rawValue: "GAMPI Game Over"), object: game_controller)
    }
    
    //a function to trigger the gameover notification
    @objc func handleNotificationGameDidEnd(_ notification: Notification) {
        if notification.userInfo != nil {
            let message = "Press SHUFFLE on the GAMPI to shuffle the board first."
            let alert = UIAlertController(title: "You won!", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Done!", style: .default, handler: ({
                (_: UIAlertAction) -> Void in self.transition_to_victory_view()}))
            alert.addAction(restartAction)
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
            //update the number of moves?
            //Why bother...
        }
    }
    
    private func restart_game(board: [[String]]) {
        //for debug only
        //call game controller's restart game
        self.game_controller.reset_game(is_multiplayer: true, debug: false, board: board)
        //render the images for goal and game boards
        self.render_gameboard()
    }
    
    private func render_gameboard() {
        for row in 0...4 {
            for column in 0...4 {
                self.game_board[row][column].image = UIImage(named: "\(game_controller.game_board[row][column]).png")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //BLUETOOTH CODE
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //print(central.state == .poweredOn)
        if central.state == .poweredOn {
            print("Finding Lamp Service")
            let services = [CBUUID(string: LAMP_SERVICE_UUID)]
            bluetoothManager?.scanForPeripherals(withServices: services, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover devicePeripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (devicePeripheral.name == DEVICE_NAME) {
            self.devicePeripheral = devicePeripheral
            bluetoothManager?.connect(self.devicePeripheral!, options: nil)
            print("Found \(DEVICE_NAME)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect devicePeripheral: CBPeripheral) {
        print("Connected to peripheral \(devicePeripheral)")
        devicePeripheral.delegate = self
        devicePeripheral.discoverServices([CBUUID(string: LAMP_SERVICE_UUID)])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral devicePeripheral: CBPeripheral, error: Error?) {
        
        print("Disconnected from peripheral \(devicePeripheral)")
        self.bluetoothManager?.connect(devicePeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect devicePeripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral \(devicePeripheral)")
        self.bluetoothManager?.connect(devicePeripheral, options: nil)
    }
    
    func peripheral(_ devicePeripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("SEARCHING FOR SERVICES")
        for service in devicePeripheral.services ?? [] {
            if service.uuid.isEqual(CBUUID(string: LAMP_SERVICE_UUID)) {
                print("Found LAMP_SERVICE")
                print("Searching for Characteristics in this service...")
                devicePeripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            //sample
            if characteristic.uuid.isEqual(CBUUID(string: BOARD_COLORS_UUID)) {
                print("Found characteristic: BOARD_COLORS")
                self.board_colors_characteristic = characteristic
                devicePeripheral?.readValue(for: characteristic)
                devicePeripheral?.setNotifyValue(true, for: characteristic)
                self.transition_to_connected_view()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didUpdateValueForCharacteristic error: \(error)")
        }
        //reading board colors
        if characteristic == board_colors_characteristic {
            let data: Data? = characteristic.value
            if data != nil {
                let board = data!.map {String(UnicodeScalar(UInt8($0))).lowercased()}
                self.new_board = self.convert_to_2DBoard(array: board)
                self.restart_game(board: self.new_board)
            }
        }
    }
    
    @IBAction func quit_game(_ sender: UIButton) {
        self.quit()
    }
    
    @IBAction func start_game(_ sender: UIButton) {
        self.devicePeripheral?.readValue(for: self.board_colors_characteristic!)
        self.transition_to_game_view()
    }
    
    @IBAction func reload_board(_ sender: UIButton) {
        self.devicePeripheral?.readValue(for: self.board_colors_characteristic!)
        //self.render_gameboard(true)
    }
    
    private func quit() {
        dismiss(animated: false, completion: nil)
    }
    
    private func transition_to_connected_view() {
        self.status_label.text = "Connected!"
        self.status_indicator.isHidden = true
        self.green_tick.isHidden = false
        self.devicePeripheral?.readValue(for: self.board_colors_characteristic!)
        self.status_label.text = "Press Start!"
        self.start_button.isHidden = false
    }
    
    private func transition_to_game_view() {
        self.status_label.isHidden = true
        self.start_button.isHidden = true
        self.green_tick.isHidden = true
        self.initializeSwipeGestures()
        self.reload_button.isHidden = false
        self.render_gameboard(true)
    }
    
    private func render_gameboard(_ yes: Bool) {
        for row in self.game_board {
            for tile in row {
                tile.isHidden = !yes
            }
        }
        self.background.isHidden = !yes
    }
    
    private func transition_to_victory_view() {
        self.render_gameboard(false)
        self.reload_button.isHidden = true
        self.status_label.text = "Press SHUFFLE on the GAMPI. Then press Play!"
        self.status_label.isHidden = false
        self.green_tick.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.devicePeripheral?.readValue(for: self.board_colors_characteristic!)
            self.start_button.isHidden = false
        }
    }
    
    private func convert_to_2DBoard(array: [String]) -> [[String]] {
        let results = array.chunked(into: 5)
        return results
    }

}


//implemented from https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
//Created by Paul Hudson
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
