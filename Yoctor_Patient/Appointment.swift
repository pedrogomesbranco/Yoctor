//
//  Appointment.swift
//  Yoctor
//
//  Created by Lucas Ferraço on 14/05/17.
//  Copyright © 2017 YoctorTeam. All rights reserved.
//

import Foundation

public enum Status: String {
	case confirmed = "confirmed",
	notConfirmed = "notConfirmed",
	inAppointment = "inAppointment",
	done = "done"
}

public class Appointment {
	
	public var patientUID: String!
	public var doctorUID: String!
	public var scheduleTime: CustomDate!
	public var predictionTime: CustomDate!
	public var status: Status!
	
	init(patientUID: String, doctorUID: String, scheduleTime: CustomDate) {
		self.patientUID = patientUID
		self.doctorUID = doctorUID
		self.scheduleTime = scheduleTime
		self.predictionTime = scheduleTime
		self.status = .notConfirmed
	}
	
	init?(json: [String:Any]) {
		if let jsonPatUID = json["patient_uid"] as? String { self.patientUID = jsonPatUID }
		if let jsonDocUID = json["doctor_uid"] as? String { self.doctorUID = jsonDocUID }
		
		let jsonDate = json["schedule_date"] as? String
		let jsonHour = json["schedule_time"] as? String
		let jsonPredictionTime = json["prediction_time"] as? String
		
		if (jsonDate != nil && jsonHour != nil) {
			let date = CustomDate(fromDescription: jsonDate!, jsonHour!)
			self.scheduleTime = date
		}
		
		if (jsonDate != nil && jsonPredictionTime != nil) {
			let predictionDate = CustomDate(fromDescription: jsonDate!, jsonPredictionTime!)
			self.predictionTime = predictionDate
		}
		
		if let jsonStatus = json["status"] as? String { self.status = Status(rawValue: jsonStatus) }
		
	}
	
	public func makeJSON() -> [String:Any] {
		var jsonObject = [String:Any]()
		
		if let validPatUID = self.patientUID { _ = jsonObject.updateValue(validPatUID, forKey: "patient_uid") }
		
		if let validDocUID = self.doctorUID { _ = jsonObject.updateValue(validDocUID, forKey: "doctor_uid") }
		
		if let validScheduleTime = self.scheduleTime {
			_ = jsonObject.updateValue(validScheduleTime.dateDescription(), forKey: "schedule_date")
			_ = jsonObject.updateValue(validScheduleTime.timeDescription(), forKey: "schedule_time")
		}
		
		if let validPredictionTime = self.predictionTime {
			_ = jsonObject.updateValue(validPredictionTime.timeDescription(), forKey: "prediction_time")
		}
		
		if let validStatus = self.status {
			_ = jsonObject.updateValue(validStatus.rawValue, forKey: "status")
		}
		
		if JSONSerialization.isValidJSONObject(jsonObject) {
			return jsonObject
		}
		
		return [:]
	}
	
	public func updateInfo(to newInfo: [String:Any]) {
		for (key, value) in newInfo {
			let stringValue = value as! String
			
			switch key {
			case "doctor_uid":
				doctorUID = stringValue
				
			case "schedule_date":
				let dateElements = stringValue.components(separatedBy: "-")
				
				scheduleTime.day = Int(dateElements[0])
				scheduleTime.month = Int(dateElements[1])
				scheduleTime.year = Int(dateElements[2])
				predictionTime = scheduleTime
				
			case "schedule_time":
				let timeElements = stringValue.components(separatedBy: "-")
				
				scheduleTime.hour = Int(timeElements[0])
				scheduleTime.minute = Int(timeElements[1])
				predictionTime = scheduleTime
				
			case "prediction_time":
				let timeElements = stringValue.components(separatedBy: "-")
				
				predictionTime.hour = Int(timeElements[0])
				predictionTime.minute = Int(timeElements[1])
				
			case "status":
				status = Status(rawValue: stringValue)
				
			default:
				break
			}
		}
	}
	
}

extension Appointment: Equatable {
	public static func == (appointment1: Appointment, appointment2: Appointment) -> Bool {
		return appointment1.scheduleTime == appointment2.scheduleTime
	}
}


