//
//  NavigationController.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		UINavigationBar.appearance().titleTextAttributes = [
			NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 30)!,
			NSForegroundColorAttributeName: UIColor(red: 68/255, green: 190/255, blue: 141/255, alpha: 1)
		]
        
        UINavigationBar.appearance().tintColor = UIColor.black
        
		navigationBar.backgroundColor = UIColor.white
		navigationBar.setTitleVerticalPositionAdjustment(CGFloat(5), for: .default)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 50)!,
                NSForegroundColorAttributeName: UIColor(red: 68/255, green: 190/255, blue: 141/255, alpha: 1)
            ]
        }
	}
}
