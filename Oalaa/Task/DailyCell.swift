//
//  DailyCell.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 28/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valuePV: UIProgressView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
