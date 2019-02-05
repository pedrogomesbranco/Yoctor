//
//  ClinicManager.swift
//  Yoctor_Patient
//
//  Created by Wellington Bezerra on 20/09/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation

class ClinicManager {
    
    private let clinicDAO: DAO_Clinic!
    
    /// Key: doctor's uid, Value: doctor's info
    public var clinics: [String : Clinic]!
    
    
    //MARK: Singleton Definition
    private static var theOnlyInstance: ClinicManager?
    static var sharedInstance: ClinicManager {
        get {
            if theOnlyInstance == nil {
                theOnlyInstance = ClinicManager()
            }
            return theOnlyInstance!
        }
    }
    
    private init() {
        clinicDAO = DAO_Clinic.sharedInstance
        
        clinics = [String : Clinic]()
    }
    
    public func getClinics( _ completion: @escaping ((_ result: String) -> Void)) {
        clinicDAO.fetchUIDOfClinics( { (data,result) -> Void in
            if result == success {
                //infoClinic.key: uid of clinic
                //infoClinic.value: Name of clinic table
                for infoOfClinic in data {
                    self.clinicDAO.fetchInfo(ofClinic: infoOfClinic.key) { (clinic,result) in
                        if result == success {
                            
                            let oneClinic = Clinic(json: clinic)
                            self.clinics.updateValue(oneClinic!, forKey: infoOfClinic.key)
                        }
                    }
                }
                completion(success)
            }
            else {
                completion(result)
            }
        })
        
    }
	
	
	
	/// Find the clinic where a specified doctor works
	///
	/// - Parameter doctor: doctor to be searched
	/// - Returns: uid of the clinic where the doctor works
//	func getClinicWhereWorks(the doctorUID: String) {
//		
//	}
	
}
