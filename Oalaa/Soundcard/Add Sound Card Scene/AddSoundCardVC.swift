//
//  AddSoundCardVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//
//  FOR ADDING NEW SOUNDCARD
//  let dataManager = DataManager()
//  var currentActiveCategory: String = ""

import UIKit
import CoreML
import Vision
import AVFoundation

protocol AddSoundCardVCDelegate {
    func refreshSoundCard()
}

class AddSoundCardVC: UITableViewController {
    
    var backgroundmageName : String = "background"
    let sectionTitles = ["header", "object recognition", "post capture"]
    var cameraActive : Bool = true
	let dataManager = DataManager()
    var captureObject : UIImage!
    var objectName : String = "Object isn't identified"
	var currentActiveCategory: String = ""
    var actionButtonIsEnable : Bool = true
    var delegate : AddSoundCardVCDelegate?
    var objectNameTextField = UITextField()
    
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllowSelectionCell()
        setBackgroundImage(with: backgroundmageName)
        setupTableView()
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddSoundCardVC {
    func setAllowSelectionCell(){
        self.tableView.allowsSelection = false
    }
    
    func setupTableView() {
         registerHeaderCell()
         registerObjectRecognitionCell()
         registerPreviewCaptureCell()
         registerPostCaptureCell()
         registerFooterCell()
     }
    
    func setBackgroundImage(with imageName:String) {
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named:imageName)!)
    }
    
    func registerHeaderCell() {
        let nib = UINib(nibName: HeaderTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: HeaderTableViewCell.cellID)
    }
    
    func registerObjectRecognitionCell() {
        let nib = UINib(nibName: ObjectRecognitionTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: ObjectRecognitionTableViewCell.cellID)
    }
    
    func registerPreviewCaptureCell() {
        let nib = UINib(nibName: PreviewCaptureTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: PreviewCaptureTableViewCell.cellID)
    }

    func registerPostCaptureCell() {
        let nib = UINib(nibName: PostCaptureTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: PostCaptureTableViewCell.cellID)
    }
    
    func registerFooterCell() {
        let nib = UINib(nibName: FooterTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FooterTableViewCell.cellID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cameraActive == true {
            return 2
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == AddSoundCardSection.SECTION_HEADER {
            return 0
        }

        if indexPath.section == AddSoundCardSection.SECTION_OBJECT_RECOGNITION || indexPath.section == AddSoundCardSection.SECTION_OBJECT_CAPTURED{
            return 564
        }
        
        if indexPath.section == AddSoundCardSection.SECTION_POST {
            if cameraActive == true {
                return 80
            }
            return 104
        }
        
        if indexPath.section == AddSoundCardSection.SECTION_FOOTER {
            return 80
        }
            return UITableView.automaticDimension
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == AddSoundCardSection.SECTION_HEADER {
            return makeHeaderCell(at: indexPath)
        }
        if section == AddSoundCardSection.SECTION_OBJECT_RECOGNITION || section == AddSoundCardSection.SECTION_OBJECT_CAPTURED{
            if cameraActive == true {
                return makeObjectRecognitionCell(at: indexPath)
            }
            if cameraActive == false {
                return makePreviewCaptureCell(at: indexPath)
            }
        }
        if section == AddSoundCardSection.SECTION_POST {
            if cameraActive == true {
                return makeFooterCell(at: indexPath)
            }
            return makePostCaptureCell(at: indexPath)
        }
        if section == AddSoundCardSection.SECTION_FOOTER {
            return makeFooterCell(at: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func makeHeaderCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.cellID, for: indexPath) as! HeaderTableViewCell
        return cell
    }
    
    func makeObjectRecognitionCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObjectRecognitionTableViewCell.cellID, for: indexPath) as! ObjectRecognitionTableViewCell
        cell.delegate = self
        return cell
    }
    
    func makePreviewCaptureCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCaptureTableViewCell.cellID, for: indexPath) as! PreviewCaptureTableViewCell
        cell.cardImage = self.captureObject
        cell.cardCategory = self.currentActiveCategory
        cell.delegate = self
        return cell
    }

    
    func makePostCaptureCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCaptureTableViewCell.cellID, for: indexPath) as! PostCaptureTableViewCell
        cell.actionButtonIsEnable = self.actionButtonIsEnable
        cell.delegate = self
        return cell
    }
    
    func makeFooterCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.cellID, for: indexPath) as! FooterTableViewCell
        //Insert Delegate Action Here
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension AddSoundCardVC : ObjectRecognitionTableViewCellDelegate{
    func previewCapture(for captureObject : UIImage!) {
        self.captureObject = captureObject
        cameraActive = false
        self.tableView.reloadData()
    }
}

