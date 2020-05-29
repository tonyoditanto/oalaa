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
        utterance.voice = AVSpeechSynthesisVoice(language: "id")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
        
    // text variable
    var textToSpeech = "Hello Dion , coba katakan ini gambar apa hayoo"
    
    let chosenTextToSpeech = ["Let's Play Sports Category",
                              "Let's Play Fruits and Vegetables Category",
                              "Let's Play Automotive Category"]
    
    
    @IBAction func reloadTrainingImage(_ sender: Any) {
        let fetchRandomSoundcard: NSManagedObject = dataManager.getRandomInstalledSoundcard()
        trainingDefaultImage.image = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
        nameOfTrainingImage.text = fetchRandomSoundcard.value(forKey: "soundcardName") as? String
        let utterance = AVSpeechUtterance(string: fetchRandomSoundcard.value(forKey: "soundcardName") as! String)
        utterance.voice = AVSpeechSynthesisVoice(language: "id")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        answerText = nameOfTrainingImage.text!
        
    }
    
    @IBAction func playTheAnswerButton(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: answerText)
        utterance.voice = AVSpeechSynthesisVoice(language: "id")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        

        
    }
    
    
}
