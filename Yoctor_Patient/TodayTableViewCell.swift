//
//  TodayTableViewCell.swift
//  Yoctor_Patient
//
//  Created by Ana Luiza Ferrer on 11/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation
import UIKit

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet var doctorPhoto: UIImageView!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var predictionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancelButton.layer.masksToBounds = false
        cancelButton.layer.cornerRadius = 3
        cancelButton.clipsToBounds = true
        
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 3
        confirmButton.clipsToBounds = true
        
        predictionLabel.text = "Confirmada"
        
        doctorPhoto.layer.borderWidth = 1
        doctorPhoto.layer.masksToBounds = false
        doctorPhoto.layer.borderColor = UIColor.clear.cgColor
        doctorPhoto.layer.cornerRadius = doctorPhoto.layer.frame.height/2
        doctorPhoto.clipsToBounds = true
        doctorPhoto.contentMode = UIViewContentMode.scaleAspectFill

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        //Change appointment status to Status.confirmed
        
    }
}
