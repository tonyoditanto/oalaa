//
//  ObjectRecognitionTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 22/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class ObjectRecognitionTableViewCell: UITableViewCell {
    static let cellID = "ObjectRecognitionTableViewCell"
    @IBOutlet weak var captureButton: UIButton!
    
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
        captureButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func didTapCaptureButton(_ sender: Any) {
    }
}
