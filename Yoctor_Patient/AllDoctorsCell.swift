//
//  DoctorsCollectionCell.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 18/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class AllDoctorsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
	
	public var dataSource: [Doctor]!
	public var changeSelectedDoc: ((_ selectedDoc: Doctor) -> Void)!
	private var lastSelectedIndex: Int!
	
	@IBOutlet weak var doctorsCollection: UICollectionView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		lastSelectedIndex = -1
		
		doctorsCollection.delegate = self
		doctorsCollection.dataSource = self
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorCollectionCell", for: indexPath) as! DoctorCollectionCell
		let doc = dataSource[indexPath.row]
		
		cell.nameLabel.text = doc.name
		cell.specialtyLabel.text = doc.specialty
		cell.photoView.image = doc.photo
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if lastSelectedIndex != indexPath.row {
			changeSelectedDoc(dataSource[indexPath.row])
		}
		
		lastSelectedIndex = indexPath.row
	}

}
