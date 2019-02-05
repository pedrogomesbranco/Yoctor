//
//  EditTableViewCell.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
	
	public var infoDescription: String! = nil

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var editTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
		
		editTextField.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
