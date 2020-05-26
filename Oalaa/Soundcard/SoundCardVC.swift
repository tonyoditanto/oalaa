//
//  ViewController.swift
//  Oalaa
//
//  Created by Rizal Hidayat on 20/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import CoreData
class SoundCardVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var dataManager: DataManager = DataManager()
	let defaults = UserDefaults.standard
	lazy var activeCategory: NSManagedObject = dataManager.getCoreVocab()
	lazy var activeCategoryIndexPath: IndexPath = IndexPath(item: 0, section: 0)
	@IBOutlet weak var categoryCollection: UICollectionView!
	@IBOutlet weak var soundcardCollection: UICollectionView!
	@IBOutlet weak var selectedCategory: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(SoundCardVC.addCategoryDismissed),
											   name: NSNotification.Name(rawValue: "categoryUpdated"),
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(SoundCardVC.addSoundcardDismissed),
											   name: NSNotification.Name(rawValue: "soundcardAdded"),
											   object: nil)
		categoryCollection.dataSource = self
		soundcardCollection.dataSource = self
		categoryCollection.delegate = self
		soundcardCollection.delegate = self
		selectedCategory.text = "General"
	}
	@objc func addCategoryDismissed() {
		//dataManager.reloadAllCategory()
		//dataManager.loadGeneralSoundcard()
		dataManager = DataManager()
		activeCategory = dataManager.getCoreVocab()
		categoryCollection.reloadData()
		soundcardCollection.reloadData()
	}
	@objc func addSoundcardDismissed() {
		dataManager.reloadSoundcard(Category: activeCategory)
		categoryCollection.reloadData()
		soundcardCollection.reloadData()
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.categoryCollection {
			return dataManager.getTotalInstalledCategory()+1
		}else{
			return dataManager.getTotalSoundcardForThisCategory()+1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.categoryCollection {
			if indexPath.item <= dataManager.getTotalInstalledCategory()-1 {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryReuseCell", for: indexPath) as! CategoryCollectionViewCell
				
				if activeCategory == dataManager.getInstalledCategoryAtIndex(index: indexPath.item) {
					cell.activeIndicator1.isHidden = false
					cell.activeIndicator2.isHidden = false
				}else{
					cell.activeIndicator1.isHidden = true
					cell.activeIndicator2.isHidden = true
				}
				
				cell.categoryImageView.image = dataManager.getInstalledCategoryImageFor(index: indexPath.item)
				
				return cell
			}else{
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryReuseCell", for: indexPath) as! CategoryCollectionViewCell
				cell.activeIndicator1.isHidden = true
				cell.activeIndicator2.isHidden = true
				cell.categoryImageView.image = UIImage(named: "plus button")
				
				return cell
			}
		}else{
			if indexPath.item <= dataManager.getTotalSoundcardForThisCategory()-1 {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soundcardReuseCell", for: indexPath) as! SoundcardCollectionViewCell
				
				cell.soundcardImageView.image = dataManager.getInstalledSoundcardImageFor(index: indexPath.item)
				
				return cell
			}else{
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soundcardReuseCell", for: indexPath) as! SoundcardCollectionViewCell
				
				cell.soundcardImageView.image = UIImage(named: "plus button")
				
				return cell
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.categoryCollection {
			if indexPath.item < dataManager.getTotalInstalledCategory() {
				let unSelectedItem = activeCategoryIndexPath
				let newSelectedItem = indexPath
				if newSelectedItem != unSelectedItem{
					//Update collection while keeping scroll position
					//disable animation
					UIView.setAnimationsEnabled(false)
					
					//get current active category index n bounds
					let selectedCell = collectionView.cellForItem(at: indexPath)
					let visibleRect = collectionView.convert(collectionView.bounds, to: selectedCell)
					
					//update current active category
					activeCategoryIndexPath = indexPath
					activeCategory = dataManager.getInstalledCategoryAtIndex(index: indexPath.item)
					
					//reload collectionview
					self.categoryCollection.reloadItems(at: [unSelectedItem,newSelectedItem])
					
					// GETTING NEW VISIBLE RECT FOR SELECTED CELL
					let updatedVisibleRect = collectionView.convert(collectionView.bounds, to: selectedCell)
					
					// UPDATING COLLECTION VIEW CONTENT OFFSET
					var contentOffset = collectionView.contentOffset
					contentOffset.x = contentOffset.x + (visibleRect.origin.x - updatedVisibleRect.origin.x)
					collectionView.contentOffset = contentOffset
					
					//reenable animation
					UIView.setAnimationsEnabled(true)
					
					//Update soundcard
					let activeCategoryObject: NSManagedObject = dataManager.getInstalledCategoryAtIndex(index: indexPath.item)
					selectedCategory.text = activeCategoryObject.value(forKey: "categoryName") as? String
					// MARK: Update soundcard collection
					dataManager.reloadSoundcard(Category: activeCategoryObject)
					dataManager.PrintAllSoundcards()
					let generator = UINotificationFeedbackGenerator()
					generator.notificationOccurred(.success)
					self.soundcardCollection.reloadData()
				}
			}else{
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				performSegue(withIdentifier: "installNewCategory", sender: nil)
			}
		} else {
			// MARK: Sound card collection tapped
			if indexPath.item < dataManager.getTotalSoundcardForThisCategory() {
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				dataManager.playSoundcard(index: indexPath.item)
				
			}else{
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				print("go to add soundcard view")
				performSegue(withIdentifier: "getTotalSoundcardForThisCategory", sender: nil)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let AddSoundCardVC = segue.destination as? AddSoundCardVC {
			let passCurrentActiveCategory: String = activeCategory.value(forKey: "categoryName") as! String
			AddSoundCardVC.currentActiveCategory = passCurrentActiveCategory
		}
	}
}

