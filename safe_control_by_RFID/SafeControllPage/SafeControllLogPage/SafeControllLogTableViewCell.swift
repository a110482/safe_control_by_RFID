//
//  SafeControllLogTableViewCell.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/18.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import UIKit

class SafeControllLogTableViewCell:UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var status: UILabel!
    private let enterColor = UIColor(displayP3Red: 0, green: 150/255, blue: 1, alpha: 1)
    private let leaveColor = UIColor(displayP3Red: 1, green: 138/255, blue: 216/255, alpha: 1)
    enum ColorSetting {
        case Enter
        case Leave
    }
    var colorSetting:ColorSetting = .Enter
    
    func setFireman(fireman:Fireman){
        self.name.text = fireman.name
        self.timestamp.text = fireman.timestamp.since1970ToString()
    }
    func setColorSetting(colorSetting:ColorSetting){
        switch colorSetting {
        case .Enter:
            self.backgroundColor = enterColor
        default:
            self.backgroundColor = leaveColor
        }
    }
}

extension TimeInterval{
    func since1970ToString() -> String{
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: self)
        return dateFormat.string(from: date)
    }
}
