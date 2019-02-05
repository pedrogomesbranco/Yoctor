//
//  TimeIntervalCell.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 19/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class TimeIntervalCell: UITableViewCell {
	

	@IBOutlet weak var weekdayLabel: UILabel!
	@IBOutlet weak var firstIntervalButton: UIButton!
	@IBOutlet weak var secondIntervalButton: UIButton!
	@IBOutlet weak var thirdIntervalButton: UIButton!

	override func awakeFromNib() {
		super.awakeFromNib()
		
		firstIntervalButton.titleLabel?.adjustsFontSizeToFitWidth = true
		secondIntervalButton.titleLabel?.adjustsFontSizeToFitWidth = true
		thirdIntervalButton.titleLabel?.adjustsFontSizeToFitWidth = true
	}
	
	@IBAction func setIntervalSelected(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
	}
	
	func setDisabled() {
		firstIntervalButton.isSelected = false
		secondIntervalButton.isSelected = false
		thirdIntervalButton.isSelected = false
		isUserInteractionEnabled = false
	}
	
	func setEnabled() {
		isUserInteractionEnabled = true
	}
}
