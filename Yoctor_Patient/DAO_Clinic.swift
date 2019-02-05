//
//  DAO_Clinic.swift
//  Yoctor_Patient
//
//  Created by Wellington Bezerra on 07/08/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation
import Firebase

class DAO_Clinic: DAO {
	
	private var personDAO: DAO_Person!
    
    //MARK: Singleton Definition
    private static var theOnlyInstance: DAO_Clinic?
    static var sharedInstance: DAO_Clinic {
        get {
            if theOnlyInstance == nil {
                theOnlyInstance = DAO_Clinic()
            }
            return theOnlyInstance!
        }
    }
    
    private override init() {
        personDAO = DAO_Person.sharedInstance
    }
    
    public func fetchUIDOfClinics( _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
        read("", withKey: (personDAO.loggedUser?.uid)!, at: "patient_clinics", completion)
    }
    
    public func fetchInfo(ofClinic UIDOfClinic: String, _ completion: @escaping ((_ clinic: [String : Any], _ result: String) -> Void)) {
        read("", withKey: UIDOfClinic, at: "clinic", completion)
    }
	
	public func fetchDoctors(ofClinic doctorsTable: String, _ completion: @escaping ((_ clinic: [String : Any], _ result: String) -> Void)) {
		read("", withKey: "", at: doctorsTable, completion)
	}
	
}
