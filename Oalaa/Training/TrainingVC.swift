//
//  TrainingVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class TrainingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let mainImage = [UIImage(named: "sports"),
                     UIImage(named: "fruits"),
                     UIImage(named: "cars")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! mainCategoryCollectionViewCell
        
        cell.mainImageCategory.image = self.mainImage[indexPath.item]
        
        return cell
    }
    
}
