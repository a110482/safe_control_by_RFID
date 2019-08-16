//
//  FiremanCollectionView.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/16.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import UIKit

class FiremanCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var timestampLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var barLeftVIew: BarLeftView!
    
    private var timestamp:TimeInterval?
    let barMaxTime:Double = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = LifeCircleColor.normal.getUIColor()
        countDown()
    }
    
    func setFireman(fireman:Fireman?){
        if fireman == nil{
            self.nameLable.text = nil
            self.photo.image = nil
            timestampLable.text = nil
            timestamp = nil
            changeColor(by: 1)
            barLeftVIew.setBar(ratio: 1)
            return
        }
        self.nameLable.text = fireman!.name
        self.photo.image = UIImage(named: fireman!.uuid)
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: fireman!.timestamp)
        timestampLable.text = dateFormat.string(from: date)
        
        timestamp = fireman!.timestamp
        let time_deff = Date().timeIntervalSince1970 - timestamp!
        var ratio:Double = (barMaxTime - time_deff)/barMaxTime
        ratio = ratio < 0 ? 0:ratio;
        changeColor(by: ratio)
        barLeftVIew.setBar(ratio: ratio)
    }
    
    func countDown(){
        if timestamp == nil{
            //changeColor(by: 1)
            //barLeftVIew.setBar(ratio: 1)
        }
        else{
            let time_deff = Date().timeIntervalSince1970 - timestamp!
            var ratio:Double = (barMaxTime - time_deff)/barMaxTime
            ratio = ratio < 0 ? 0:ratio;
            changeColor(by: ratio)
            barLeftVIew.setBar(ratio: ratio)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.countDown()
        }
    }
    
    private func changeColor(by ratio:Double){
        var colorSetting:LifeCircleColor = LifeCircleColor.normal
        if ratio <= 0.5{
            colorSetting = .alert
        }
        if ratio < 0.3{
            colorSetting = .critical
        }
        self.backgroundColor = colorSetting.getUIColor()
        barLeftVIew.setBar(color: colorSetting)
    }
}


