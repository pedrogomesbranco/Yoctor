//
//  RequestManager.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 23/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class RequestManager {
	private let appointmentsDAO: DAO_Appointment!
	private let doctorManager: DoctorManager!
	
	//MARK: Singleton Definition
	private static var theOnlyInstance: RequestManager?
	static var sharedInstance: RequestManager {
		get {
			if theOnlyInstance == nil {
				theOnlyInstance = RequestManager()
			}
			return theOnlyInstance!
		}
	}
	private init() {
		appointmentsDAO = DAO_Appointment.sharedInstance
		doctorManager = DoctorManager.sharedInstance
	}
	
	public func sendRequest(with doctor: Doctor, on weekdayWithinTimeIntervalChoices: [[Bool]], _ completion: @escaping ((_ result: String) -> Void)) {
		let doctorUID = doctorManager.getUIDfrom(doctor)
		let doctorWeekdays = doctor.workingDays!
		let doctorTimeIntervals = doctor.getServiceIntervals()
		var requestInfo = [String : String]()
		
		for weekdayIndex in 0...weekdayWithinTimeIntervalChoices.count - 1 {
			for timeIntervalIndex in 0...weekdayWithinTimeIntervalChoices[weekdayIndex].count - 1 {
				if weekdayWithinTimeIntervalChoices[weekdayIndex][timeIntervalIndex] {
					var requestString = String(doctorWeekdays[weekdayIndex]) + "_"
					requestString += doctorTimeIntervals[timeIntervalIndex].timeDescription() + "_"
					
					if timeIntervalIndex == 2 {
						requestString += doctor.workingTimeInterval[1].timeDescription()
					}
					else {
						requestString += doctorTimeIntervals[timeIntervalIndex + 1].timeDescription()
					}
					
					requestInfo.updateValue(doctorUID, forKey: requestString)
				}
			}
		}
		
		print("\n", #function, requestInfo, "\n")
		if !requestInfo.isEmpty {
			appointmentsDAO.saveNewAppointmentRequest(requestInfo, completion)
		}
		else {
			completion("Nenhum horário selecionado.")
		}
	}
}
