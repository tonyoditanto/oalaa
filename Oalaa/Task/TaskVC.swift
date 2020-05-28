//
//  TaskVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {

    @IBOutlet weak var dailyTV: UITableView!
    @IBOutlet weak var achievementCV: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyTV.delegate = self
        dailyTV.dataSource = self
    }
    
}

extension TaskVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
        cell.nameLabel.text = "Daily \(indexPath.row)"
        return cell
    }
}
