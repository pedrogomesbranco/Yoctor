//
//  ActivityIndicator.swift
//  Yoctor_Patient
//
//  Created by Wellington Bezerra on 24/08/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import Foundation
import UIKit

public class ActivityIndicator: NSObject {
    
    var actInd:UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    public var container: UIView = UIView()
    
    func startActivityIndicator(obj:UIViewController) -> UIView {
        
        self.showActivityIndicatory(uiView: obj)
        return self.container
    }
    
    func showActivityIndicatory(uiView: UIViewController) {
        
        container.frame = uiView.view.frame
        if uiView is EditPatientViewController{
            container.center.x = uiView.view.center.x
            container.center.y = uiView.view.center.y - 132
        }
        else{
            container.center = uiView.view.center
        }
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.5)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.view.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.view.addSubview(container)
        actInd.startAnimating()
    }
    
    func stopActivityIndicator(obj:UIViewController,indicator:UIView) {
        indicator.removeFromSuperview()
        
    }
    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
