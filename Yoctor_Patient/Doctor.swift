//
//  Doctor.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import UIKit

class Doctor: Person {
    
    public var crm: Int!
    public var specialty: String!
	public var workingDays: [Int]!
	public var workingTimeInterval: [CustomDate]!
	
	init(name: String, email: String, phone: Int, photo: UIImage, CRM: Int, specialty: String) {
		super.init(name: name, email: email, phone: phone, photo: photo)
        self.crm = CRM
        self.specialty = specialty
    }
	
	override init?(json: [String:Any], _ completion: ((_ image: UIImage?) -> Void)? = nil) {
        let doctorInfo = ["name": json["name"], "email": json["email"], "phone": json["phone"], "photo_url": json["photo_url"]]
		super.init(json: doctorInfo, completion)
		
		if let jsonCrm = json["crm"] as? Int { crm = jsonCrm }
		
		if let jsonSpecialty = json["specialty"] as? String { specialty = jsonSpecialty }
		
		if let jsonWorkingDays = json["working_days"] as? String {
			let days = jsonWorkingDays.components(separatedBy: ",")
			workingDays = []
			
			for day in days {
				workingDays.append(Int(day)!)
			}
		}
		
		if let jsonWorkingTime = json["working_time"] as? String {
			let times = jsonWorkingTime.components(separatedBy: ",")
			workingTimeInterval = [CustomDate(), CustomDate()]
			
			workingTimeInterval[0] = CustomDate(fromDescription: "", times[0])
			workingTimeInterval[1] = CustomDate(fromDescription: "", times[1])
		}
	}
	
	public override func makeJSON() -> [String:Any] {
		var jsonObject = super.makeJSON()
		
		if let validCRM = crm { _ = jsonObject.updateValue(validCRM, forKey: "cpf") }
		
		if let validSpecialty = specialty { _ = jsonObject.updateValue(validSpecialty, forKey: "rg") }
		
		if let validWorkingDays = workingDays {
			var stringDays = ""
			
			for i in 0...validWorkingDays.count - 2 {
				stringDays += String(validWorkingDays[i]) + ","
			}
			stringDays += String(validWorkingDays[validWorkingDays.count - 1])
			
			_ = jsonObject.updateValue(stringDays, forKey: "working_days")
		}
		
		if let validWorkingTime = workingTimeInterval {
			let stringTimes = validWorkingTime[0].timeDescription() + "," + validWorkingTime[1].timeDescription()
			_ = jsonObject.updateValue(stringTimes, forKey: "working_time")
		}
		
		if JSONSerialization.isValidJSONObject(jsonObject) {
			return jsonObject
		}
		
		return [:]
	}
	
	func getServiceIntervals() -> [CustomDate] {
		let slice = workingTimeInterval[0].timePassed(from: workingTimeInterval[1]) / 3
		
		return [workingTimeInterval[0], workingTimeInterval[0].shifted(of: slice), workingTimeInterval[0].shifted(of: slice * 2)]
	}
	
}
