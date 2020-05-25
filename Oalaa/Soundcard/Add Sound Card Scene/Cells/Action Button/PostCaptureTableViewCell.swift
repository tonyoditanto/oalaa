//
//  PostCaptureTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 22/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class PostCaptureTableViewCell: UITableViewCell {
    static let cellID = "PostCaptureTableViewCell"
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureComponentDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureComponentDesign(){
        speakButton.layer.cornerRadius = 10.0
        saveButton.layer.cornerRadius = 10.0
    }
    
}
