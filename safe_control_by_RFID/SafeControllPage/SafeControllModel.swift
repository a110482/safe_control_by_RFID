//
//  SafeControllModel.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/15.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation

protocol SafeControllModelDelegate{
    func dataDidUpdate()
}

struct BravoSquad {
    var fireMans:Array<Fireman>
}


class SafeControllModel:NSObject{
    override init() {
        super.init()
        BluetoothModel.singletion.delegate = self
        bravoSquads.append(BravoSquad(fireMans: []))
    }
    var delegate:SafeControllModelDelegate?
    var delegateForLog:SafeControllModelDelegate?
    
    private var bravoSquads:Array<BravoSquad> = []
    private(set) var logEnter:Array<Fireman> = []
    private(set) var logLeave:Array<Fireman> = []
    
    
    /// - Parameters uuid uuid of rfid card
    /// - Returns true if did remove someone
    private func removeFireman(by uuid:String) -> Bool{
        // test
        //return false
        for bravoSquadIndex in 0 ..< bravoSquads.count{
            if let index = bravoSquads[bravoSquadIndex].fireMans.firstIndex(where: {$0.uuid == uuid}){
                logLeave.append(bravoSquads[bravoSquadIndex].fireMans[index])
                bravoSquads[bravoSquadIndex].fireMans.remove(at: index)
                return true
            }
        }
        return false
    }
    
    /// - Parameters uuid uuid of rfid card
    /// - Returns true if fireman in database
    private func addFireman(by uuid:String) -> Bool{
        if let fireman = FiremanDatabase.singleton.getFireman(by: uuid){
            logEnter.append(fireman)
            bravoSquads[0].fireMans.append(fireman)
            return true
        }
        return false
    }
    
    private func sortLogData(){
        logEnter.sort(by: {$0.uuid > $1.uuid})
        logLeave.sort(by: {$0.uuid > $1.uuid})
    }
}

// public API
extension SafeControllModel{
    func getBravoSquads() -> Array<BravoSquad>{
        return self.bravoSquads
    }
}

// delegate from bluetooth
extension SafeControllModel:BluetoothModelDelegate{
    func reciveRFIDDate(uuid: String) {
        if !removeFireman(by: uuid){
            if(!addFireman(by: uuid)){
                print("uuid not fuund in database!")
            }
        }
        sortLogData()
        delegate?.dataDidUpdate()
        delegateForLog?.dataDidUpdate()
    }
}
