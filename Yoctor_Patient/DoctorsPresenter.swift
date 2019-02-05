//
//  DoctorViewController.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class DoctorsPresenter: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	private var allDoctors: [Doctor]!

	@IBOutlet weak var doctorsCollection: UICollectionView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		allDoctors = []
		for (_, doctor) in DoctorManager.sharedInstance.doctors {
			allDoctors.append(doctor)
		}
		
		doctorsCollection.delegate = self
		doctorsCollection.dataSource = self
		
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSFontAttributeName: UIFont(name: "Dosis", size: 40)!,
                NSForegroundColorAttributeName: UIColor(red: 68/255, green: 190/255, blue: 141/255, alpha: 1)
            ]
        }
    }
	
	//MARK:- DoctorsCollection Delegate
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	//MARK: DoctorsCollection DataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return allDoctors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorCollectionCell", for: indexPath) as! DoctorCollectionCell
		let doc = allDoctors[indexPath.row]
		
		cell.nameLabel.text = doc.name
		cell.specialtyLabel.text = doc.specialty
		cell.photoView.image = doc.photo
		
		return cell
	}

}
