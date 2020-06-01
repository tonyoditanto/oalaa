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
import Speech
import AVKit


class TrainingVC: UIViewController {

    @IBOutlet weak var trainingDefaultImage: UIImageView!
    @IBOutlet weak var nameOfTrainingImage: UILabel!
    @IBOutlet weak var playbuttonText: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    
    
    var dataManager: DataManager = DataManager()
    lazy var activeCategory: NSManagedObject = dataManager.getCategory(coreVocab: false, installed: true, index: 0)
    var answerText: String = ""
    var defaultImage = UIImage (named: "dionTraining")
    var defaultCard = false

    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSpeech()
        
        btnStart.isHidden = true
    }
    
    // text to speech part
    @IBAction func playTrainingButton(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: answerText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
        
    // ====================== Play Button to Start Training =================
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
            answerText = "Please say ," + nameOfTrainingImage.text! + ", I'm Listening"
            
            //playbuttonText.setTitle("Next Card", for: .normal)
            countDownLabel.isHidden = false
            playbuttonText.isHidden = true
            timer()
            self.startRecording()
            self.btnStart.setTitle("Stop Recording", for: .normal)
    }
    
    // ================= Count Down Timer ================
    func timer() {
    var timeLeft = 10
          self.playbuttonText.setTitle("Time is up, Next Card", for: .normal)
          Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                 print("timer fired!")
            
                timeLeft -= 1
            
                self.countDownLabel.text = String(timeLeft)
                print(timeLeft)
            
            if(timeLeft==0){
                        timer.invalidate()
                //self.autoCardReload()
                self.playbuttonText.isHidden = false
                self.countDownLabel.isHidden = true
                self.countDownLabel.text = String("10")
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                self.btnStart.isEnabled = false
                self.btnStart.setTitle("Start Recording", for: .normal)
                    }
           }
    }
    
   
    
    
    // auto reload function will be called from speech recognition
    
    func autoCardReload () {
        let fetchRandomSoundcard: NSManagedObject = dataManager.getRandomInstalledSoundcard()
        
            UIView.transition(with: trainingDefaultImage, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
            trainingDefaultImage.image = dataManager.getSoundcardImageFor(soundcard: fetchRandomSoundcard)
            
            nameOfTrainingImage.text = fetchRandomSoundcard.value(forKey: "soundcardName") as? String
            
            let utterance = AVSpeechUtterance(string: fetchRandomSoundcard.value(forKey: "soundcardName") as! String)
            utterance.voice = AVSpeechSynthesisVoice(language: "en")
            utterance.rate = 0.5
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            answerText = "Please say ," + nameOfTrainingImage.text! + ", I'm Listening"
            
            playbuttonText.setTitle("Next Card", for: .normal)
            playbuttonText.isHidden = true
        
    }
    
    
    @IBAction func btnStartSpeechToText(_ sender: Any) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.btnStart.isEnabled = false
            self.btnStart.setTitle("Start Recording", for: .normal)
        } else {
            self.startRecording()
            self.btnStart.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func setupSpeech() {

        self.btnStart.isEnabled = false
        self.speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false

            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
           default:
             break
            }

            OperationQueue.main.addOperation() {
                self.btnStart.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {

        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {

                self.lblText.text = result?.bestTranscription.formattedString
             
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {

                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
                TaskManager.addAction(action: .speak)
                self.btnStart.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        self.lblText.text = "Say something, I'm listening!"
    }
    
}


extension TrainingVC: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnStart.isEnabled = true
        } else {
            self.btnStart.isEnabled = false
        }
    }
}
