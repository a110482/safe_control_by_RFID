//
//  BravoSquadTableViewCell.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/15.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import UIKit

class BravoSquadTableViewCell:UITableViewCell{
    @IBOutlet weak var firemanCollectionView: UICollectionView!
    private var bravoSquad:BravoSquad?
    override func awakeFromNib() {
        firemanCollectionView.delegate = self
        firemanCollectionView.dataSource = self
    }
    
    func setBravoSquad(bravoSquad:BravoSquad){
        self.bravoSquad = bravoSquad
        self.firemanCollectionView.reloadData()
        if bravoSquad.fireMans.count > 0{
            self.firemanCollectionView.scrollToItem(at: IndexPath(row: bravoSquad.fireMans.count-1, section: 0), at: .right, animated: true)
        }
        
    }
    
}

extension BravoSquadTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.bravoSquad?.fireMans.count ?? 0
        return count > 10 ? count:10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = firemanCollectionView.dequeueReusableCell(withReuseIdentifier: "FiremanCollectionViewCell", for: indexPath) as! FiremanCollectionViewCell
        if self.bravoSquad?.fireMans.count ?? 0 <= indexPath.row{
            cell.setFireman(fireman: nil)
        }else{
            cell.setFireman(fireman: self.bravoSquad?.fireMans[indexPath.row])
        }
        return cell
    }
    
    
}
