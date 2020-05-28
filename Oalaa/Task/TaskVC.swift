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
        initDelegate()
    }
    
    func initDelegate() {
        dailyTV.delegate = self
        dailyTV.dataSource = self
        achievementCV.delegate = self
        achievementCV.dataSource = self
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

extension TaskVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as! AchievementCell
        cell.nameLabel.text = "Achievement \(indexPath.row)"
        return cell
    }
    
    
}
