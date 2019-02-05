//
//  ButtonsTableViewCell.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var docButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var senhaButton: UIButton!
    @IBOutlet weak var senhaImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var docLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var senhaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
