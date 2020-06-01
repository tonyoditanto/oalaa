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
    var defaultImage = UIImage (named: "dionTraining")
    var defaultCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // text to speech part
    @IBAction func playTrainingButton(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: "Please say ," + answerText + ", I'm Listening")
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
        
    @IBAction func reloadTrainingImage(_ sender: Any) {
        let fetchRandomSoundcard: NSManagedObject = dataManager.getRandomInstalledSoundcard()
        
            UIView.transition(with: trainingDefaultImage, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
            trainingDefaultImage.image = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
            
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
