//
//  LoginPresenter.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 10/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class LoginPresenter: UIViewController , UITextFieldDelegate{
    
    private var loginManager: Login!
    private var agendaAppointmentManager: AgendaAppointment!
    private var doctorManager: DoctorManager!
    private var clinicManager: ClinicManager!
    private var alert: UIAlertController!
    private var activityIndicatorView: UIView?
    private var logger = true
    
    
    @IBOutlet var logoLabel: UILabel!
    @IBOutlet var alertBox: UIImageView!
    @IBOutlet var alertText: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
	
	override func viewDidAppear(_ animated: Bool) {
		// Keep user logged in
		activityIndicatorView = ActivityIndicator().startActivityIndicator(obj: self)
		
		loginManager.verifyLoggedUser { (result) in
			if result == success {
				self.agendaAppointmentManager.getAppointments() { (result) in
					if result == success {
						self.doctorManager.getDoctors() { (result) in
							if result == success {
                                self.clinicManager.getClinics() { (result) in
                                    if result == success {
                                        
                                        //stop activity indicator
                                        ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                                        
                                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                    }
                                }
							}
						}
					}
					else { // a user can have none appointments yet
						if self.activityIndicatorView != nil {
							ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
						}
						self.performSegue(withIdentifier: "loginSegue", sender: nil)
					}
				}
			}
			else {
					ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		emailTextField.text = nil
		passwordTextField.text = nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loginManager = Login.sharedInstance
		agendaAppointmentManager = AgendaAppointment.sharedInstance
		doctorManager = DoctorManager.sharedInstance
        clinicManager = ClinicManager.sharedInstance
        
		loginButton.layer.cornerRadius = 8
		
		self.emailTextField.delegate = self
		self.passwordTextField.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
	}
	
    @IBAction func loginAction(_ sender: Any) {
        self.login()
        self.view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let textFieldAlert = UIAlertController(title: "Informe seu e-mail", message: "Digite seu e-mail cadastrado no Yoctor.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Aceitar", style: .default, handler: { (action: UIAlertAction) -> Void in
            let textField = textFieldAlert.textFields![0] as UITextField
            
            self.loginManager.changePasswordOf(email: textField.text!, { (result) in
                if result == success {
                    self.alert = UIAlertController(title: "E-mail enviado com sucesso", message: "Consulte sua caixa de entrada do e-mail fornecido para realizar a troca de senha.", preferredStyle: .alert)
                }
                else {
                    self.alert = UIAlertController(title: "Erro no envio do e-mail", message: result, preferredStyle: .alert)
                }
                
                self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                if let presented = self.presentedViewController {
                    presented.present(self.alert, animated: true, completion: nil)
                }
                else {
                    self.present(self.alert, animated: true, completion: nil)
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        textFieldAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "e-mail"
        }
        
        textFieldAlert.addAction(confirmAction)
        textFieldAlert.addAction(cancelAction)
        
        self.present(textFieldAlert, animated: true, completion: nil)
    }
	
	//MARK:- TextField Delegate
    func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= self.passwordTextField.frame.size.height*3.5
                self.logoLabel.font = UIFont(name: "Dosis-Medium", size: 80)
                self.logoLabel.frame.origin.y += self.passwordTextField.frame.size.height
                self.logoLabel.textAlignment = .center
                self.alertBox.isHidden = true
                self.alertText.isHidden = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
                self.logoLabel.frame.origin.y -= self.passwordTextField.frame.size.height
                self.logoLabel.font = UIFont(name: "Dosis-Medium", size: 120)
                self.alertBox.isHidden = true
                self.alertText.isHidden = true
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alertBox.isHidden = true
        self.alertText.isHidden = true
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            self.login()
        }
        return true
    }
    
    func login() {
        let email = emailTextField.text
        let password = passwordTextField.text
        

		if email != "" && password != "" {
            self.view.frame.origin.y = 0
            self.logoLabel.frame.origin.y -= self.passwordTextField.frame.size.height*2
            self.logoLabel.font = UIFont(name: "Dosis-Medium", size: 120)
            self.alertBox.isHidden = true
            self.alertText.isHidden = true
            
            self.activityIndicatorView = ActivityIndicator().startActivityIndicator(obj: self)
            loginManager.verifyLogin(email: email!, password: password!) { (result) in
                if result == success {
                    self.agendaAppointmentManager.getAppointments() { (result) in
                        if result == success {
                            self.doctorManager.getDoctors() { (result) in
                                if result == success {
                                    //stop activity indicator
                                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)

                                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                }
                            }
                        }
						else { // a user can have none appointments yet
							if self.activityIndicatorView != nil {
								ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
							}
							self.performSegue(withIdentifier: "loginSegue", sender: nil)
						}
                    }
                }
                else {
                    if self.activityIndicatorView != nil {
                        ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                    }
                    self.alertBox.isHidden = false
                    self.alertText.isHidden = false
                }
            }
        }
        else {
            if self.activityIndicatorView != nil {
                ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
            }
            self.alertBox.isHidden = false
            self.alertText.isHidden = false
        }
    }
}
