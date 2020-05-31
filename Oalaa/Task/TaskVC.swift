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
    var dailies = [DailyMission]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
        dailies = TaskManager.getAllDailyMissions()
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
        return dailies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
        let daily = dailies[indexPath.row]
        cell.nameLabel.text = daily.name
        cell.imageIV.image = UIImage(systemName: daily.image)
        cell.valuePV.progress = Float(daily.value) / Float(daily.maxValue)
        cell.valueLabel.text = "\(daily.value) / \(daily.maxValue)"
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
