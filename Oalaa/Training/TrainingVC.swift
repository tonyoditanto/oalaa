//
//  TrainingVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import AVFoundation


class TrainingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var trainingDefaultImage: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
    }
    
    // text to speech part
    
    @IBAction func playTrainingButton(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: textToSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    // collection view part
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataManager.getCategoryTotal(installed: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! mainCategoryCollectionViewCell
        
        //cell.mainImageCategory.image = self.mainImage[indexPath.item]
        cell.mainImageCategory.image = dataManager.getCategoryImageFor(index: indexPath.item, installed: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        trainingDefaultImage.image = dataManager.getCategoryImageFor(index: indexPath.item, installed: true)
    }
    
    
    
    // text variable
    var textToSpeech = "Hello Dion , please select the category to play"
    
    let chosenTextToSpeech = ["Let's Play Sports Category",
                              "Let's Play Fruits and Vegetables Category",
                              "Let's Play Automotive Category"]
    
}
