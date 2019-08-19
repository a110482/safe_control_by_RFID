//
//  SafeControllLogPageViewController.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/18.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import UIKit

class SafeControllLogPageViewController:UIViewController{
    @IBOutlet weak var safeControllEnterLogTableView: UITableView!
    @IBOutlet weak var safeControllLeaveLogTableView: UITableView!
    private var model:SafeControllModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeControllEnterLogTableView.delegate = self
        safeControllEnterLogTableView.dataSource = self
        safeControllEnterLogTableView.restorationIdentifier = "enter"
        safeControllLeaveLogTableView.delegate = self
        safeControllLeaveLogTableView.dataSource = self
        safeControllLeaveLogTableView.restorationIdentifier = "leave"
    }
    
    func setupModel(model:SafeControllModel){
        self.model = model
        model.delegateForLog = self
    }
}

extension SafeControllLogPageViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "enter"{
            return model?.logEnter.count ?? 0
        }
        return model?.logLeave.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SafeControllLogTableViewCell") as! SafeControllLogTableViewCell
        
        if tableView.restorationIdentifier == "enter"{
            cell.setFireman(fireman: model!.logEnter[indexPath.row])
            cell.status.text = "進入"
            cell.setColorSetting(colorSetting: .Enter)
        }else{
            cell.setFireman(fireman: model!.logLeave[indexPath.row])
            cell.status.text = "離開"
            cell.setColorSetting(colorSetting: .Leave)
        }
        
        return cell
    }
}

extension SafeControllLogPageViewController:SafeControllModelDelegate{
    func dataDidUpdate() {
        DispatchQueue.main.async {
            self.safeControllEnterLogTableView.reloadData()
            self.safeControllLeaveLogTableView.reloadData()
        }
    }
}
