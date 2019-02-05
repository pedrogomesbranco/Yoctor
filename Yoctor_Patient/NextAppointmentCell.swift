//
//  NextAppointmentCell.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 18/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class NextAppointmentCell: UITableViewCell {
	
	public var selectedHandler: ((_ selected: Bool) -> Void)!

	@IBOutlet weak var nextAvailabelBtn: UIButton!

	@IBAction func nextAvlBtnAction(_ sender: Any) {
		nextAvailabelBtn.isSelected = !nextAvailabelBtn.isSelected
		selectedHandler(nextAvailabelBtn.isSelected)
	}

}
