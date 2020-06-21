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
			cell.layer.cornerRadius = 8
		}else{
			cell.backgroundColor = #colorLiteral(red: 0.9730067849, green: 1, blue: 0.9703419805, alpha: 1)
			cell.layer.cornerRadius = 8
		}
		cell.addCategory.image = dataManager.getCategoryImageFor(index: indexPath.item+1, installed: false)
		cell.addCategory.layer.cornerRadius = 8
		cell.categoryNameLabel.text = dataManager.getCategory(coreVocab: false, installed: false, index: indexPath.item+1).value(forKey: "categoryName") as? String
		cell.categoryLabelBg.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//		dataManager.toggleCategoryActivation(index: indexPath.item+1)
		//
		//		collectionView.reloadData()
		//		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryUpdated"), object: nil)
		//		let generator = UINotificationFeedbackGenerator()
		//		generator.notificationOccurred(.success)
		
		
		
		dataManager.toggleCategoryActivation(index: indexPath.item+1)
		
		//Update collection while keeping scroll position
		//disable animation
		UIView.setAnimationsEnabled(false)
		
		//get current active category index n bounds
		let selectedCell = collectionView.cellForItem(at: indexPath)
		let visibleRect = collectionView.convert(collectionView.bounds, to: selectedCell)
		
		
		
		//reload collectionview
		//categoryCollection.reloadData()
		categoryCollection.reloadItems(at: [indexPath])
		//self.categoryCollection.reloadItems(at: [unSelectedItem,newSelectedItem])
		// GETTING NEW VISIBLE RECT FOR SELECTED CELL
		let updatedVisibleRect = collectionView.convert(collectionView.bounds, to: selectedCell)
		
		// UPDATING COLLECTION VIEW CONTENT OFFSET
		var contentOffset = collectionView.contentOffset
		contentOffset.x = contentOffset.x + (visibleRect.origin.x - updatedVisibleRect.origin.x)
		collectionView.contentOffset = contentOffset
		
		//reenable animation
		UIView.setAnimationsEnabled(true)
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryUpdated"), object: nil)
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
		
		
		
		
		
	}
}
