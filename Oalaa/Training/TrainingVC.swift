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
    @IBOutlet weak var playbuttonText: UIButton!
    
    var dataManager: DataManager = DataManager()
    lazy var activeCategory: NSManagedObject = dataManager.getCategory(coreVocab: false, installed: true, index: 0)
    var answerText: String = ""
    var defaultImage = UIImage (named: "AppIcon")
    var defaultCard = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // text to speech part
    @IBAction func playTrainingButton(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: answerText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
        
    @IBAction func reloadTrainingImage(_ sender: Any) {
        let fetchRandomSoundcard: NSManagedObject = dataManager.getRandomInstalledSoundcard()
        
        // flip animation added
        if defaultCard {
            defaultCard = false
            trainingDefaultImage.image = defaultImage
            UIView.transition(with: trainingDefaultImage, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
            playbuttonText.setTitle("Next Card", for: .normal)
            nameOfTrainingImage.text = ""
        }
        else {
            defaultCard = true
            trainingDefaultImage.image = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
            
            //defaultImage = trainingDefaultImage.image
            UIView.transition(with: trainingDefaultImage, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
           
            // displaying name of soundcard
            nameOfTrainingImage.text = fetchRandomSoundcard.value(forKey: "soundcardName") as? String
            
            let utterance = AVSpeechUtterance(string: fetchRandomSoundcard.value(forKey: "soundcardName") as! String)
            utterance.voice = AVSpeechSynthesisVoice(language: "en")
            utterance.rate = 0.5
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            answerText = nameOfTrainingImage.text!
            
            TaskManager.addAction(action: .speak)
            playbuttonText.setTitle("Next Card", for: .normal)
        }
    }
    
}
