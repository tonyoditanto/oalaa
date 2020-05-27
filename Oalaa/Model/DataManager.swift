//
//  categories.swift
//  Oalaa
//
//  Created by Steven Wijaya on 22/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class DataManager{
	var listOfCategory: [NSManagedObject] = []
	var listOfInstalledCategory: [NSManagedObject] = []
	var listOfActiveCategorySoundcard: [NSManagedObject] = []
	let defaults = UserDefaults.standard
	
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	// MARK: INITIALIZER
	init() {
		if defaults.bool(forKey: "alreadyInstallCategory") {
			loadAllCategory()
			loadGeneralSoundcard()
		} else {
			initialInstallation()
			loadAllCategory()
			loadGeneralSoundcard()
			defaults.set(true, forKey: "alreadyInstallCategory")
		}
	}
	
	// MARK: Insert preinstalled data to coreData
	func initialInstallation() -> Void {
		let categoryPreset =
			[
				//["CategoryName","AssetName","Installed"]
				["General","CoreVocab",true],
				["Foods","Food",true],
				["Fruits","Fruit",true],
				["Sports","Sport",false],
				["Animals","Animal",false],
				["Apparels","Apparel",false],
				["Bath","BathRoom",false],
				["Bed","BedRoom",false],
				["Drinks","Drink",false],
				["Kitchen","Kitchen",false],
				["Vehicles","Vehicle",false],
				["Schools","School",false]
		]
		
		let soundcardPreset =
			[
				//["SoundcardName","AssetName","BelongToCategory"]
				["Tolong","help","General"],
				["Aku","i","General"],
				["Suka","like","General"],
				["Lihat","look","General"],
				["Buah campur","Fruit","Foods"],
				["HAHAHAHAHAHA","i","General"],
				["Lol","i","General"]
		]
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		
		for item in categoryPreset {
			let categoryContext = appDelegate.persistentContainer.viewContext
			let imageData: NSData? = NSData(data: ((UIImage(named: item[1] as! String))?.pngData()!)!)
			let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: categoryContext)!
			let category = Categories(entity: categoryEntity, insertInto: categoryContext)
			category.categoryName = item[0] as? String
			category.categoryImage = imageData as Data?
			category.installed = item[2] as! Bool
			
			for sc in soundcardPreset {
				if sc[2] == item[0] as? String {
					let soundcardContext = appDelegate.persistentContainer.viewContext
					let imageData: NSData? = NSData(data: ((UIImage(named: sc[1] ))?.pngData()!)!)
					let soundcardEntity = NSEntityDescription.entity(forEntityName: "Soundcards", in: soundcardContext)!
					let soundcard = Soundcards(entity: soundcardEntity, insertInto: soundcardContext)
					soundcard.soundcardName = sc[0]
					soundcard.soundcardImage = imageData as Data?
					category.addToHaveSoundcard(soundcard)
					do{
						try soundcardContext.save()
					} catch let error as NSError {
						print("______Could not save_____. \(error), \(error.userInfo)")
					}
				}
				
			}
			
			do{
				try categoryContext.save()
			} catch let error as NSError {
				print("______Could not save_____. \(error), \(error.userInfo)")
			}
		}
	}
	
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	// MARK: CATEGORY
	
	// MARK: CAT LOADER
	func loadAllCategory()->Void {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			
			for eachData in result as! [NSManagedObject] {
				if (eachData.value(forKey: "installed") as! Bool == true) {
					listOfInstalledCategory.append(eachData)
					listOfCategory.append(eachData)
				}else{
					listOfCategory.append(eachData)
				}
			}
		} catch {
			print("Failed")
		}
	}
	
	func reloadAllCategory() -> Void {
		self.listOfCategory = []
		self.listOfInstalledCategory = []
		self.loadAllCategory()
	}
	
	// MARK: CAT PRINTER
	func PrintAllCategories() -> Void {
		for category in listOfCategory {
			print("\(category.value(forKey: "categoryName")!)-\(category.value(forKey: "installed")!)")
		}
	}
	func PrintInstalledAllCategories() -> Void {
		for category in listOfInstalledCategory {
			print("\(category.value(forKey: "categoryName")!)-\(category.value(forKey: "installed")!)")
		}
	}
	
	// MARK: CAT FUNC
	func getTotalCategory() -> Int {
		return listOfCategory.count
	}
	
	func getTotalInstalledCategory() -> Int {
		return listOfInstalledCategory.count
	}
	
	func getInstalledCategoryImageFor(index: Int) -> UIImage {
		return UIImage(data: listOfInstalledCategory[index].value(forKey: "categoryImage") as! Data)!
	}
	func getCategoryImageFor(index: Int) -> UIImage {
		return UIImage(data: listOfCategory[index].value(forKey: "categoryImage") as! Data)!
	}
	
	func getCategory(index: Int) -> NSManagedObject {
		return listOfCategory[index]
	}
	
	func getCoreVocab() ->NSManagedObject {
		return listOfCategory[0]
	}
	
	func getInstalledCategoryAtIndex(index: Int) -> NSManagedObject {
		return listOfInstalledCategory[index]
	}
	
	func toggleCategoryActivation(index: Int) -> Void {
		print("0")
		let oldState:Bool = listOfCategory[index].value(forKey: "installed")! as! Bool
		print("1")
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		fetchRequest.predicate = NSPredicate(format: "categoryName == %@", "\(String(describing: listOfCategory[index].value(forKey: "categoryName")!))")
		print("\(String(describing: listOfCategory[index].value(forKey: "categoryName")!))")
		do{
			let result = try managedContex.fetch(fetchRequest)
			
			let newData = result[0] as! NSManagedObject
			
			if oldState {
				newData.setValue(false ,forKey: "installed")
			}else{
				newData.setValue(true ,forKey: "installed")
			}
			do{
				try managedContex.save()
			}catch{
				print("Error!")
			}
			
		} catch {
			print("Error!")
		}
		reloadAllCategory()
	}
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	// MARK: SOUNDCARD
	
	// MARK: SC LOADER
	func loadGeneralSoundcard()->Void {
		listOfActiveCategorySoundcard = []
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		fetchRequest.predicate = NSPredicate(format: "%K == %@", "forCategory",listOfCategory[0])
		do {
			let result = try managedContex.fetch(fetchRequest)
			for eachData in result as! [NSManagedObject] {
				listOfActiveCategorySoundcard.append(eachData)
			}
		} catch {
			print("Failed")
		}
	}
	func reloadSoundcard(Category: NSManagedObject)->Void {
		listOfActiveCategorySoundcard = []
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		fetchRequest.predicate = NSPredicate(format: "%K == %@", "forCategory",Category)
		do {
			let result = try managedContex.fetch(fetchRequest)
			for eachData in result as! [NSManagedObject] {
				listOfActiveCategorySoundcard.append(eachData)
			}
		} catch {
			print("Failed")
		}
	}
	
	// MARK: SC PRINTER
	func PrintAllSoundcards() -> Void{
		
		for i in listOfActiveCategorySoundcard{
			print(i.value(forKey: "soundcardName")!)
		}
	}
	
	// MARK: SC FUNC
	func getTotalSoundcardForThisCategory() -> Int {
		return listOfActiveCategorySoundcard.count
	}
	func getInstalledSoundcardImageFor(index: Int) -> UIImage {
		return UIImage(data: listOfActiveCategorySoundcard[index].value(forKey: "soundcardImage") as! Data)!
	}
	func playSoundcard(index: Int) -> Void {
		let speakThis:String = listOfActiveCategorySoundcard[index].value(forKey: "soundcardName") as! String
		
		let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakThis)
		speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
		
		let speechSynthesizer = AVSpeechSynthesizer()
		speechSynthesizer.speak(speechUtterance)
	}
	
	func addNewSoundcard(name: String,image: UIImage, category: String){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		fetchRequest.predicate = NSPredicate(format: "%K == %@", "categoryName",category)
		fetchRequest.fetchLimit = 1
		do {
			let result = try managedContex.fetch(fetchRequest)
			let soundcardContext = appDelegate.persistentContainer.viewContext
			let imageData: NSData? = NSData(data: (image.pngData()!))
			let soundcardEntity = NSEntityDescription.entity(forEntityName: "Soundcards", in: soundcardContext)!
			let soundcard = Soundcards(entity: soundcardEntity, insertInto: soundcardContext)
			soundcard.soundcardName = name
			soundcard.soundcardImage = imageData as Data?
			soundcard.forCategory = (result[0] as! Categories)
			do{
				try soundcardContext.save()
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundcardAdded"), object: nil)
			} catch let error as NSError {
				print("______Could not save_____. \(error), \(error.userInfo)")
			}
		} catch {
			print("Failed")
		}
	}
}
