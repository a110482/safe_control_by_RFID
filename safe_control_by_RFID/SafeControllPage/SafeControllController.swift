//
//  SafeControllController.swift
//  safe_control_by_RFID
//
//  Created by elijah tam on 2019/8/15.
//  Copyright © 2019 elijah tam. All rights reserved.
//

import Foundation
import UIKit


class SafeControllController:UIViewController{
    @IBOutlet weak var groupTableView: UITableView!

    let model = SafeControllModel()
    
    private var Navi:UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        model.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SafeControllLogPageViewController
        destination.setupModel(model: model)
    }
}

extension SafeControllController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getBravoSquads().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BravoSquadTableViewCell") as! BravoSquadTableViewCell
        let bravoSquad = model.getBravoSquads()[indexPath.row]
        cell.setBravoSquad(bravoSquad: bravoSquad)
        cell.selectionStyle = .none
        return cell
    }
}

extension SafeControllController:SafeControllModelDelegate{
    func dataDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.groupTableView.reloadData()
        }
    }
}
