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
    
    
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var green_tick: UIImageView!
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var status_indicator: UIActivityIndicatorView!
    
    var bluetoothManager: CBCentralManager?
    var devicePeripheral: CBPeripheral?
    //characteristics
    var board_colors_characteristic: CBCharacteristic?
    
    var updatePending = false
    let DEVICE_NAME = "LAMPI b827ebea4174"
    let LAMP_SERVICE_UUID = "0001A7D3-D8A4-4FEA-8174-1736E808C067"
    let BOARD_COLORS_UUID = "0002A7D3-D8A4-4FEA-8174-1736E808C067"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updatePending = false
        self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //print(central.state == .poweredOn)
        if central.state == .poweredOn {
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
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect devicePeripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral \(devicePeripheral)")
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
                print("BOARD READ: \(data![0])")
            }
        }
    }
    
    @IBAction func quit_game(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    private func transition_to_connected_view() {
        self.status_label.text = "Connected!"
        self.status_indicator.isHidden = true
        self.info_label.isHidden = false
    }
    
    private func transition_to_game_view() {
        self.status_label.isHidden = true
        self.info_label.isHidden = true
        
        
    }

}
