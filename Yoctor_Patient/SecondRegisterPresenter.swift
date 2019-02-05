//
//  2ndRegisterPresenter.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class SecondRegisterPresenter: UIViewController, UITextFieldDelegate {
	
	private var loginManager: Login!
	public var userPhoto: UIImage!
    private var activityIndicatorView: UIView!

    @IBOutlet var questionButton: UIButton!
    @IBOutlet var alertText: UILabel!
	@IBOutlet weak var saluteLabel: UILabel!
	@IBOutlet weak var cpfTextField: UITextField!
	@IBOutlet weak var rgTextField: UITextField!
	@IBOutlet weak var ufTextField: UITextField!
	@IBOutlet weak var healthInsuranceTextField: UITextField!
	@IBOutlet weak var hiNumberTextField: UITextField!
    @IBOutlet var hiDayExpTextField: UITextField!
	@IBOutlet weak var hiMonthExpTextField: UITextField!
	@IBOutlet weak var hiYearExpTextField: UITextField!
	@IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager = Login.sharedInstance
        
        let name = loginManager.user!.firstName()
        saluteLabel.text = "Olá \((name.components(separatedBy: " ").first)!), só precisamos de mais alguns dados!"
        
        self.cpfTextField.delegate = self
        self.rgTextField.delegate = self
        self.ufTextField.delegate = self
        self.healthInsuranceTextField.delegate = self
        self.hiNumberTextField.delegate = self
        self.hiDayExpTextField.delegate = self
        self.hiMonthExpTextField.delegate = self
        self.hiYearExpTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        registerButton.layer.cornerRadius = 8
    }
	
	@IBAction func explanationAction(_ sender: Any) {
		
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
	@IBAction func registerAction(_ sender: Any) {
        
		let cpf = cpfTextField.text!
		let rg = rgTextField.text!
		let uf = ufTextField.text!
		let hi = healthInsuranceTextField.text!
		let hiNumber = hiNumberTextField.text!
		let hiDay = hiDayExpTextField.text!
		let hiMonth = hiMonthExpTextField.text!
		let hiYear = hiYearExpTextField.text!
		
		if Int(cpf) != nil {
			if Int(rg) != nil {
				if uf != "" {
					if hi != "" {
						if Int(hiNumber) != nil {
							if Int(hiDay) != nil && Int(hiMonth) != nil && Int(hiYear) != nil {
                                //start activity indicator
                                self.view.frame.origin.y = 0
                                activityIndicatorView = ActivityIndicator().startActivityIndicator(obj: self)
								let userInfo = [
									"cpf": Int(cpf)!,
									"rg": Int(rg)!,
									"uf": uf,
									"health_insurance": hi,
									"insurance_number": Int(hiNumber)!,
									"insurance_expiration": "\(hiDay)-\(hiMonth)-\(hiYear)"
									] as [String : Any]
								
								loginManager.updateUserInfo(info: userInfo, { (result) in
									if result == success {
										if let userPicture = self.userPhoto {
											self.loginManager.updateUserPicture(to: userPicture, { (result) in
												if result == success {
                                                    
                                                    //stop activity indicator
                                                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
													self.performSegue(withIdentifier: "finishRegisterSegue", sender: nil)
												}
											})
										}
										else {
                                            
                                            //stop activity indicator
                                            ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
											self.performSegue(withIdentifier: "finishRegisterSegue", sender: nil)
										}
									}
								})
							}
							else {
                                if self.activityIndicatorView != nil {
                                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                                }
								alertText.text = "Insira uma data de validade válida."
								alertText.isHidden = false
								questionButton.isHidden = true
							}
						}
						else {
                            if self.activityIndicatorView != nil {
                                ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                            }
							alertText.text = "Insira um número de plano de saúde válido."
							alertText.isHidden = false
							questionButton.isHidden = true
						}
					}
					else {
                        if self.activityIndicatorView != nil {
                            ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                        }
						alertText.text = "Insira um plano de saúde válido."
						alertText.isHidden = false
						questionButton.isHidden = true
					}
				}
				else {
                    if self.activityIndicatorView != nil {
                        ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                    }
					alertText.text = "Insira um UF válido."
					alertText.isHidden = false
					questionButton.isHidden = true
				}
			}
			else {
                if self.activityIndicatorView != nil {
                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                }
				alertText.text = "Insira um RG válido."
				alertText.isHidden = false
				questionButton.isHidden = true
			}
		}
		else {
            if self.activityIndicatorView != nil {
                ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
            }
			alertText.text = "Insira um CPF válido."
			alertText.isHidden = false
			questionButton.isHidden = true
		}
	}
	
	//MARK:- Keyboard & TextField Delegates
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		alertText.isHidden = true
		questionButton.isHidden = false
        self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.cpfTextField {
			self.rgTextField.becomeFirstResponder()
		} else if textField == self.rgTextField {
			self.ufTextField.becomeFirstResponder()
		} else if textField == self.ufTextField {
			self.healthInsuranceTextField.becomeFirstResponder()
		} else if textField == self.healthInsuranceTextField {
			self.hiNumberTextField.becomeFirstResponder()
		} else if textField == self.hiNumberTextField {
			self.hiDayExpTextField.becomeFirstResponder()
		} else if textField == self.hiDayExpTextField {
			self.hiMonthExpTextField.becomeFirstResponder()
		} else if textField == self.hiMonthExpTextField {
			self.hiYearExpTextField.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
			registerAction(textField)
		}
		
		return true
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= self.healthInsuranceTextField.frame.size.height*2
				self.saluteLabel.frame.origin.y += self.healthInsuranceTextField.frame.size.height
				self.saluteLabel.font = UIFont(name: "Dosis-Medium", size: 22)
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y = 0
				self.saluteLabel.frame.origin.y -= self.healthInsuranceTextField.frame.size.height
				self.saluteLabel.font = UIFont(name: "Dosis-Medium", size: 25)
			}
		}
	}
	
}
