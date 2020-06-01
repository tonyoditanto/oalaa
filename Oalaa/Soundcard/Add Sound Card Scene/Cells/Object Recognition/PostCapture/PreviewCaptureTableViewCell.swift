//
//  PreviewCaptureTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 25/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol PreviewCaptureTableViewCellDelegate {
    func activateCamera()
    func storedCaptureObjectName(with objectName : String)
    func actionButtonStatus(with status : Bool)
}

class PreviewCaptureTableViewCell: UITableViewCell {
    static let cellID = "PreviewCaptureTableViewCell"
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var objectNameLabel: UILabel!
    var objectName : String = ""
    var delegate : PreviewCaptureTableViewCellDelegate?
    
    var cardImage: UIImage!
    {
        didSet{
            self.objectImage.image = cardImage
            updateClassifications(for: cardImage)
        }
    }
    
    var cardCategory : String!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentDesign()
    }
    
    func configureComponentDesign(){
         retryButton.layer.cornerRadius = 10.0
     }
    
    @IBAction func didTapRetryButton(_ sender: Any) {
        delegate?.activateCamera()
    }
    
    func storedCaptureObjectNameToAddSoundCardVC(with objectName : String){
        delegate?.storedCaptureObjectName(with: objectName)
    }
    
    func setActionButtonStatus(with status : Bool){
        delegate?.actionButtonStatus(with: status)
    }
    
    // MARK: - Image Classification
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `Resnet50` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `Resnet50` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: Resnet50().model)

            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage!) {
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create image.") }

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.objectNameLabel.text = "Unable to classify image."
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]

            if classifications.isEmpty {
                self.objectNameLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
                
                //Fetch object Name
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   //return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                    return classification.identifier
                }
                
                //Fetch confidence Rate
                let confidenceRate = topClassifications.map { classification in return classification.confidence}
                
                if confidenceRate[0] < 0.5 {
                    self.objectNameLabel.text = "Object isn't identified"
                    self.setActionButtonStatus(with: false)
                }
                
                if confidenceRate[0] >= 0.5 {
                    let string = descriptions[0]
                    var finalName : String = ""
                    if string.contains(",") {
                        let array = string.components(separatedBy: ", ")
                        finalName = array[0]
                    }else{
                        finalName = string
                    }
                    self.objectNameLabel.text = finalName
                    self.storedCaptureObjectNameToAddSoundCardVC(with: finalName)
                    self.setActionButtonStatus(with: true)
                }
            }
        }
    }
}
