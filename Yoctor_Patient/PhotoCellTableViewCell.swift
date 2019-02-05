//
//  PhotoCellTableViewCell.swift
//  Yoctor_Patient
//
//  Created by Pedro Gomes Branco on 15/08/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class PhotoCellTableViewCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		photo.layer.cornerRadius = photo.frame.size.width/2
		photo.clipsToBounds = true
		photo.contentMode = .scaleAspectFill
    }
}
