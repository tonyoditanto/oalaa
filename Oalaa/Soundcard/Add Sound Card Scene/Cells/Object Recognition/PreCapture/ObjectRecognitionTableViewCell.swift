//
//  ObjectRecognitionTableViewCell.swift
//  Oalaa
//
//  Created by Tony Varian Yoditanto on 22/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import AVFoundation

protocol ObjectRecognitionTableViewCellDelegate {
  func previewCapture()
}

class ObjectRecognitionTableViewCell: UITableViewCell {
    static let cellID = "ObjectRecognitionTableViewCell"
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var objectNameLabel: UILabel!
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput : AVCapturePhotoOutput?
    
    var delegate:ObjectRecognitionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureComponentDesign()
        registerCamera()
        setCaptureOutput()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureComponentDesign(){
        captureButton.layer.cornerRadius = 10.0
    }
    
    func registerCamera(){
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            cameraView.layer.addSublayer(videoPreviewLayer!)
            videoPreviewLayer?.frame = cameraView.layer.bounds
            captureSession?.startRunning()
        } catch  {
            print("error")
        }
    }
    
    func setCaptureOutput(){
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    func capturePhoto(){
        guard let capturePhotoOutput = self.capturePhotoOutput else {return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func didTapCaptureButton(_ sender: Any) {
        capturePhoto()
        delegate?.previewCapture()
//        delegate?.previewCapture()
        //captureSession?.stopRunning()
    }
}

extension ObjectRecognitionTableViewCell : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings?, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("error")
                return
        }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else{
        return
    }
    let capturedImage = UIImage.init(data: imageData, scale: 1.0)
    if let image = capturedImage {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    }
}
