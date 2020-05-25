//
//  AddSoundCardVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class AddSoundCardVC: UITableViewController {

    let sectionTitles = ["header", "object recognition", "post capture", "footer"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBackground(imageName: "Background Apps-01.jpg")
        setupTableView()
        
    }
}

extension AddSoundCardVC {
    func setupTableView() {
         registerHeaderCell()
         registerObjectRecognitionCell()
         registerPostCaptureCell()
        registerFooterCell()
     }
    
    func registerHeaderCell() {
        let nib = UINib(nibName: HeaderTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: HeaderTableViewCell.cellID)
    }
    
    func registerObjectRecognitionCell() {
        let nib = UINib(nibName: ObjectRecognitionTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: ObjectRecognitionTableViewCell.cellID)
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
        return self.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == AddSoundCardSection.SECTION_HEADER {
            return 120
        }

        if indexPath.section == AddSoundCardSection.SECTION_OBJECT_RECOGNITION {
            return 564
        }
        
        if indexPath.section == AddSoundCardSection.SECTION_POST {
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
        if section == AddSoundCardSection.SECTION_OBJECT_RECOGNITION {
            return makeObjectRecognitionCell(at: indexPath)
        }
        if section == AddSoundCardSection.SECTION_POST {
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
        //Insert Delegate Action Here
        return cell
    }
    
    func makeObjectRecognitionCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObjectRecognitionTableViewCell.cellID, for: indexPath) as! ObjectRecognitionTableViewCell
        //Insert Delegate Action Here
        return cell
    }
    
    func makePostCaptureCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCaptureTableViewCell.cellID, for: indexPath) as! PostCaptureTableViewCell
        //Insert Delegate Action Here
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

extension AddSoundCardVC {
    func addBackground(imageName:String) {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background Apps-01"))
    }
}
