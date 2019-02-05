//
//  Login.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import UIKit

class Login {
	
	public var user: Person?
	public var typeOfUser: UserTypes?
	private let personDAO: DAO_Person!
    //private let clinicDAO: DAO_Clinic!
    
	//MARK:- Singleton Definition
	private static var theOnlyInstance: Login?
	static var sharedInstance: Login {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = Login()
			}
			return theOnlyInstance!
		}
	}
	private init() {
		personDAO = DAO_Person.sharedInstance
        //clinicDAO = DAO_Clinic.sharedInstance
	}
	
	//MARK:- Login functions
	public func verifyLogin(email: String, password: String, _ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.loginUser(withEmail: email, password: password, { (result) -> Void in
			if result == success {
				self.personDAO.getLoggedUserInfo({ (data, result) in
					if result == success {
                        self.typeOfUser = self.personDAO.kindOfLoggedUser
                        if self.typeOfUser == .Doctor {
                            
                            self.user = Doctor(json: data)
                        }
                        else {
                            
                            self.user = Patient(json: data)
                        }
                    }
					completion(result)
				})
			}
			else {
				completion(result)
			}
		})
    }
	
	public func verifyLoggedUser(_ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.hasLoggedUser( { (result) -> Void in
			if result == success {
				self.user = nil
				self.personDAO.getLoggedUserInfo({ (data, result) in
					if result == success {
						self.typeOfUser = self.personDAO.kindOfLoggedUser
						if self.typeOfUser == .Doctor {
							
							self.user = Doctor(json: data)
						}
						else {
							
							self.user = Patient(json: data)
						}
					}
					completion(result)
				})
			}
			else {
				completion(result)
			}
		})
	}
	
	public func logout(_ completion: @escaping ((_ success: String) -> Void)) {
		personDAO.logoutUser( { (result) -> Void in
			if result == success {
				self.user = nil
				self.typeOfUser = nil
                AgendaAppointment.sharedInstance.clear()
			}
			
			completion(result)
		})
	}
	
	public func sendConfirmationEmail(_ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.sendConfirmationEmail(completion)
	}
	
	//MARK:- Store user's info functions
	public func registerUser(info: [String : Any], password: String, _ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.createUser(email: info["email"] as! String, password: password) { (result) in
			if result == success {
				self.personDAO.savePersonalInfo(info, { (result) in
					if result == success {
						self.typeOfUser = self.personDAO.kindOfLoggedUser
						
						if self.typeOfUser == .Doctor {
							self.user = Doctor(json: info)
						}
						else {
							self.user = Patient(json: info)
						}
					}
					
					completion(result)
				})
			}
			else {
				completion(result)
			}
		}
	}
	
	public func updateUserPicture(to image: UIImage, _ completion: @escaping ((_ result: String) -> Void)) {
		let oldPhoto = user?.photo
		user?.photo = image
		
		personDAO.saveProfilePicture(image) { (result) in
			if result != success {
				self.user?.photo = oldPhoto
			}
			
			completion(result)
		}
	}
	
	public func updateUserInfo(info: [String:Any], _ completion: @escaping ((_ result: String) -> Void)) {
		let oldPhoto = user?.photo
		let oldInfo = user?.makeJSON()
		var updatedInfo = oldInfo
		for item in info { _ = updatedInfo?.updateValue(item.value, forKey: item.key) }
		
		if typeOfUser == .Doctor {
			user = Doctor(json: updatedInfo!)
		}
		else {
			user = Patient(json: updatedInfo!)
		}
		user?.photo = oldPhoto
		
		personDAO.updatePersonalInfo(info) { (result) in
			if result != success {
				if self.typeOfUser == .Doctor {
					self.user = Doctor(json: oldInfo!)
				}
				else {
					self.user = Patient(json: oldInfo!)
				}
			}
			
			completion(result)
		}
	}
	
	//MARK:- Update user's login info functions
	public func changePasswordOf(email: String, _ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.sendPasswordEmail(to: email, completion)
	}
	
	public func changeEmail(to email: String, _ completion: @escaping ((_ result: String) -> Void)) {
		personDAO.updateEmail(to: email, completion)
	}
	
}
