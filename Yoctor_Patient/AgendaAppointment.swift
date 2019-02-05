//
//  Agenda.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 24/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit
import UserNotifications

class AgendaAppointment {
	
	private let appointmentsDAO: DAO_Appointment!
	private let clinicDAO: DAO_Clinic!
	private var allAppointments: [String : Appointment]!
	public var personDAO: DAO_Person!
	public var clinicManager: ClinicManager!
	private var tot = 0
	
	//MARK: Singleton Definition
	private static var theOnlyInstance: AgendaAppointment?
	static var sharedInstance: AgendaAppointment {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = AgendaAppointment()
			}
			return theOnlyInstance!
		}
	}
	private init() {
		appointmentsDAO = DAO_Appointment.sharedInstance
		clinicDAO = DAO_Clinic.sharedInstance
		personDAO = DAO_Person.sharedInstance
		clinicManager = ClinicManager.sharedInstance
		
		allAppointments = [String : Appointment]()
	}
	
	public func clear() {
		allAppointments.removeAll(keepingCapacity: false)
	}
	
	//MARK:- Fetch Functions
	public func getAppointments( _ completion: @escaping ((_ result: String) -> Void)) {
		clinicDAO.fetchUIDOfClinics( { (data,result) -> Void in
			if result == success {
				//infoClinic.key: uid of clinic
				//infoClinic.value: Name of clinic table
				for infoOfClinic in data{
					self.appointmentsDAO.fetchAppointmentsOfPatient(ofClinic: infoOfClinic.value as! String) { (appointments,result) in
						if result == success {
							for oneAppointment in appointments {
								let appoint = Appointment(json: oneAppointment.value as! [String : Any])!
								
								self.allAppointments.updateValue(appoint, forKey: oneAppointment.key)
							}
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
	
	//MARK:- Update Functions
	public func changeStatus(of appointment: Appointment, to status: Status, _ completion: @escaping ((_ result: String) -> Void)) {
		let appointmentUID = allAppointments.flatMap { (key: String, val: Appointment) -> String? in
			appointment == val ? key : nil
		}
		
		appointmentsDAO.updateStatus(of: appointmentUID[0], on: "appointment_prevmama", to: status.rawValue) { (result) in
			if result == success {
				self.allAppointments[appointmentUID[0]]?.status = .confirmed
			}
			
			completion(result)
		}
	}
	
	//MARK:- Observer Functions
	//
	public func setObserverTodayAppointment(tableNameOfClinic: String,  keyOfAppointment: String, _ completion: @escaping ((_ result: String) -> Void)) {
		
		self.appointmentsDAO.observerAppointment(withKey: keyOfAppointment, onClinic: tableNameOfClinic) { (infoChangedOfAppointment,result) in
			// prediction time updated
			if result == success {
				//infoChangedOfAppointment = [ key of firebase : value of key ]
				//exemple: [schedule_date : 12-02-2017 ] or [schedule_time : 01-22 ]
				self.allAppointments[keyOfAppointment]?.updateInfo(to: infoChangedOfAppointment)
				
				if infoChangedOfAppointment.keys.contains("prediction_time") {
					// call Notification Function
					self.notification(title: "Fila de espera", body: "Horário previsto para sua consulta: \(infoChangedOfAppointment["prediction_time"]!)", subtitle: "", id: "showNotification1")
				}
				else if infoChangedOfAppointment.keys.contains("patient_uid") {
					self.allAppointments.removeValue(forKey: keyOfAppointment)
				}
				
				completion(success)
			}
		}
	}
	
	/**
	check if any new appointment have been registered
	
	- Parameter withkey: key of patient
	- Parameter onTablePatients: table name of patients
	
	- Returns: new appointment saved.
	*/
	public func setObserverNewAppointment(tableNameOfPatient: String,  key: String, _ completion: @escaping ((_ result: String) -> Void)) {
		
		self.appointmentsDAO.observerNewAppointment(withKey: key, onTablePatients: tableNameOfPatient) { (infoAddedOfAppointment,result) in
			if result == success {
				//infoAddedOfAppointment.key: key of new appointment
				//infoAddedOfAppointment.value: key of clinic
				
				let qtd = infoAddedOfAppointment.count
				
				//contabiliza a quantidade de consultas existentes
				if (qtd == 1){
					self.tot = self.tot + 1
				}
				
				//identifica uma nova consulta
				if(self.tot > self.allAppointments.count || qtd == 0) {
					//funcao que pega o nome da tabela da clinica
					
					self.clinicDAO.fetchInfo(ofClinic: infoAddedOfAppointment.values.first!) { (clinic,result) in
						print(result)
						if result == success {
							let appointmentsTableName = clinic["appointments_table"]
							
							self.appointmentsDAO.fetchAppointmentOfPatient(ofClinic: appointmentsTableName as! String, ofAppointmentUID: infoAddedOfAppointment.keys.first! ) { (appointments,result) in
								if result == success {
									
									let appoint = Appointment(json: appointments)!
									print("nova consulta agora", appoint.patientUID)
									//print("chave da consulta", appointments)
									self.allAppointments.updateValue(appoint, forKey: infoAddedOfAppointment.keys.first!)
									
									// notificacao para nova consulta
									let appointmentUid = infoAddedOfAppointment.keys.first
									let clinicUID = infoAddedOfAppointment.values.first
									let clinicName = self.clinicManager.clinics[clinicUID!]?.name!
									let day = self.allAppointments[appointmentUid!]?.scheduleTime.day!
									let month = self.allAppointments[appointmentUid!]?.scheduleTime.month!
									let year = self.allAppointments[appointmentUid!]?.scheduleTime.year!
									self.notification(title: "Você tem uma nova consulta marcada", body: "Clínica: \(clinicName!) - Horário: \(day!)/\(month!)/\(year!) ", subtitle: "", id: "showNotification2")
								}
								
								completion(result)
							}
						}
						else {
							completion(result)
						}
						
					}
				}
			}
			else {
				completion(result)
			}
			
		}
	}
    
    public func sendAppointmentRequest(info: [String : Any], _ completion: @escaping ((_ result: String) -> Void)) {
        self.personDAO.sendRequest(info, { (result) in
            if result == success {
                completion(result)
            }
        })
    }
	
	public func setAllObserversForTodayAppointments(_ completion: @escaping ((_ result: String) -> Void)) {
		for keyAndAppointment in self.todayAppointmentsDic(){
			self.setObserverTodayAppointment(tableNameOfClinic: "appointment_prevmama", keyOfAppointment: keyAndAppointment.key)  { (result) in
				if result == success && keyAndAppointment.key == self.allAppointments.reversed().first?.key {
					completion(success)
				}
				else {
					completion(result)
				}
			}
		}
	}
	
	//MARK:- Separate Appointments Functions
	public func pastAppointments() -> [Appointment] {
		var pastAppointments = [Appointment]()
		
		for (_, appointment) in allAppointments {
			if appointment.scheduleTime.compareDate(with: CustomDate()) == .bigger {
				pastAppointments.append(appointment)
			}
		}
		
		return pastAppointments
	}
	
	public func todayAppointments() -> [Appointment] {
		var todayAppointments = [Appointment]()
		
		for (_, appointment) in allAppointments {
			if appointment.scheduleTime.compareDate(with: CustomDate()) == .equal {
				todayAppointments.append(appointment)
			}
		}
		
		return todayAppointments
	}
	
	private func todayAppointmentsDic() -> [String : Appointment] {
		var todayAppointments = [String : Appointment]()
		
		for (key, appointment) in allAppointments {
			if appointment.scheduleTime.compareDate(with: CustomDate()) == .equal {
				todayAppointments.updateValue(appointment, forKey: key)
			}
		}
		
		return todayAppointments
	}
	
	public func futureAppointments() -> [Appointment] {
		var futureAppointments = [Appointment]()
		
		for (_, appointment) in allAppointments {
			if appointment.scheduleTime.compareDate(with: CustomDate()) == .smaller {
				futureAppointments.append(appointment)
			}
		}
		
		return futureAppointments
	}
	
	public func sort(_ array: [Appointment]) -> [Appointment] {
		var appointments = [Appointment] ()
		appointments = array.sorted(by: { (first, second) -> Bool in
			if first.scheduleTime.compareDate(with: second.scheduleTime) == .equal {
				return first.scheduleTime.compareTime(with: second.scheduleTime) == .bigger
			}
			else {
				return first.scheduleTime.compareDate(with: second.scheduleTime) == .bigger
			}
		})
		
		return appointments
	}
	
	public func sortByHour(_ array: [Appointment]) -> [Appointment] {
		var appointments = [Appointment] ()
		appointments = array.sorted(by: { (first, second) -> Bool in
			return first.scheduleTime.compareTime(with: second.scheduleTime) == .bigger
		})
		
		return appointments
	}
	
	//MARK:- Notification
	func notification(title: String, body: String, subtitle: String, id: String) {
		
		let notification = UNMutableNotificationContent()
		notification.title = title
		notification.subtitle = subtitle
		notification.body = body
		
		let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		let request = UNNotificationRequest(identifier: id, content: notification, trigger: notificationTrigger)
		
		UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
	}
}
