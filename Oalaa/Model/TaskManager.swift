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
		print("1")
        var calender = Calendar.current
        calender.timeZone = TimeZone.current
        let today = Date()
        let savedDate = (defaults.object(forKey: dateResetKey) ?? Date()) as! Date
        let result = calender.isDate(today, inSameDayAs: savedDate)
		print("2")
        if !result {
			print("3")
            resetDaily()
			print("4")
            defaults.set(today, forKey: dateResetKey)
			print("5")
        }
		print("6")
    }
    
    private static func resetDaily(){
		print("-1")
        defaults.set(0, forKey: dailySpeakKey)
		print("-2")
        defaults.set(0, forKey: dailyListenKey)
		print("-3")
        defaults.set(0, forKey: dailyCaptureKey)
		print("-4")
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
                           userDefaultKey: "achv_capture_0"),
               Achievement(name: "Great Listener",
                           image: "music.note",
                           actionName: "Listen an soundcard",
                           maxValue: 500,
                           actionIdentifier: .listen,
                           userDefaultKey: "achv_listen_0"),
               Achievement(name: "Chit-chatter",
                           image: "bubble.left.and.bubble.right.fill",
                           actionName: "Speak something",
                           maxValue: 5000,
                           actionIdentifier: .speak,
                           userDefaultKey: "achv_speak_1"),
               Achievement(name: "Object Hunter",
                           image: "camera.fill",
                           actionName: "Capture an object",
                           maxValue: 5000,
                           actionIdentifier: .capture,
                           userDefaultKey: "achv_capture_1"),
        ]
    }
    
}


