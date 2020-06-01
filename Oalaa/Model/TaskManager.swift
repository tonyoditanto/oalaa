//
//  TaskManager.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 29/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import CoreData

class TaskManager{
    private static let defaults = UserDefaults.standard
    private static let dailyMaxValue = 5
    static let daily_listen_key = "listen"
    static let daily_speak_key = "speak"
    static let daily_capture_key = "capture"
    
    enum Action{
        case listen, speak, capture
    }
    
    static func addAction(action: Action){
        switch action {
        case .listen:
            addDailyValue(key: daily_listen_key)
        case .speak:
            addDailyValue(key: daily_speak_key)
        case .capture:
            addDailyValue(key: daily_capture_key)
        }
        addAchievementValue(action: action)
    }
    
    private static func addDailyValue(key: String) {
            let v = defaults.integer(forKey: key) + 1
            defaults.set(v, forKey: key)
    }
    
    private static func addAchievementValue(action: Action){
        let filteredAchievement = self.getAllAchievement().filter{ $0.actionIdentifier == action}
        var achievementKey = [String]()
        for achievement in filteredAchievement{
            achievementKey.append(achievement.userDefaultKey)
        }
        
        for key in achievementKey{
            let v = defaults.integer(forKey: key) + 1
            defaults.set(v, forKey: key)
        }
    }
    
    static func getAllDailyMissions() -> [DailyMission]{
        return [DailyMission(name: "Listen an soundcard",
                             value: defaults.integer(forKey: daily_listen_key),
                             maxValue: dailyMaxValue, image: "music.note",
                             userDefaultKey: daily_listen_key),
                DailyMission(name: "Speak something",
                             value: defaults.integer(forKey: daily_speak_key),
                             maxValue: dailyMaxValue,
                             image: "bubble.left.and.bubble.right.fill",
                             userDefaultKey: daily_speak_key),
                DailyMission(name: "Capture an object",
                             value: defaults.integer(forKey: daily_capture_key),
                             maxValue: dailyMaxValue,
                             image: "camera.fill",
                             userDefaultKey: daily_capture_key)]
    }
    
    static func getAllAchievement() -> [Achievement]{
        return[Achievement(name: "Talkative",
                           image: "bubble.left.and.bubble.right.fill",
                           actionName: "Speak something",
                           maxValue: 500,
                           actionIdentifier: .speak,
                           userDefaultKey: "achv_speak_0"),
               Achievement(name: "Photographer",
                           image: "camera.fill",
                           actionName: "Capture an object",
                           maxValue: 500,
                           actionIdentifier: .capture,
                           userDefaultKey: "achv_capture_0")
        ]
    }
    
}


