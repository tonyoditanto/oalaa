//
//  CustomProgressView.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 02/06/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class CustomProgressView: UIProgressView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
    

}
