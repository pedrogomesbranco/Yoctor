//
//  DAO.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import Foundation
import Firebase



class DAO {
 
	public var dbRef: DatabaseReference
	
	init() {
		self.dbRef = Database.database().reference()
	}
	
	//MARK: CRUD functions
	
	/// Create a register on the Database from a JSON file
	///
	/// - Parameters:
	///   - object: JSON with data to be saved
	///   - path: Where to create de data
	/// - Returns: succesful of the transaction
    func create(object: [String:Any], at path: String, uid: String, _ completion: @escaping ((_ result: String) -> Void)) {
		var result = success
		
		dbRef.child("root/\(path)/").child(uid).setValue(object, withCompletionBlock: { (error, ref) in
			if (error != nil) {
				result = (error?.localizedDescription)!
			}
			
			completion(result)
		})
		
	}
	
	/// Create a register on the Database from a JSON file with automatic Id
	///
	/// - Parameters:
	///   - object: JSON with data to be saved
	///   - path: Where to create de data with the new Id
	///   - completion: block to be called after the end of transaction
	func createByAutoId(object: [String:Any], at path: String, _ completion: @escaping ((_ result: String, _ id: String) -> Void)) {
		var result = success
		
		dbRef.child("root/\(path)/").childByAutoId().setValue(object, withCompletionBlock: { (error, ref) in
			if (error != nil) {
				result = (error?.localizedDescription)!
			}
			
			completion(result, ref.key)
		})
		
	}
	
	/// Read a file from the Database
	///
	/// - Parameters:
	///   - identifier: Value that identifies the data
	///   - key: Key that identifies the data
	///   - path: Where to read de data
	///   - completion: block to be called after the end of transaction
	func read(_ identifier: Any, withKey key: String, at path: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		let ref = dbRef.child("root/\(path)").child("\(key)/\(identifier)")
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion([:], "Não existe nenhum dado no diretório requisitado.")
            }
            else {
                completion(snapshot.value as! [String : Any], success)
            }
		}) { (error) in
			completion([:], error.localizedDescription)
		}
	}
    
    func observerChildChanged(_ identifier: Any, withKey key: String, at path: String, _ completion: @escaping ((_ data: [String : String], _ result: String) -> Void)) {
        
        let ref = dbRef.child("root/\(path)").child("\(key)/\(identifier)")
        ref.observe(.childChanged, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion([:], success)
            }
            else {
                completion( [snapshot.key : snapshot.value as! String], success)
            }
        }) { (error) in
            completion([:], error.localizedDescription)
        }
    }
    
    func observerChildAdded(_ identifier: Any, withKey key: String, at path: String, _ completion: @escaping ((_ data: [String : String], _ result: String) -> Void)) {
        
        let ref = dbRef.child("root/\(path)").child("\(key)/\(identifier)")
        ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion([:], success)
            }
            else {
                completion( [snapshot.key : snapshot.value as! String], success)
            }
        }) { (error) in
            completion([:], error.localizedDescription)
        }
    }
    
    // Prepare a JSON file to be saved on the Database
    func readQueryOrderedbyChildQueryEqual(_ identifier: Any, withKey key: String, at path: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
        let ref = dbRef.child("root").child(path).queryOrdered(byChild: key).queryEqual(toValue: identifier)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dic = snapshot.value as? [String : Any] {
				completion(dic, success)
			} else {
				completion([:], success)
			}
        }) { (error) in
            completion([:], error.localizedDescription)
        }
    }
	
	// Prepare a JSON file to be saved on the Database
	func update(object: [String : Any], at path: String, uid: String, _ completion: @escaping ((_ result: String) -> Void)) {
		dbRef.child("root/\(path)").child(uid).updateChildValues(object) { (error, ref) in
			if (error != nil) {
				completion((error?.localizedDescription)!)
			}
			else {
				completion(success)
			}
		}
	}
	
	// Prepare a JSON file to be deleted on the Database
	func delete(_ identifier: String, at path: String, uid: String, _ completion: @escaping ((_ result: String) -> Void)) {
		var result = success
		
		dbRef.child("root/\(path)").child(uid).child(identifier).removeValue( completionBlock: { (error, ref) in
			if (error != nil) {
				result = (error?.localizedDescription)!
			}
			
			completion(result)
		})
	}
	
}

