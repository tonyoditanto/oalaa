//
//  AddCategoryVC.swift
//  Oalaa
//
//  Created by Steven Wijaya on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit

class AddCategoryVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
	
	let dataManager: DataManager = DataManager()
	@IBOutlet weak var categoryCollection: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		categoryCollection.dataSource = self
		categoryCollection.delegate = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataManager.getCategoryTotal(installed: false)-1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCategoryReuseCell", for: indexPath) as! addCategoryCollectionViewCell
		let getCategoryData = dataManager.getCategory(coreVocab: false, installed: false, index: indexPath.item+1)
		
		if getCategoryData.value(forKey: "installed")! as! Bool {
			cell.backgroundColor = #colorLiteral(red: 0.6356596351, green: 0.1144892648, blue: 0.2439313233, alpha: 1)
		}else{
			cell.backgroundColor = #colorLiteral(red: 0.9730067849, green: 1, blue: 0.9703419805, alpha: 1)
		}
		cell.addCategory.image = dataManager.getCategoryImageFor(index: indexPath.item+1, installed: false)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		dataManager.toggleCategoryActivation(index: indexPath.item+1)
		collectionView.reloadData()
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryUpdated"), object: nil)
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
		
	}
}
