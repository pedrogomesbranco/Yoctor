//
//  Request.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 14/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation

class AppointmentRequest {
	
	/// Doctor's uid
	private var doctor: Doctor!
	private var weekday: String!
	private var timeInterval: [CustomDate]!
	
	init(doctor: Doctor, weekday: String, timeInterval: [CustomDate]) {
		self.doctor = doctor
		self.weekday = weekday
		self.timeInterval = timeInterval
	}
}
