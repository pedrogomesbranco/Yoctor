//
//  RegisterPresenter.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 10/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class RegisterPresenter: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	private var loginManager: Login!
    private var activityIndicatorView: UIView!
    private var photoPosition: CGPoint!
    private var cancellButtonPosition: CGPoint!
    private var photoSize: CGSize!
	
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
	@IBOutlet var alertPassword: UIImageView!
	@IBOutlet var alertEmail: UIImageView!
	@IBOutlet var alertPhone: UIImageView!
	@IBOutlet var alertName: UIImageView!
	@IBOutlet var alertText: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var phoneTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var passwordConfirmationTextField: UITextField!
	@IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager = Login.sharedInstance
        
        self.nameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmationTextField.delegate = self

        self.photoSize = profileImageView.image?.size
        self.photoPosition = profileImageView.frame.origin
        self.cancellButtonPosition = cancelButton.frame.origin
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        registerButton.layer.cornerRadius = 8
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
	@IBAction func selectPictureAction(_ sender: Any) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.sourceType = .photoLibrary
        
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func backAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func registerAction(_ sender: Any) {
        
		let name = nameTextField.text!
		let password = passwordTextField.text!
		let email = emailTextField.text!
		let phone = phoneTextField.text!
		
		if name != "" {
			if Int(phone) != nil {
				if email != "" {
					if password != "" && password == passwordConfirmationTextField.text {
						let userInfo = [
							"name": name,
							"email": email,
							"phone": Int(phone)!
							] as [String : Any]
                        
                        //start activity indicator
                        self.view.frame.origin.y = 0
                        activityIndicatorView = ActivityIndicator().startActivityIndicator(obj: self)
                        
						loginManager.registerUser(info: userInfo, password: password, { (result) in
							if result == success {
								if self.profileImageView.image != #imageLiteral(resourceName: "foto") {
									self.loginManager.updateUserPicture(to: self.profileImageView.image!, { (result) in
										if result == success {
                                            
                                            //stop activity indicator
                                            ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
											self.performSegue(withIdentifier: "registerSegue", sender: nil)
										}
									})
								}
								else {
                                    
                                    //stop activity indicator
                                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
									self.performSegue(withIdentifier: "registerSegue", sender: nil)
								}
							}
							else {
                                if self.activityIndicatorView != nil {
                                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                                }
								self.alertText.text = result
								self.alertText.isHidden = false
							}
							
						})
					}
						
					else {
                        if self.activityIndicatorView != nil {
                            ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                        }
						alertText.text = "Insira uma senha válida."
						alertText.isHidden = false
						alertPassword.isHidden = false
					}
				}
				else {
                    if self.activityIndicatorView != nil {
                        ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                    }
					alertText.text = "Insira um e-mail válido."
					alertText.isHidden = false
					alertEmail.isHidden = false
				}
			}
			else {
                if self.activityIndicatorView != nil {
                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
                }
				alertText.text = "Insira um telefone válido."
				alertText.isHidden = false
				alertPhone.isHidden = false
			}
		}
		else {
            if self.activityIndicatorView != nil {
                ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView!)
            }
			alertText.text = "Insira um nome válido."
			alertText.isHidden = false
			alertName.isHidden = false
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		alertText.isHidden = true
		alertName.isHidden = true
		alertPhone.isHidden = true
		alertEmail.isHidden = true
		alertPassword.isHidden = true
        
        self.view.endEditing(true)
	}
	
	//MARK:- Keyboard & TextField Delegates
	func keyboardWillShow(notification: NSNotification) {
		if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= self.nameTextField.frame.size.height*3.3
				self.profileImageView.frame.size = CGSize(width: self.profileImageView.frame.size.width/2, height: self.profileImageView.frame.size.height/2)
				self.profileImageView.frame.origin.y = self.nameTextField.frame.origin.y - self.passwordTextField.frame.size.height*2.75
				self.profileImageView.frame.origin.x = self.view.frame.midX - self.profileImageView.frame.width/2
				self.addPhotoButton.isHidden = true
				self.cancelButton.isHidden = true
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y = 0
				self.profileImageView.frame.size = CGSize(width: self.profileImageView.frame.size.width*2, height: self.profileImageView.frame.size.height*2)
				self.profileImageView.frame.origin = self.photoPosition
				self.cancelButton.frame.origin = self.cancellButtonPosition
				self.addPhotoButton.isHidden = false
				self.cancelButton.isHidden = false
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.nameTextField {
			self.phoneTextField.becomeFirstResponder()
		} else if textField == self.phoneTextField {
			self.emailTextField.becomeFirstResponder()
		} else if textField == self.emailTextField {
			self.passwordTextField.becomeFirstResponder()
		} else if textField == self.passwordTextField {
			self.passwordConfirmationTextField.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
			registerAction(textField)
		}
		return true
	}
	
	//MARK:- Image Picker Delegate
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		var selectedImageFromPicker: UIImage?
		
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
		}
		else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
		}
		
		if let selectedImage = selectedImageFromPicker {
			profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
			profileImageView.clipsToBounds = true
			profileImageView.contentMode = .scaleAspectFill
			profileImageView.image = selectedImage
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	
}

