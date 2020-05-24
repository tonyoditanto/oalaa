//
//  AddSoundCardVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class AddSoundCardVC: UITableViewController {

    let sectionTitles = ["header", "object recognition", "pre capture", "post capture"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 80
//        setupNavigationBar()
//        setTableViewContentInsetToCustom()
        setupTableView()
    }
}

extension AddSoundCardVC {
    func setupTableView() {
         registerHeaderCell()
         registerObjectRecognitionCell()
         registerPreCaptureCell()
         registerPostCaptureCell()
     }
    
    func registerHeaderCell() {
        let nib = UINib(nibName: HeaderTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: HeaderTableViewCell.cellID)
    }
    
    func registerObjectRecognitionCell() {
        let nib = UINib(nibName: ObjectRecognitionTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: ObjectRecognitionTableViewCell.cellID)
    }

    func registerPreCaptureCell() {
        let nib = UINib(nibName: PreCaptureTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: PreCaptureTableViewCell.cellID)
    }

    func registerPostCaptureCell() {
        let nib = UINib(nibName: PostCaptureTableViewCell.cellID, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: PostCaptureTableViewCell.cellID)
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
            return 460
        }
        
        if indexPath.section == AddSoundCardSection.SECTION_PRE {
            return 104
        }
        
        if indexPath.section == AddSoundCardSection.SECTION_POST {
            return 104
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
        if section == AddSoundCardSection.SECTION_PRE {
            return makePreCaptureCell(at: indexPath)
        }
        if section == AddSoundCardSection.SECTION_POST {
            return makePostCaptureCell(at: indexPath)
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
    
    func makePreCaptureCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreCaptureTableViewCell.cellID, for: indexPath) as! PreCaptureTableViewCell
        //Insert Delegate Action Here
        return cell
    }
    
    func makePostCaptureCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCaptureTableViewCell.cellID, for: indexPath) as! PostCaptureTableViewCell
        //Insert Delegate Action Here
        return cell
    }



}
