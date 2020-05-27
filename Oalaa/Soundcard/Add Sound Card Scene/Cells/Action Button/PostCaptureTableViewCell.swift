//
//  PostCaptureTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 22/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

protocol PostCaptureTableViewCellDelegate {
    func saveCard()
    func playCard()
}

class PostCaptureTableViewCell: UITableViewCell {
    static let cellID = "PostCaptureTableViewCell"
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate : PostCaptureTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //saveButton.isEnabled = true
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
    
    @IBAction func didTapSpeakButton(_ sender: Any) {
        delegate?.playCard()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        delegate?.saveCard()
        //saveButton.isEnabled = false
    }
    
}
