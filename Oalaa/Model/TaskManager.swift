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
    static let listen_key = "listen"
    static let speak_key = "speak"
    static let capture_key = "capture"
    
    enum Action{
        case listen, speak, capture
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

}


