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
    static let dailyListenKey = "listen"
    static let dailySpeakKey = "speak"
    static let dailyCaptureKey = "capture"
    static let dateResetKey = "date_reset"
    
    enum Action{
        case listen, speak, capture
    }
    
    static func addAction(action: Action){
        switch action {
        case .listen:
            addDailyValue(key: dailyListenKey)
        case .speak:
            addDailyValue(key: dailySpeakKey)
        case .capture:
            addDailyValue(key: dailyCaptureKey)
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
        achievementKey.removeAll()
    }
    
    static func checkResetDaily(){
        var calender = Calendar.current
        calender.timeZone = TimeZone.current
        let today = Date()
        let savedDate = (defaults.object(forKey: dateResetKey) ?? Date()) as! Date
        let result = calender.isDate(today, inSameDayAs: savedDate)
        if !result {
            resetDaily()
            defaults.set(today, forKey: dateResetKey)
        }
    }
    
    private static func resetDaily(){
        defaults.set(0, forKey: dailySpeakKey)
        defaults.set(0, forKey: dailyListenKey)
        defaults.set(0, forKey: dailyCaptureKey)
    }
    
    static func getAllDailyMissions() -> [DailyMission]{
        return [DailyMission(name: "Listen an soundcard",
                             value: defaults.integer(forKey: dailyListenKey),
                             maxValue: dailyMaxValue, image: "music.note",
                             userDefaultKey: dailyListenKey),
                DailyMission(name: "Speak something",
                             value: defaults.integer(forKey: dailySpeakKey),
                             maxValue: dailyMaxValue,
                             image: "bubble.left.and.bubble.right.fill",
                             userDefaultKey: dailySpeakKey),
                DailyMission(name: "Capture an object",
                             value: defaults.integer(forKey: dailyCaptureKey),
                             maxValue: dailyMaxValue,
                             image: "camera.fill",
                             userDefaultKey: dailyCaptureKey)]
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


