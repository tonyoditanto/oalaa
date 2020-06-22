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
	lazy var activeCategory: NSManagedObject = dataManager.getCategory(coreVocab: true, installed: true, index: 0)
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
		if defaults.bool(forKey: "alreadyShowFirstInstallationWarning") == false {
			let alert = UIAlertController(title: "A Kind Reminder", message: "Soundcard will not working if the phone is muted!", preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			
			present(alert, animated: true)
			defaults.set(true, forKey: "alreadyShowFirstInstallationWarning")
		}
	}

	@objc func addCategoryDismissed() {
		activeCategoryIndexPath = IndexPath(item: 0, section: 0)
		activeCategory = dataManager.getCategory(coreVocab: true, installed: true, index: 0)
		categoryCollection.reloadData()
		soundcardCollection.reloadData()
	}

	@objc func addSoundcardDismissed() {
		categoryCollection.reloadData()
		soundcardCollection.reloadData()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.categoryCollection {
			return dataManager.getCategoryTotal(installed: true)+1
		} else {
			return dataManager.getSoundcardTotalForThisCategory(category: activeCategory)+1
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.categoryCollection {
			if indexPath.item <= dataManager.getCategoryTotal(installed: true)-1 {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryReuseCell", for: indexPath) as! CategoryCollectionViewCell
				if activeCategory == dataManager.getCategory(coreVocab: false, installed: true, index: indexPath.item) {
					cell.activeIndicator1.isHidden = false
					cell.activeIndicator2.isHidden = false
				} else {
					cell.activeIndicator1.isHidden = true
					cell.activeIndicator2.isHidden = true
				}
				cell.categoryImageView.image = dataManager.getCategoryImageFor(index: indexPath.item, installed: true)
				return cell
			} else {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryReuseCell", for: indexPath) as! CategoryCollectionViewCell
				cell.activeIndicator1.isHidden = true
				cell.activeIndicator2.isHidden = true
				cell.categoryImageView.image = UIImage(named: "plus button")
				return cell
			}
		} else {
			if indexPath.item <= dataManager.getSoundcardTotalForThisCategory(category: activeCategory)-1 {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soundcardReuseCell", for: indexPath) as! SoundcardCollectionViewCell
				let fetchedData: NSManagedObject = dataManager.getSoundcard(category: activeCategory, index: indexPath.item)
				cell.soundcardImageView.image = dataManager.getSoundcardImageFor(category: activeCategory, index: indexPath.item)
				cell.soundcardNameLabel.text = fetchedData.value(forKey: "soundcardName") as? String
				cell.soundcardNameBackground.layer.cornerRadius = 8
				cell.soundcardNameBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
				cell.soundcardNameLabel.isHidden = false
				cell.soundcardNameBackground.isHidden = false
				return cell
			} else {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soundcardReuseCell", for: indexPath) as! SoundcardCollectionViewCell
				cell.soundcardImageView.image = UIImage(named: "plus button")
				cell.soundcardNameLabel.isHidden = true
				cell.soundcardNameBackground.isHidden = true
				return cell
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.categoryCollection {
			if indexPath.item < dataManager.getCategoryTotal(installed: true) {
				let unSelectedItem = activeCategoryIndexPath
				let newSelectedItem = indexPath
				if newSelectedItem != unSelectedItem {
					UIView.setAnimationsEnabled(false)
					activeCategoryIndexPath = indexPath
					activeCategory = dataManager.getCategory(coreVocab: false, installed: true, index: indexPath.item)
					self.categoryCollection.reloadItems(at: [unSelectedItem, newSelectedItem])
					collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
					UIView.setAnimationsEnabled(false)
					let activeCategoryObject: NSManagedObject = dataManager.getCategory(coreVocab: false, installed: true, index: indexPath.item)
					selectedCategory.text = activeCategoryObject.value(forKey: "categoryName") as? String
					let generator = UINotificationFeedbackGenerator()
					generator.notificationOccurred(.success)
					self.soundcardCollection.reloadData()
				}
			} else {
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				performSegue(withIdentifier: "installNewCategory", sender: nil)
			}
		} else {
			if indexPath.item < dataManager.getSoundcardTotalForThisCategory(category: activeCategory) {
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				dataManager.playSoundcard(category: activeCategory, index: indexPath.item)
			} else {
				let generator = UINotificationFeedbackGenerator()
				generator.notificationOccurred(.success)
				print("go to add soundcard view")
				performSegue(withIdentifier: "getTotalSoundcardForThisCategory", sender: nil)
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let AddSoundCardVC = segue.destination as? AddSoundCardVC {
//			let passCurrentActiveCategory: String = activeCategory.value(forKey: "categoryName") as! String
//			AddSoundCardVC.currentActiveCategory = passCurrentActiveCategory
//
//		}
        
        let segueID = segue.identifier ?? ""

        switch segueID
        {
            case "getTotalSoundcardForThisCategory":
                let nc = segue.destination as! AddSoundcardNavigationVC
                let destinationVC = nc.topViewController as! AddSoundCardVC
                let passCurrentActiveCategory: String = activeCategory.value(forKey: "categoryName") as! String
                destinationVC.currentActiveCategory = passCurrentActiveCategory
                destinationVC.delegate = self
            default:
                break
        }
        
	}
    //addSoundcardSegue
    
    
    
    
}

extension SoundCardVC: AddSoundCardVCDelegate {
    func refreshSoundCard() {
        self.soundcardCollection.reloadData()
    }
}
