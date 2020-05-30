//
//  TrainingVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class TrainingVC: UIViewController {

    @IBOutlet weak var trainingDefaultImage: UIImageView!
    @IBOutlet weak var nameOfTrainingImage: UILabel!
    
    var dataManager: DataManager = DataManager()
    lazy var activeCategory: NSManagedObject = dataManager.getCategory(coreVocab: false, installed: true, index: 0)
    var answerText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // text to speech part
    
    @IBAction func playTrainingButton(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: textToSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
        
    // text variable
    var textToSpeech = "Say the word"
    
    
    @IBAction func reloadTrainingImage(_ sender: Any) {
        let fetchRandomSoundcard: NSManagedObject = dataManager.getRandomInstalledSoundcard()
        
        // resize image to fit 350 * 350
        let originalImageSize = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
        let newImageSize = originalImageSize.scaleImageToFitSize(size: CGSize(width: 350.0, height: 350.0))
        trainingDefaultImage.image = newImageSize.scaleImageToFitSize(size: CGSize(width: 350.0, height: 350.0))
        //trainingDefaultImage.image = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
        nameOfTrainingImage.text = fetchRandomSoundcard.value(forKey: "soundcardName") as? String
        let utterance = AVSpeechUtterance(string: fetchRandomSoundcard.value(forKey: "soundcardName") as! String)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        answerText = nameOfTrainingImage.text!
        
    }
    
    @IBAction func playTheAnswerButton(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: answerText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        TaskManager.addAction(action: .speak)

    }
    
    
}

extension UIImage {

    func scaledImage(withSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    func scaleImageToFitSize(size: CGSize) -> UIImage {
        let aspect = self.size.width / self.size.height
        if size.width / aspect <= size.height {
            return scaledImage(withSize: CGSize(width: size.width, height: size.width / aspect))
        } else {
            return scaledImage(withSize: CGSize(width: size.height * aspect, height: size.height))
        }
    }

}
