//
//  Person.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import UIKit

class Person {
    
    public var name: String!
    public var email: String!
    public var phone: Int!
	public var photo: UIImage!
	
	init() {}
	
	init(name: String, email: String, phone: Int, photo: UIImage) {
		self.name = name
		self.email = email
		self.phone = phone
		self.photo = photo
	}
	
	init?(json: [String:Any], _ completion: ((_ image: UIImage?) -> Void)? = nil) {
		if let name = json["name"] as? String { self.name = name }
		
		if let email = json["email"] as? String { self.email = email }
		
		if let phone = json["phone"] as? Int { self.phone = phone }
		
		if let photoURL = json["photo_url"] as? String {
			let url = URL(string: photoURL)
			
			URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
				if error == nil {
					DispatchQueue.main.async {
						self.photo = UIImage(data: data!)
						
						if completion != nil {
							completion!(UIImage(data: data!)!)
						}
					}
				}
				else {
					if completion != nil {
						completion!(nil)
					}
				}
			}).resume()
		}
	}
	
	public func makeJSON() -> [String:Any] {
		var jsonObject = [String:Any]()
		
		if let validName = self.name { _ = jsonObject.updateValue(validName, forKey: "name") }
		
		if let validEmail = self.email { _ = jsonObject.updateValue(validEmail, forKey: "email") }
		
		if let validPhone = self.phone { _ = jsonObject.updateValue(validPhone, forKey: "phone") }
		
		if JSONSerialization.isValidJSONObject(jsonObject) {
			return jsonObject
		}
		
		return [:]
	}
	
	public func firstName() -> String {
		return name.components(separatedBy: " ").first!
	}
	
}
