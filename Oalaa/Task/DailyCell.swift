//
//  DailyCell.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 28/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class DailyCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valuePV: UIProgressView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }

}
