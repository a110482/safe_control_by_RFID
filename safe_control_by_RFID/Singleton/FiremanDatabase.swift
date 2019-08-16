//
//  FiremanDatabase.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/15.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation


struct Fireman {
    let name:String
    let uuid:String
    let timestamp:TimeInterval
}

class FiremanDatabase:NSObject{
    
    static let singleton = FiremanDatabase()
    let sss = ["7991B08C", "A9DB18B", "BA719E15", "CAD8E15"]
    private let nameDic:Dictionary<String,String> = [
        "7991B08C" : "蔡佩珊",
        "A9DB18B" : "俞怡珊",
        "BA719E15" : "張書豪",
        "CAD8E15" : "廖志明",
        ]
    
    private override init(){
        super.init()
    }
    
    
    func getFireman(by uuid:String) -> Fireman?{
        if let name = nameDic[uuid]{
            return Fireman(name: name, uuid: uuid, timestamp:Date().timeIntervalSince1970)
        }
        return nil
    }
}
