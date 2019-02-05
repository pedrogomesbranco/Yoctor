//
//  CustomDate.swift
//  Yoctor_Clinic
//
//  Created by Lucas Ferraço on 07/09/17.
//  Copyright © 2017 Lucas Ferraço. All rights reserved.
//

import Foundation

public enum CompareResults: Int {
	case smaller = -1,
	equal = 0,
	bigger = 1
}

public let weekdaysDescription = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]

public class CustomDate {
	//MARK:- Attributes
	public var day: Int!
	public var month: Int!
	public var year: Int!
	public var hour: Int!
	public var minute: Int!
	
	private var formatter: DateFormatter!
	
	//MARK:- init's
	public init() {
		initFormatter()
		
		let now = Date()
		day = Calendar.current.component(.day, from: now)
		month = Calendar.current.component(.month, from: now)
		year = Calendar.current.component(.year, from: now)
		hour = Calendar.current.component(.hour, from: now)
		minute = Calendar.current.component(.minute, from: now)
	}
	
	public init(fromNative date: Date) {
		initFormatter()
		
		day = Calendar.current.component(.day, from: date)
		month = Calendar.current.component(.month, from: date)
		year = Calendar.current.component(.year, from: date)
		hour = Calendar.current.component(.hour, from: date)
		minute = Calendar.current.component(.minute, from: date)
	}
	
	public init(fromDescription day: String, _ time: String) {
		initFormatter()
		
		// Date Format: dd-MM-YYYY
		var dateComponents = DateComponents()
		if day != "" {
			let dayElements = day.components(separatedBy: "-")
			dateComponents.day = Int(dayElements[0])
			dateComponents.month = Int(dayElements[1])
			dateComponents.year = Int(dayElements[2])
		}
		
		// Time Format: HH-mm
		if time != "" {
			let timeElements = time.components(separatedBy: "-")
			dateComponents.hour = Int(timeElements[0])
			dateComponents.minute = Int(timeElements[1])
		}
		
		let date = Calendar.current.date(from: dateComponents)!
		if day != "" {
			self.day = Calendar.current.component(.day, from: date)
			month = Calendar.current.component(.month, from: date)
			year = Calendar.current.component(.year, from: date)
		}
		if time != "" {
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
		}
	}
	
	private func initFormatter() {
		formatter = DateFormatter()
	}
	
	//MARK:- Description
	public func dateDescription() -> String {
		formatter.dateFormat = "dd-MM-YYYY"
		
		return formatter.string(from: nativeRepresentation())
	}
	
	public func timeDescription() -> String {
		formatter.dateFormat = "HH-mm"
		
		return formatter.string(from: nativeRepresentation())
	}
	
	public func monthDescription() -> String {
		formatter.dateFormat = "MMMM yyyy"
		
		return formatter.string(from: nativeRepresentation()).localizedCapitalized
	}
	
	public func scheduleDescription() -> String {
		formatter.dateFormat = "dd/MM"
		
		let dayString = formatter.string(from: nativeRepresentation())
		
		return dayString + " às " + timeDescription().replacingOccurrences(of: "-", with: "h")
	}
	
	public func extendedDesc() -> String {
		var extendedString = String()
		let date = nativeRepresentation()
		
		formatter.dateFormat = "dd"
		extendedString += formatter.string(from: date) + " de "
		formatter.dateFormat = "MMMM"
		extendedString += formatter.string(from: date).localizedCapitalized + ", "
		formatter.dateFormat = "yyyy"
		extendedString += formatter.string(from: date)
		
		return extendedString
	}
	
	public func nativeRepresentation() -> Date {
		var dateComponents = DateComponents()
		dateComponents.day = day
		dateComponents.month = month
		dateComponents.year = year
		dateComponents.hour = hour
		dateComponents.minute = minute
		
		return Calendar.current.date(from: dateComponents)!
	}
	
	/// Calculate a new CustomDate with the hour shifted by fractionOfTime
	///
	/// - Parameter fractionOfTime: quantity of time to shift, in minutes
	/// - Returns: CustomDate with the hour shifted by fractionOfTime
	public func shifted(of fractionOfTime: Int) -> CustomDate {
		var shiftedDate = nativeRepresentation()
		shiftedDate.addTimeInterval(Double(fractionOfTime) * 60)
		
		return CustomDate(fromNative: shiftedDate)
	}
	
	//MARK:- Comparison
	
	/// Compare the instance's date with another CustomDate's date
	///
	/// - Parameter date: CustomDate to be compared with
	/// - Returns:
	///     - .smaller: date comes before instance;
	///     - .equal: date is the same as instance;
	///     - .bigger: date comes after instance.
	func compareDate(with date: CustomDate) -> CompareResults {
		if  date.year > self.year {
			return .bigger
		}
		else if date.year! < self.year! {
			return .smaller
		}
		else {
			if date.month! > self.month!{
				return .bigger
			}
			else if date.month! < self.month! {
				return .smaller
			}
			else {
				if date.day! > self.day!{
					return .bigger
				}
				else if date.day! < self.day! {
					return .smaller
				}
			}
		}
		
		return .equal
	}
	
	/// Compare the instance's time with another CustomDate's time
	///
	/// - Parameter time: CustomDate to be compared with
	/// - Returns:
	///     - .smaller: time comes before instance;
	///     - .equal: time is the same as instance;
	///     - .bigger: time comes after instance. 
	func compareTime(with time: CustomDate) -> CompareResults {
		if time.hour > self.hour {
			return .bigger
		}
		else if time.hour < self.hour {
			return .smaller
		}
		else {
			if time.minute > self.minute {
				return .bigger
			}
			else if time.minute < self.minute {
				return .smaller
			}
		}
		
		return .equal
	}
	
	/// Get the time difference between CustomDates
	///
	/// - Parameter comparedDate: CustomDate to be compared
	/// - Returns: absolute number of minutes passed from self to comparedDate
	func timePassed(from comparedDate: CustomDate) -> Int {
		let hoursPassed = abs(hour - comparedDate.hour)
		let minPassed = abs(minute - comparedDate.minute)
		
		return hoursPassed * 60 + minPassed
	}
}

extension CustomDate: Equatable {
	public static func == (date1: CustomDate, date2: CustomDate) -> Bool {
		if date1.compareDate(with: date2) == .equal && date1.compareTime(with: date2) == .equal {
			return true
		}
		
		return false
	}
}
