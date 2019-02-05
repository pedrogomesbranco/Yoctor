//
//  DAO_Appointment.swift
//  Yoctor
//
//  Created by Ana Luiza Ferrer on 14/05/17.
//  Copyright © 2017 AnaLuizaFerrer_GustavoOlenka_LucasFerraço_PedroBranco. All rights reserved.
//

import Foundation

class DAO_Appointment: DAO {
	
	private var pathAppointment = "appointments"
	private var pathPatientsAppointment = "patients_appointments"
    private var personDAO: DAO_Person!
    
	//MARK: Singleton Definition
	private static var theOnlyInstance: DAO_Appointment?
	static var sharedInstance: DAO_Appointment {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = DAO_Appointment()
			}
			return theOnlyInstance!
		}
	}
	private override init() {
        personDAO = DAO_Person.sharedInstance
    }
	
	//MARK: Access
	public func fetchAppointments(at date: Date, withDoctor doctor: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		fetchAppointments(ofDay: date) { (data, result) in
			if result != success {
				completion(data, result)
				return
			}
			
			for appointment in data {
				let item = appointment.value as! [String : String]
				
				if item["doctor_email"] == doctor {
					completion(item, success)
					return
				}
			}
			
			completion([:], "Não existe consulta marcada com o médico especificado nesse dia.")
		}
	}
	
	public func fetchAppointments(at date: Date, withPatient patient: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		fetchAppointments(ofDay: date) { (data, result) in
			if result != success {
				completion(data, result)
				return
			}
			
			for appointment in data {
				let item = appointment.value as! [String : String]
				
				if item["patient_email"] == patient {
					completion(item, success)
					return
				}
			}
			
			completion([:], "Não existe consulta marcada com o paciente especificado nesse dia.")
		}
	}
	
	public func fetchAppointments(ofDay day: Date, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		read("", withKey: "", at: pathPatientsAppointment + (personDAO.loggedUser?.uid)!, completion)
	}
	
	public func fetchAppointments(ofDoctor doctor: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		read(doctor, withKey: "doctor_email", at: pathAppointment, completion)
	}
    
    //
    public func fetchAppointmentsOfPatient(ofClinic clinicTablename: String, _ completion: @escaping ((_ appointemnts: [String : Any], _ result: String) -> Void)) {
        let uidUser = personDAO.loggedUser?.uid
        
        readQueryOrderedbyChildQueryEqual(uidUser!, withKey: "patient_uid", at: clinicTablename) { (appointments, result) in
            completion(appointments, result)
        }
    }
    
    public func fetchAppointmentOfPatient(ofClinic clinicTablename: String, ofAppointmentUID appointmentUID: String, _ completion: @escaping ((_ appointemnts: [String : Any], _ result: String) -> Void)) {
        
        read("", withKey: appointmentUID, at: clinicTablename, completion)
    }
    
    //
    public func observerAppointment(withKey key: String, onClinic clinic: String, _ completion: @escaping ( (_ data: [String : String], _ result: String) -> Void )) {
        observerChildChanged("", withKey: key, at: clinic, completion)
    }
    
    /**
     check if any new appointment have been registered
     
     - Parameter withkey: key of patient
     - Parameter onTablePatients: table name of patients
     
     - Returns: new appointment saved.
     */
    public func observerNewAppointment(withKey key: String, onTablePatients tablePatients: String, _ completion: @escaping ( (_ data: [String : String], _ result: String) -> Void )) {
        let uidUser = personDAO.loggedUser?.uid
        observerChildAdded(key, withKey: uidUser!, at: tablePatients, completion)
    }
	
	public func fetchAppointment(onDay day: Date, at time: String, _ completion: @escaping ((_ data: [String : Any], _ result: String) -> Void)) {
		fetchAppointments(ofDay: day) { (data, result) in
			if result != success {
				completion(data, result)
				return
			}
						
			for appointment in data {
				let item = appointment.value as! [String : String]
				
				if item["time"] == time {
					completion(item, success)
					return
				}
			}
			
			completion([:], "Não existe consulta marcada no horário e no dia especificados.")
		}
	}
	
	//MARK: Update
	public func updateStatus(of appointment: String, on clinic: String, to status: String, _ completion: @escaping ((_ result: String) -> Void)) {
		update(object: ["status": status], at: clinic, uid: appointment, completion)
	}
	
	//MARK: Save
	public func saveNewAppointmentRequest(_ info: [String : Any], _ completion: @escaping ((_ result: String) -> Void)) {
		update(object: info, at: "requests_prevmama", uid: (personDAO.loggedUser?.uid)!, completion)
	}

}