extension AddSoundCardVC : PreviewCaptureTableViewCellDelegate{
    func activateCamera() {
        cameraActive = true
        self.objectName = ""
        self.actionButtonIsEnable = true
        self.tableView.reloadData()
    }
    
    func storedCaptureObjectName(with objectName: String) {
        self.objectName = objectName
    }
    
    func translateObjectNameToIndonesia(with objectName : String){
        //Method untuk translate ke bahasa Indonesia
    }
    
    func actionButtonStatus(with status: Bool) {
        self.actionButtonIsEnable = status
        self.tableView.reloadData()
    }
}

extension AddSoundCardVC : PostCaptureTableViewCellDelegate{
    func saveCard() {
        if self.objectName == "Object isn't identified" || self.objectName == ""{
            showAlert()
        } else{
            storedToDataManager()
        }
    }
    
    func storedToDataManager(){
        switch didCardExist() {
        case true: replaceSoundCard()
        default: saveSoundCard()
        }
    }
    
    func didCardExist()->Bool{
        let activeCategory = dataManager.getCategory(CategoryName: currentActiveCategory)
        let soundcardNames = dataManager.getAllSoundcardsNames(category: activeCategory)
        
        if soundcardNames.count != 0 {
            for index in 1...soundcardNames.count {
                if soundcardNames[index-1] == self.objectName {
                    return true
                }
            }
        }
        return false
    }
    
func showAlert(){
    present(makeAlertController(), animated: true, completion: nil)
    //self.tableView.reloadData()
}

func makeAlertController() -> UIAlertController {
    
    let alertController = UIAlertController(title: "Soundcard Name", message: "Input the object name here", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
        var didCardExist = false
        let activeCategory = self.dataManager.getCategory(CategoryName: self.currentActiveCategory)
        let soundcardNames = self.dataManager.getAllSoundcardsNames(category: activeCategory)

        if soundcardNames.count != 0 {
            for index in 1...soundcardNames.count {
                if soundcardNames[index-1] == self.objectNameTextField.text ?? "" {
                    didCardExist = true
                }
            }
        }

        switch didCardExist{
        case true:
            self.dataManager.replaceSoundcardImage(soundcardName: self.objectNameTextField.text!, newImage: self.captureObject)
            self.delegate?.refreshSoundCard()
            self.dismiss(animated: true, completion: nil)
        default:
            self.dataManager.addNewSoundcard(name: self.objectNameTextField.text!, image: self.captureObject, category: self.currentActiveCategory)
            self.delegate?.refreshSoundCard()
            self.dismiss(animated: true, completion: nil)
        }

    })
    
    alertController.addTextField { (textField) in
        self.objectNameTextField = textField
        textField.placeholder = "Input here..."
        //print(self.objectNameTextField?.text)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    
    
    return alertController
}
    
    func saveSoundCard(){
        dataManager.addNewSoundcard(name: objectName, image: captureObject, category: currentActiveCategory)
        self.delegate?.refreshSoundCard()
        self.dismiss(animated: true, completion: nil)
    }
    
    func replaceSoundCard() {
        dataManager.replaceSoundcardImage(soundcardName: objectName, newImage: captureObject)
        self.delegate?.refreshSoundCard()
        self.dismiss(animated: true, completion: nil)
    }
    
    func playCard() {
        let speakThis = objectName
        
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakThis)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en")
        
        let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.speak(speechUtterance)
    }
}
