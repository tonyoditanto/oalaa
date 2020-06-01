//
//  Achievement.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 29/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import Foundation

struct Achievement {
    var name: String
    var image: String
    var actionName: String
    var maxValue: Int
    var actionIdentifier: TaskManager.Action
    var userDefaultKey: String
}
