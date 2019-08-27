//
//  BluetoothModel.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/7/31.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import CoreBluetooth

fileprivate let customCBUUID = CBUUID(string: "0xFFE0")
fileprivate let customChatacteristic = CBUUID(string: "0xFFE1")

protocol BluetoothModelDelegate {
    func didReciveRFIDDate(uuid:String)
}

class BluetoothModel:NSObject{
    var centralManager: CBCentralManager?
    var customPeripheral: CBPeripheral?
    var delegate:BluetoothModelDelegate?
    var sendCharacteristic:CBCharacteristic?
    
    static let singletion = BluetoothModel()
    
    private override init() {
        super.init()
        let centralQueue:DispatchQueue = DispatchQueue(label: "centralQueue")
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func sendDataToRFID(data: Data){
        customPeripheral?.writeValue(data, for: sendCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        print(customPeripheral ?? "nil")
    }
}

// 藍芽代理
extension BluetoothModel:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            print("bluetooth on")
            centralManager?.scanForPeripherals(withServices:nil, options: nil)
        }else{
            print("bluetooth off")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name != "HC-08"{return}
        print("name: \(peripheral.name!)")

        customPeripheral = peripheral
        customPeripheral?.delegate = self
        centralManager?.stopScan()
        centralManager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connect")
        customPeripheral?.discoverServices([customCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disConnect")
        centralManager?.scanForPeripherals(withServices:nil, options: nil)
    }
}

// 外圍設備代理
extension BluetoothModel:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services!{
            if service.uuid == customCBUUID{
                print("didDiscoverServices: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for chatacteristic in service.characteristics!{
            if chatacteristic.uuid == customChatacteristic{
                print("chatacteristic: \(chatacteristic.uuid)")
                sendCharacteristic = chatacteristic;
                peripheral.setNotifyValue(true, for: chatacteristic)
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == customChatacteristic else{return}

        if let val = characteristic.value, let rfidUUID = String(data: val, encoding: .utf8){
            self.delegate?.didReciveRFIDDate(uuid: rfidUUID)
        }
        else{
            print("recive data: data error")
        }
    }
}
