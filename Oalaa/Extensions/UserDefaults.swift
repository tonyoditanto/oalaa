//
//  UserDefaults.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 29/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
