//
//  AchievementCell.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 28/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class AchievementCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgeIV: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var valuePV: UIProgressView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
}
