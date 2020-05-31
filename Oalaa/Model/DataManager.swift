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
				["Animals","Animal",true],
				["Apparels","Apparel",false],
				["Bath","BathRoom",false],
				["Bed","BedRoom",false],
				["Colors","Color",false],
				["Drinks","Drink",false],
				["Foods","Food",false],
				["Fruits","Fruit",true],
				["Kitchen","Kitchen",false],
				["Schools","School",false],
				["Sports","Sport",false],
				["Vehicles","Vehicle",false],
				
				
		]
		
		let soundcardPreset =
			[
				//["SoundcardName","AssetName","BelongToCategory"]
				["hel[","help","General"],
				["i","i","General"],
				["like","like","General"],
				["look","look","General"],
				["me","me","General"],
				["need","need","General"],
				["not","not","General"],
				["stop","stop","General"],
				["this","this","General"],
				["what","what","General"],
				["who","who","General"],
				["bee","bee","Animals"],
				["bird","bird","Animals"],
				["cat","cat","Animals"],
				["dog","dog","Animals"],
				["fish","fish","Animals"],
				["horse","horse","Animals"],
				["lizard","lizard","Animals"],
				["rabbit","rabbit","Animals"],
				["rooster","rooster","Animals"],
				["snake","snake","Animals"],
				["apple","apple","Fruits"],
				["banana","banana","Fruits"],
				["cherry","cherry","Fruits"],
				["grape","grape","Fruits"],
				["melon","melon","Fruits"],
				["orange","orange","Fruits"],
				["papaya","papaya","Fruits"],
				["pineapple","pineapple","Fruits"],
				["strawberry","strawberry","Fruits"],
				["watermelon","watermelon","Fruits"],
				["badminton","badminton","Sports"],
				["barbel","barbel","Sports"],
				["baseball","baseball","Sports"],
				["boxing","boxing","Sports"],
				["football","football","Sports"],
				["golf","golf","Sports"],
				["pingpong","pingpong","Sports"],
				["tennis","tennis","Sports"],
				["volley","volley","Sports"],
				["yoga","yoga","Sports"],
				["Blue","Blue","Colors"],
				["Green","Green","Colors"],
				["Orange","Orange","Colors"],
				["Purple","Purple","Colors"],
				["Red","Red","Colors"],
				["Yellow","Yellow","Colors"],
		]
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		
		for item in categoryPreset {
			let categoryContext = appDelegate.persistentContainer.viewContext
            let imageData: NSData? = NSData(data: ((UIImage(named: item[1] as! String))?.jpegData(compressionQuality: 1.0)!)!)
			let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: categoryContext)!
			let category = Categories(entity: categoryEntity, insertInto: categoryContext)
			category.categoryName = item[0] as? String
			category.categoryImage = imageData as Data?
			category.installed = item[2] as! Bool
			
			for sc in soundcardPreset {
				if sc[2] == item[0] as? String {
					let soundcardContext = appDelegate.persistentContainer.viewContext
					print(sc[1])
                    let imageData: NSData? = NSData(data: ((UIImage(named: sc[1] ))?.jpegData(compressionQuality: 1.0)!)!)
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
			print("\(index)~ \(getCategory(coreVocab: false, installed: installed, index: index).value(forKey: "categoryName")!) - \(getCategory(coreVocab: false, installed: installed, index: index).value(forKey: "installed")!)")
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
	Return Category
	- Parameter CategoryName: return category with that name
	*/
	func getCategory(CategoryName: String) ->NSManagedObject {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return NSManagedObject()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
		fetchRequest.predicate = NSPredicate(format: "categoryName == %@", CategoryName)
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			return result[0] as! NSManagedObject
		} catch {
			print("Failed")
		}
		return NSManagedObject()
	}
	
	/**
	To install/uninstall category
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
	Print all or Soundcard for active category .
	- parameter category: this function will only print all soundcard for this category.
	*/
	func PrintAllSoundcards(category: NSManagedObject) -> Void{
		
		for index in 0 ..< getSoundcardTotalForThisCategory(category: category){
			print("\(getSoundcard(category:category, index:index).value(forKey:"soundcardName") ?? "-")")
		}
	}
	
	/**
	Return all or Soundcard for active category .
	- parameter category: this function will return all soundcard for this category.
	*/
	func getAllSoundcardsNames(category: NSManagedObject) -> [String]{
		var tempNames:[String] = []
		for index in 0 ..< getSoundcardTotalForThisCategory(category: category){
			tempNames.append("\(getSoundcard(category:category, index:index).value(forKey:"soundcardName") ?? "-")")
		}
		return tempNames
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
	Return Soundcard
	- Parameter soundcardName: soundcard name
	*/
	func getSoundcard(soundcardName: String) -> NSManagedObject{
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return NSManagedObject()}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		
		fetchRequest.predicate = NSPredicate(format: "soundcardName == %@", soundcardName)
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			return result[0] as! NSManagedObject
		} catch {
			print("Failed")
		}
		return NSManagedObject()
	}
	
	/**
	Replace souncard with new photo
	- Parameter soundcardName: soundcard name
	*/
	func replaceSoundcardImage(soundcardName: String, newImage: UIImage){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Soundcards")
		
		fetchRequest.predicate = NSPredicate(format: "soundcardName == %@", soundcardName)
		do {
			let result = try managedContex.fetch(fetchRequest)
			let saveThis = result[0] as! NSManagedObject
            let imageData: NSData? = NSData(data: (newImage.jpegData(compressionQuality: 1.0)!))
			saveThis.setValue(imageData, forKey: "soundcardImage")
			
			do{
				try managedContex.save()
			}catch{
				print(error)
			}
			return
		} catch {
			print("Failed")
		}
		return
	}
	
	/**
	Get Soundcard Image
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
	Get Soundcard Image
	- Parameter soundcard: Soundcard as input
	*/
	func getSoundcardImageFor(soundcard: NSManagedObject) -> UIImage {
		return UIImage(data: (soundcard.value(forKey: "soundcardImage") as! Data)) ?? UIImage()
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
			speechUtterance.voice = AVSpeechSynthesisVoice(language: "en")
			TaskManager.addAction(action: .listen)
			let speechSynthesizer = AVSpeechSynthesizer()
			speechSynthesizer.speak(speechUtterance)
		} catch {
			print("Failed")
		}
		return
	}
	/**
	Play soundcard
	- Parameter soundcard: give soundcard as input to play the sound
	*/
	func playSoundcard(soundcard: NSManagedObject) -> Void {
		let speakThis:String = (soundcard.value(forKey: "soundcardName") as! String)
		
		let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakThis)
		speechUtterance.voice = AVSpeechSynthesisVoice(language: "en")
		TaskManager.addAction(action: .listen)
		let speechSynthesizer = AVSpeechSynthesizer()
		speechSynthesizer.speak(speechUtterance)
		
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
            let imageData: NSData? = NSData(data: (image.jpegData(compressionQuality: 1.0)!))
			let soundcardEntity = NSEntityDescription.entity(forEntityName: "Soundcards", in: soundcardContext)!
			let soundcard = Soundcards(entity: soundcardEntity, insertInto: soundcardContext)
			soundcard.soundcardName = name
			soundcard.soundcardImage = imageData as Data?
			soundcard.forCategory = (result[0] as! Categories)
			do{
				try soundcardContext.save()
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundcardAdded"), object: nil)
				TaskManager.addAction(action: .capture)
			} catch let error as NSError {
				print("______Could not save_____. \(error), \(error.userInfo)")
			}
		} catch {
			print("Failed")
		}
	}
	
	/**
	fetch random soundcard for installed category
	*/
	func getRandomInstalledSoundcard() -> NSManagedObject{
		var soundcardList: [NSManagedObject] = []
		for catIndex in 0 ..< getCategoryTotal(installed: true) {
			let currentCategory = getCategory(coreVocab: false, installed: true, index: catIndex)
			for soundcardIndex in 0 ..< getSoundcardTotalForThisCategory(category: currentCategory) {
				let tempSoundcard = getSoundcard(category: currentCategory, index: soundcardIndex)
				soundcardList.append(tempSoundcard)
			}
		}
		let randomInt = Int.random(in: 0 ..< soundcardList.count)
		
		return soundcardList[randomInt]
	}
	
}
