//
//  ViewController.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/7/31.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var uuidDisplay: UILabel!
    @IBAction func btnsAction(_ sender: UIButton) {
        if let data = sender.currentTitle?.data(using: .utf8){
            bt?.sendDataToRFID(data: data)
        }
    }
    
    
    var bt:BluetoothModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        bt = BluetoothModel()
        bt?.delegate = self
    }


}

extension ViewController:BluetoothModelDelegate{
    func reciveRFIDDate(uuid: String) {
        print(uuid)
        DispatchQueue.main.async { [weak self] in
            self?.uuidDisplay.text = uuid
        }
    }
}
