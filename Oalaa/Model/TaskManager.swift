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
    static let listen_key = "listen"
    static let speak_key = "speak"
    static let capture_key = "capture"
    
    enum Action{
        case listen, speak, capture
    }
    
    private static func checkAllKeyExist(){
        if !UserDefaults.exists(key: listen_key) {
            defaults.set(0, forKey: listen_key)
        } else if !UserDefaults.exists(key: speak_key){
            defaults.set(0, forKey: speak_key)
        } else if !UserDefaults.exists(key: capture_key){
            defaults.set(0, forKey: capture_key)
        }
    }
    
    static func addAction(action: Action){
        switch action {
        case .listen:
            addDailyValue(key: listen_key)
        case .speak:
            addDailyValue(key: speak_key)
        case .capture:
            addDailyValue(key: capture_key)
        }
    }
    
    private static func addDailyValue(key: String) {
        if UserDefaults.exists(key: key) {
            let v = defaults.integer(forKey: key) + 1
            defaults.set(v, forKey: key)
        } else {
            defaults.set(0, forKey: key)
        }
    }
    
    static func getAllDailyMissions() -> [DailyMission]{
        checkAllKeyExist()
        return [DailyMission(name: "Listen an soundcard",
                             value: defaults.integer(forKey: listen_key),
                             maxValue: dailyMaxValue, image: "music.note",
                             userDefaultKey: listen_key),
                DailyMission(name: "Speak something",
                             value: defaults.integer(forKey: speak_key),
                             maxValue: dailyMaxValue,
                             image: "bubble.left.and.bubble.right.fill",
                             userDefaultKey: speak_key),
                DailyMission(name: "Capture an object",
                             value: defaults.integer(forKey: capture_key),
                             maxValue: dailyMaxValue,
                             image: "camera.fill",
                             userDefaultKey: capture_key)]
    }
    
}


