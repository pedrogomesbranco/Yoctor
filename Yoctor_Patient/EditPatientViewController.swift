//
//  EditPatientViewController.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class EditPatientViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	private var loginManager: Login!
	private var infoValues: [Any]!
	private var infoKeys: [String]!
	private var textFields: [UITextField]!
    private var activityIndicatorView: UIView!
	private var screenSize: CGSize!
	private var didShowKeyboard: Bool = true

	@IBOutlet weak var profilePhotoView: UIImageView!
	@IBOutlet weak var editionTableView: UITableView!
    
	@IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func finishEditing(_ sender: Any) {
		let alert = UIAlertController(title: "Seu telefone só deve conter números.", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
		
        //start activity indicator
        
        activityIndicatorView = ActivityIndicator().startActivityIndicator(obj: self)
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
		var indexedInfo = [String : Any]()
		
		for index in 0...infoValues.count - 1 {
			if infoKeys[index] == "insurance_expiration" {
				let dateComponents = textFields[index].text!.components(separatedBy: "/")
				for i in 0...dateComponents.count-1 {
					if Int(dateComponents[i]) == nil || i >= 3 {
						alert.title = "A data inserida não é válida."
						present(alert, animated: true, completion: {
							ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
						})
						
						return
					}
				}
				
				let dateString = dateComponents[0] + "-" + dateComponents[1] + "-" + dateComponents[2]
				
				infoValues[index] = dateString as Any
			}
			else if infoKeys[index] == "phone" || infoKeys[index] == "insurance_number" {
				if Int(textFields[index].text!) == nil {
					alert.title = "Telefone e número do plano de saúde devem conter apenas números."
					present(alert, animated: true, completion: { 
						ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
					})
					
					return
				}
				
				let numbericInfo = Int(textFields[index].text!)
				
				infoValues[index] = numbericInfo! as Any
			}
			else {
				infoValues[index] = textFields[index].text! as Any
			}
			
			indexedInfo.updateValue(infoValues[index], forKey: infoKeys[index])
		}
		
		loginManager.updateUserInfo(info: indexedInfo) { (result) in
			if result == success {
				if self.profilePhotoView.image != #imageLiteral(resourceName: "imagebut1") {
					self.loginManager.updateUserPicture(to: self.profilePhotoView.image!, { (result) in
						if result == success {
                            
                            //stop activity indicator
                            ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
							self.dismiss(animated: true, completion: nil)
						}
					})
				}
				else {
                    
                    //stop activity indicator
                    ActivityIndicator().stopActivityIndicator(obj: self, indicator: self.activityIndicatorView)
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	@IBAction func changeProfilePhoto(_ sender: Any) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.sourceType = .photoLibrary
		
		self.present(imagePicker, animated: true, completion: nil)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        textFields.first?.becomeFirstResponder()
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = self.view.frame.size
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		didShowKeyboard = true
		
		loginManager = Login.sharedInstance
		infoValues = []
		infoKeys = []
		textFields = []
        
        for textField in self.textFields{
            textField.delegate = self
        }
        textFields.first?.becomeFirstResponder()
        
        for _ in 0...4{
            infoValues.append(" ")
            infoKeys.append(" ")
        }
        
		for (key, value) in (loginManager.user?.makeJSON())! {
            if key == "name"{
                infoKeys[0] = key
                infoValues[0] = value
            }
            if key == "phone"{
                infoKeys[1] = key
                infoValues[1] = value
            }
            if key == "health_insurance"{
                infoKeys[2] = key
                infoValues[2] = value
            }
            if key == "insurance_number"{
                infoKeys[3] = key
                infoValues[3] = value
            }
            if key == "insurance_expiration"{
                infoKeys[4] = key
                infoValues[4] = value
            }
		}
		print("\n", infoValues, "\n")
		if let userPhoto = loginManager.user?.photo {
			profilePhotoView.layer.cornerRadius = profilePhotoView.frame.size.width/2
			profilePhotoView.clipsToBounds = true
			profilePhotoView.contentMode = .scaleAspectFill
			profilePhotoView.image = userPhoto
		}
		
        editionTableView.tableFooterView = UIView()

		editionTableView.dataSource = self
		editionTableView.isScrollEnabled = true
    }
	
	//MARK:- TableView Datasource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return infoValues.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let editingCell = tableView.dequeueReusableCell(withIdentifier: "editingCell") as! EditTableViewCell
		
		textFields.append(editingCell.editTextField)
		editingCell.editTextField.delegate = self
		
		if let info = infoValues[indexPath.row] as? Int {
			editingCell.editTextField.text = String(info)
		}
		else {
			editingCell.editTextField.text = infoValues[indexPath.row] as? String
		}
		
		if infoKeys[indexPath.row] == "insurance_expiration" {
			editingCell.editTextField.text = (loginManager.user as! Patient).insuranceExpiration.dateDescription().replacingOccurrences(of: "-", with: "/")
		}
		
		editingCell.infoDescription = infoKeys[indexPath.row]
		editingCell.iconImage.image = UIImage(named: infoKeys[indexPath.row])
        editingCell.iconImage.frame.size = constraintsSize(sizeObj: editingCell.iconImage.frame.size)
        editingCell.frame.size = constraintsSize(sizeObj: editingCell.frame.size)
		
		return editingCell
	}
	
	func constraintsSize(sizeObj: CGSize)-> CGSize{
		if screenSize == CGSize(width: 320, height: 568){
			return CGSize(width: sizeObj.width * 0.853, height: sizeObj.height * 0.853)
		}
		else if screenSize == CGSize(width: 414, height: 736){
			return CGSize(width: sizeObj.width * 1.104, height: sizeObj.height * 1.104)
		}
		else{
			return CGSize(width: sizeObj.width, height: sizeObj.height)
		}
	}
	
	//MARK:- TextField Delegate
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardFrame = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) {
			if didShowKeyboard {
				editionTableView.frame.size.height -= keyboardFrame.height
				didShowKeyboard = false
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		var index = IndexPath(row: 0, section: 0)
		
		if textField == textFields[0] {
			textFields[1].becomeFirstResponder()
			index.row = 1
		} else if textField == textFields[1] {
			textFields[2].becomeFirstResponder()
			index.row = 2
		} else if textField == textFields[2] {
			textFields[3].becomeFirstResponder()
			index.row = 3
		} else if textField == textFields[3] {
			textFields[4].becomeFirstResponder()
			index.row = 4
		} else if textField == textFields[4] {
			textField.resignFirstResponder()
			finishEditing(textField)
		}
		
		editionTableView.scrollToRow(at: index, at: .top, animated: true)
		
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
			profilePhotoView.layer.cornerRadius = profilePhotoView.frame.size.width/2
			profilePhotoView.clipsToBounds = true
			profilePhotoView.contentMode = .scaleAspectFill
			profilePhotoView.image = selectedImage
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}
