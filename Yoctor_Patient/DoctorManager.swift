//
//  DoctorManager.swift
//  Yoctor_Patient
//
//  Created by Wellington Bezerra on 14/08/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class DoctorManager {
	
	private let personDAO: DAO_Person!
	
	/// Key: doctor's uid, Value: doctor's info
	public var doctors: [String : Doctor]!
	
	
	//MARK: Singleton Definition
	private static var theOnlyInstance: DoctorManager?
	static var sharedInstance: DoctorManager {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = DoctorManager()
			}
			return theOnlyInstance!
		}
	}
	
	private init() {
		personDAO = DAO_Person.sharedInstance
		
		doctors = [String : Doctor]()
	}
	
	public func getDoctors( _ completion: @escaping ((_ result: String) -> Void)) {
		
		personDAO.fetchUIDOfDoctors( { (data,result) -> Void in
			if result == success {
				//infoOfDoctor.key: uid of clinic
				//infoofDoctor.value: Name of clinic table
                print("\(data)")

				for infoOfDoctor in data {
					self.personDAO.fetchInfo(ofDoctor: infoOfDoctor.key) { (doctor,result) in
						if result == success {
							let oneDoctor = Doctor(json: doctor, { (image) in
								if image != nil && self.doctors.count == data.count {
									var result = success
									
									for (_, person) in self.doctors {
										if person.photo == nil {
											result = "Nem todas as fotos foram carregadas."
											break
										}
									}
									
									completion(result)
								}
							})
							
							self.doctors.updateValue(oneDoctor!, forKey: infoOfDoctor.key)
						}
					}
				}
			}
			else{
				completion(result)
			}
		})
	}
	
	func getUIDfrom(_ doctor: Doctor) -> String {
		for (uid, doc) in doctors {
			if doc.email == doctor.email {
				return uid
			}
		}
		
		return ""
	}
	
}
