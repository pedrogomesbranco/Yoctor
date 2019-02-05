//
//  Cell.swift
//  DayApp
//
//  Created by Pedro G. Branco on 3/28/16.
//  Copyright © 2016 Pedro G. Branco. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet var check: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cash: UILabel!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
}
