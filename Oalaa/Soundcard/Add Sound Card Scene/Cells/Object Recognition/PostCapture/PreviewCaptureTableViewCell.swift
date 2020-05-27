//
//  PreviewCaptureTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 25/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

protocol PreviewCaptureTableViewCellDelegate {
    func activateCamera()
}

class PreviewCaptureTableViewCell: UITableViewCell {
    static let cellID = "PreviewCaptureTableViewCell"
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    var delegate : PreviewCaptureTableViewCellDelegate?
    
//    var cardImage: UIImage!{
//        didSet{
//            //self.objectImage.image = 
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureComponentDesign()
        // Configure the view for the selected state
    }
    
    func configureComponentDesign(){
         retryButton.layer.cornerRadius = 10.0
     }
    
    @IBAction func didTapRetryButton(_ sender: Any) {
        delegate?.activateCamera()
    }
}
