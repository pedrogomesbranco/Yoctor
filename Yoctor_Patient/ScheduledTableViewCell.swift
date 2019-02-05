//
//  ScheduledTableViewCell.swift
//  Yoctor_Patient
//
//  Created by Ana Luiza Ferrer on 11/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation
import UIKit

class ScheduledTableViewCell: UITableViewCell {
    
    @IBOutlet var doctorPhoto: UIImageView!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        doctorPhoto.layer.borderWidth = 1
        doctorPhoto.layer.borderColor = UIColor.clear.cgColor
        doctorPhoto.layer.masksToBounds = false
        doctorPhoto.contentMode = UIViewContentMode.scaleAspectFill
        doctorPhoto.layer.cornerRadius = doctorPhoto.layer.frame.height/2
        doctorPhoto.clipsToBounds = true

		specializationLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
