//
//  DAO_Person.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import Foundation
import Firebase

public enum UserTypes: String {
    case Doctor = "doctors",
    Patient = "patients"
}

class DAO_Person: DAO {
	
    public var storageRef: StorageReference
    public var loggedUser: User?
    public var kindOfLoggedUser: UserTypes?
	
	//MARK:- Singleton Definition
	private static var theOnlyInstance: DAO_Person?
	static var sharedInstance: DAO_Person {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = DAO_Person()
			}
			return theOnlyInstance!
		}
	}
	private override init() {
		self.storageRef = Storage.storage().reference()
        self.loggedUser = Auth.auth().currentUser
	}
	
	//MARK:- Login Functions
	public func getLoggedUserInfo( _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
        let uid = (loggedUser?.uid)!
        read("", withKey: uid, at: "patients") { (data, result) in
            if result == success {
                if !data.isEmpty {
                    self.kindOfLoggedUser = .Patient
                    completion(data, success)
                }
            }
			else {
				completion([:], result)
			}
		}
	}
	
	public func loginUser(withEmail email: String, password: String, _ completion: @escaping ((_ result: String) -> Void)) {
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
			if error == nil {
				self.loggedUser = user
				completion(success)
			}
			else {
				completion((error?.localizedDescription)!)
			}
		}
	}
	
	public func logoutUser(_ completion: @escaping ((_ result: String) -> Void)) {
		let firebaseAuth = Auth.auth()
		
		do {
			try firebaseAuth.signOut()
			completion(success)
		} catch _ as NSError {
			completion("Erro ao realizar logout.")
		}
	}
	
	public func hasLoggedUser(_ completion: @escaping ((_ result: String) -> Void)) {
		if Auth.auth().currentUser != nil {
			completion(success)
		}
		else {
			completion("Não existe nenhum usuário logado.")
		}
	}
	
	public func sendPasswordEmail(to email: String, _ completion: @escaping ((_ result: String) -> Void)) {
		Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
			if error == nil {
				completion(success)
			}
			else {
				completion((error?.localizedDescription)!)
			}
		})
	}
	
	public func updateEmail(to email: String, _ completion: @escaping ((_ result: String) -> Void)) {
		loggedUser?.updateEmail(to: email, completion: { (error) in
			if error == nil {
				self.sendConfirmationEmail(completion)
			}
			else {
				completion((error?.localizedDescription)!)
			}
		})
	}
	
	public func sendConfirmationEmail(_ completion: @escaping ((_ result: String) -> Void)) {
		Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
			if error == nil {
				completion(success)
			}
			else {
				completion((error?.localizedDescription)!)
			}
		})
	}
    
    public func sendRequest(_ info: [String : Any], _ completion: @escaping ((_ result: String) -> Void)) {
        create(object: info, at: "requests_prevmama", uid: (loggedUser?.uid)!, completion)
    }
	
	public func createUser(email: String, password: String, _ completion: @escaping ((_ result: String) -> Void)) {
		Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
			if error == nil {
				self.loginUser(withEmail: email, password: password, completion)
			}
			else {
				completion((error?.localizedDescription)!)
			}
		}
	}
	
	public func savePersonalInfo(_ info: [String : Any], _ completion: @escaping ((_ result: String) -> Void)) {
		create(object: info, at: "patients", uid: (loggedUser?.uid)!, completion)
	}
	
	public func updatePersonalInfo(_ info: [String : Any], _ completion: @escaping ((_ result: String) -> Void)) {
		update(object: info, at: "patients", uid: (loggedUser?.uid)!, completion)
	}
	
	//MARK:- Profile Picture functions
	public func saveProfilePicture(_ photo: UIImage, _ completion: @escaping ((_ result: String) -> Void)) {
		let storedImage = storageRef.child("profile_images").child((loggedUser?.uid)!)
		
		if let uploadData = UIImagePNGRepresentation(photo) {
			storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
				if error == nil {
					storedImage.downloadURL(completion: { (url, error) in
						if error == nil {
							if let urlText = url?.absoluteString {
								self.updatePersonalInfo(["photo_url": urlText], completion)
							}
						}
						else {
							completion((error?.localizedDescription)!)
						}
					})
				}
				else {
					completion((error?.localizedDescription)!)
				}
			})
		}
		else {
			completion("Erro ao carregar foto.")
		}
		
	}
	
	//MARK:- Patient Info Access
	public func fetchPatient(withName name: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		read(name, withKey: "name", at: "patients", completion)
	}
	
	public func fetchPatient(withEmail email: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		read(email, withKey: "email", at: "patients", completion)
	}
	
	public func fetchPatient(withCPF cpf: Int, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		read(cpf, withKey: "cpf", at: "patients", completion)
	}
	
	//MARK:- Doctor Info Access
    
    public func fetchUIDOfDoctors( _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
        read("", withKey: (loggedUser?.uid)!, at: "patient_doctors", completion)
    }
    
    public func fetchInfo(ofDoctor UIDOfDoctor: String, _ completion: @escaping ((_ doctor: [String : Any], _ result: String) -> Void)) {
        read("", withKey: UIDOfDoctor, at: "doctors", completion)
    }
	
//	public func fetchDoctor(withName name: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
//		read(name, withKey: "name", at: "doctors", completion)
//	}
//	
//	public func fetchDoctor(withEmail email: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
//		read(email, withKey: "email", at: "doctors", completion)
//	}
//	
//	public func fetchDoctor(withLicense license: Int, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
//		read(license, withKey: "license", at: "doctors", completion)
//	}
	
}
