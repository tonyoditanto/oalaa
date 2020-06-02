//
//  TaskVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {

    
    @IBOutlet weak var dailyCV: UICollectionView!
    @IBOutlet weak var achievementCV: UICollectionView!
    var dailies = [DailyMission]()
    var achievements = [Achievement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
        dailies = TaskManager.getAllDailyMissions()
        achievements = TaskManager.getAllAchievement()
		navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initDelegate() {
        dailyCV.delegate = self
        dailyCV.dataSource = self
        achievementCV.delegate = self
        achievementCV.dataSource = self
    }
}

extension TaskVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.achievementCV {
            return achievements.count
        } else {
            return dailies.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.achievementCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as! AchievementCell
            let achievement = achievements[indexPath.row]
            cell.nameLabel.text = achievement.name
            cell.actionLabel.text = achievement.actionName
            cell.badgeIV.image = UIImage(systemName: achievement.image)
            let defaults = UserDefaults.standard
            let v = defaults.integer(forKey: achievement.userDefaultKey)
            cell.valuePV.progress = Float(v) / Float(achievement.maxValue)
            cell.valueLabel.text = (v > achievement.maxValue) ? "Completed" : "\(v) / \(achievement.maxValue)"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCell
            let daily = dailies[indexPath.row]
            cell.nameLabel.text = daily.name
            cell.imageIV.image = UIImage(systemName: daily.image)
            cell.valuePV.progress =  Float(daily.value) / Float(daily.maxValue)
            cell.valueLabel.text = (daily.value > daily.maxValue) ?  "\(daily.maxValue) / \(daily.maxValue)" : "\(daily.value) / \(daily.maxValue)"
            return cell
        }
        
    }
    
    
}
