//
//  DoctorCell.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 14/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class DoctorCollectionCell: UICollectionViewCell {
	
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var specialtyLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		photoView.layer.cornerRadius = photoView.frame.size.width/2
		photoView.clipsToBounds = true
		photoView.contentMode = .scaleAspectFill
		
		if nameLabel != nil {
			nameLabel.adjustsFontSizeToFitWidth = true
		}
		
		specialtyLabel.adjustsFontSizeToFitWidth = true
	}
	
}
