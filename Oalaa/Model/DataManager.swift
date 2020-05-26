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

/**
This class for managing Category and soundcard
* category have installed key that tell if that category is installed ir not. installed mean the user will see the category in the main view.
*/
class DataManager{
	let defaults = UserDefaults.standard
	
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	// Init
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	/**
	Upon creating the class this will insert all preset category and soundcard into coreData
	*/
	init() {
		if defaults.bool(forKey: "alreadyInstallCategory") == false {
			initialInstallation()
			defaults.set(true, forKey: "alreadyInstallCategory")
		}
	}
	
	/**
	this function where the preset data and will run on app first launch
	*/
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
	// MARK: CATEGORY
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	
	/**
	Print all or installed caegory to the console depends the parameter
	*/
	func PrintCategories(installed: Bool) -> Void {
		print(getCategoryTotal(installed: installed))
		for index in 0 ..< getCategoryTotal(installed: installed) {
			print("\(index)~ \(getCategory(coreVocab: false, installed: installed, index: index).value(forKey: "categoryName")!) - \(getCategory(coreVocab: false, installed: installed, index: index).value(forKey: "installed")!))")
		}
	}
	
	/**
	Return total category count.
	 - Parameter installed: to choose all or installed category
	*/
	func getCategoryTotal(installed: Bool) -> Int {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return 0}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		if installed {
			fetchRequest.predicate = NSPredicate(format: "installed == 1")
		}
		do {
			let result = try managedContex.fetch(fetchRequest)
			return result.count
		} catch {
			print("Failed")
		}
		return 0
	}
	
	/**
	Return UIImage for category.
	- Parameter index: return image for that index
	- Parameter installed: to choose all or installed category
	*/
	func getCategoryImageFor(index: Int,installed: Bool) -> UIImage {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return UIImage()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		if installed {
			fetchRequest.predicate = NSPredicate(format: "installed == 1")
		}
		do {
			let result = try managedContex.fetch(fetchRequest)
			return UIImage(data: (result[index] as AnyObject).value(forKey: "categoryImage") as! Data)!
		} catch {
			print("Failed")
		}
		return UIImage()
	}
	
	/**
	Return Category
	- Parameter coreVocab: return coreVocab
	- Parameter installed: to choose all or installed category
	- Parameter index: return Category for that index
	*/
	func getCategory(coreVocab: Bool, installed: Bool, index: Int) ->NSManagedObject {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return NSManagedObject()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		if coreVocab {
			fetchRequest.predicate = NSPredicate(format: "categoryName == %@", "General")
		}else if installed {
			fetchRequest.predicate = NSPredicate(format: "installed == 1")
			
		}
		do {
			let result = try managedContex.fetch(fetchRequest)
			if coreVocab {
				return result[0] as! NSManagedObject
			}else{
				return result[index] as! NSManagedObject
			}
			
		} catch {
			print("Failed")
		}
		return NSManagedObject()
	}
	
	/**
	to install/uninstall category
	*/
	func toggleCategoryActivation(index: Int) -> Void {
		let oldState:Bool = getCategory(coreVocab: false, installed: false, index: index).value(forKey: "installed")! as! Bool
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		fetchRequest.predicate = NSPredicate(format: "categoryName == %@", "\(String(describing: getCategory(coreVocab: false, installed: false, index: index).value(forKey: "categoryName")!))")
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
	}
	
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	// MARK: SOUNDCARD
	//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
	
	/**
	Print all or Soundcard for active .
	*/
	func PrintAllSoundcards(category: NSManagedObject, installed: Bool) -> Void{
		
		for index in 0 ..< getSoundcardTotalForThisCategory(category: category){
			print("\(getSoundcard(category:category, index:index).value(forKey:"soundcardName") ?? "-")")
		}
	}
	
	/**
	return total soundcard that linked to category
	- Parameter category: Current active category
	*/
	func getSoundcardTotalForThisCategory(category: NSManagedObject) -> Int {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return 0 }
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		fetchRequest.predicate = NSPredicate(format: "forCategory == %@", category)
		do {
			return try managedContex.fetch(fetchRequest).count
			//return result.count
		} catch {
			print("Failed")
		}
		
		return 0
	}
	
	/**
	Return Soundcard
	- Parameter category: Active Category
	*/
	func getSoundcard(category: NSManagedObject, index: Int) -> NSManagedObject{
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return NSManagedObject()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		
		fetchRequest.predicate = NSPredicate(format: "forCategory == %@", category)
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			return result[index] as! NSManagedObject
		} catch {
			print("Failed")
		}
		return NSManagedObject()
	}
	
	/**
	Play soundcard
	- Parameter category: Current active category
	- Parameter Index: soundcard index
	*/
	func getSoundcardImageFor(category: NSManagedObject, index: Int) -> UIImage {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return UIImage()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		fetchRequest.predicate = NSPredicate(format: "forCategory == %@", category)
		
		do {
		let result = try managedContex.fetch(fetchRequest)
		return UIImage(data: (result[index] as AnyObject).value(forKey: "soundcardImage") as! Data)!
		} catch {
		print("Failed")
		}
		return UIImage()
	}
	
	/**
	Play soundcard
	- Parameter category: Current active category
	- Parameter Index: soundcard index
	*/
	func playSoundcard(category: NSManagedObject, index: Int) -> Void {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		fetchRequest.predicate = NSPredicate(format: "forCategory == %@", category)
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			let speakThis:String = (result[index] as AnyObject).value(forKey: "soundcardName") as! String
			
			let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakThis)
			speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
			
			let speechSynthesizer = AVSpeechSynthesizer()
			speechSynthesizer.speak(speechUtterance)
		} catch {
			print("Failed")
		}
		return
	}
	
	/**
	Adding new soundcard
	- Parameter name: Name for the soundcard
	- Parameter image: UIImage for the soundcard
	- Parameter category: Parent category fot the soundcard
	*/
	func addNewSoundcard(name: String,image: UIImage, category: String){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)
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
