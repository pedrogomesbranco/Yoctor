//
//  Patient.swift
//  Yoctor
//
//  Created by Lucas Ferraço on 14/05/17.
//  Copyright © 2017 YoctorTeam. All rights reserved.
//

import UIKit

class Patient: Person {
	
	public var cpf: Int!
	public var rg: Int!
	public var uf: String!
	public var healthInsurance: String!
	public var insuranceExpiration: CustomDate!
	
	init(name: String, email: String, phone: Int, photo: UIImage, CPF: Int, RG: Int, UF: String, healthInsurance: String, insuranceExpiration: CustomDate) {
		super.init(name: name, email: email, phone: phone, photo: photo)
		self.cpf = CPF
		self.rg = RG
		self.uf = UF
		self.healthInsurance = healthInsurance
		self.insuranceExpiration = insuranceExpiration
	}
	
	override init?(json: [String:Any], _ completion: ((_ image: UIImage?) -> Void)? = nil) {
		
		let personInfo = ["name": json["name"], "email": json["email"], "phone": json["phone"], "photo_url": json["photo_url"]]
		super.init(json: personInfo, completion)
		
		if let jsonCPF = json["cpf"] as? Int { self.cpf = jsonCPF }
		
		if let jsonRG = json["rg"] as? Int { self.rg = jsonRG }
		
		if let jsonUF = json["uf"] as? String { self.uf = jsonUF }
		
		if let jsonInsurance = json["health_insurance"] as? String { self.healthInsurance = jsonInsurance }
		
		if let jsonInsExp = json["insurance_expiration"] as? String {
			self.insuranceExpiration = CustomDate(fromDescription: jsonInsExp, "00-00")
		}
	}
	
	public override func makeJSON() -> [String:Any] {
		var jsonObject = super.makeJSON()
		
		if let validCPF = self.cpf { _ = jsonObject.updateValue(validCPF, forKey: "cpf") }
		
		if let validRG = self.rg { _ = jsonObject.updateValue(validRG, forKey: "rg") }
		
		if let validUF = self.uf { _ = jsonObject.updateValue(validUF, forKey: "uf") }
		
		if let validHI = self.healthInsurance { _ = jsonObject.updateValue(validHI, forKey: "health_insurance") }
		
		if let validExpiration = self.insuranceExpiration {
			_ = jsonObject.updateValue(validExpiration.dateDescription(), forKey: "insurance_expiration")
		}
		
		if JSONSerialization.isValidJSONObject(jsonObject) {
			return jsonObject
		}
		
		return [:]
	}
	
}

