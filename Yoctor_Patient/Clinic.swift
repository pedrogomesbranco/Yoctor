//
//  Clinic.swift
//  Yoctor_Patient
//
//  Created by Wellington Bezerra on 07/08/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class Clinic {
	
	public var name: String!
	public var email: String!
	public var phone: Int!
	public var photo: UIImage!
	public var site: String!
	public var doctorsTable: String!
	
	init?(json: [String:Any], _ completion: ((_ image: UIImage?) -> Void)? = nil) {
		if let name = json["name"] as? String { self.name = name }
		
		if let email = json["email"] as? String { self.email = email }
		
		if let phone = json["phone"] as? Int { self.phone = phone }
		
		if let site = json["site"] as? String { self.site = site }
		
		if let doctorsTable = json["doctors_table"] as? String { self.doctorsTable = doctorsTable }
		
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
		var jsonObject = [String : Any]()
		
		if let validName = self.name { _ = jsonObject.updateValue(validName, forKey: "name") }
		
		if let validEmail = self.email { _ = jsonObject.updateValue(validEmail, forKey: "email") }
		
		if let validPhone = self.phone { _ = jsonObject.updateValue(validPhone, forKey: "phone") }
		
		if let validSite = self.site { _ = jsonObject.updateValue(validSite, forKey: "site") }
		
		if let validDoctorsTable = self.site { _ = jsonObject.updateValue(validDoctorsTable, forKey: "doctors_table") }
		
		if JSONSerialization.isValidJSONObject(jsonObject) {
			return jsonObject
		}
		
		return [:]
	}
}

