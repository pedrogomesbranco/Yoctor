//
//  PatientViewController.swift
//  Yoctor_Patient
//
//  Created by Pedro G. Branco on 12/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private var loginManager: Login!
	private var agendaManager: AgendaAppointment!
	private var doctorsManager: DoctorManager!
	private var userKeys: [String]!
	private var userInfos: [Any]!
	private var userHistory: [Appointment]!
	private var alert: UIAlertController!
    private var screenSize: CGSize!
	
    @IBOutlet weak var tableView: UITableView!
	
	public func getUserData() {
		userKeys = []
		userInfos = []
		for _ in 0...4{
			userInfos.append(" ")
			userKeys.append(" ")
		}
		
		for (key, value) in (loginManager.user?.makeJSON())! {
			if key == "name"{
				userKeys[0] = key
				userInfos[0] = value
			}
			if key == "phone"{
				userKeys[1] = key
				userInfos[1] = value
			}
			if key == "health_insurance"{
				userKeys[2] = key
				userInfos[2] = value
			}
			if key == "insurance_number"{
				userKeys[3] = key
				userInfos[3] = value
			}
			if key == "insurance_expiration"{
				userKeys[4] = key
				userInfos[4] = value
			}
		}
		
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		getUserData()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSFontAttributeName: UIFont(name: "Dosis", size: 40)!,
                NSForegroundColorAttributeName: UIColor(red: 68/255, green: 190/255, blue: 141/255, alpha: 1)
            ]
        }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        screenSize = self.view.frame.size

		loginManager = Login.sharedInstance
		agendaManager = AgendaAppointment.sharedInstance
		doctorsManager = DoctorManager.sharedInstance

		userHistory = agendaManager.pastAppointments()
		getUserData()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

	}
	
	//MARK:- Buttons for updating info
	@IBAction func changePassword(_ sender: Any) {
		self.loginManager.changePasswordOf(email: (loginManager.user?.email)!, { (result) in
			let alert: UIAlertController
			
			if result == success {
				alert = UIAlertController(title: "E-mail enviado com sucesso", message: "Consulte a caixa de entrada do e-mail cadastrado.", preferredStyle: .alert)
			}
			else {
				alert = UIAlertController(title: "Erro no envio do e-mail", message: result, preferredStyle: .alert)
			}
			
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			
			if let presented = self.presentedViewController {
				presented.present(alert, animated: true, completion: nil)
			}
			else {
				self.present(alert, animated: true, completion: nil)
			}
		})
	}
	
	@IBAction func changeEmail(_ sender: Any) {
		let textFieldAlert = UIAlertController(title: "Troca de e-mail", message: "Digite o novo e-mail que estar no seu cadastro.", preferredStyle: .alert)
		
		let confirmAction = UIAlertAction(title: "Trocar", style: .default, handler: { (action: UIAlertAction) -> Void in
			let textField = textFieldAlert.textFields![0] as UITextField
			
			self.loginManager.changeEmail(to: textField.text!, { (result) in
				if result == success {
					self.alert = UIAlertController(title: "E-mail trocado com sucesso", message: "Consulte sua caixa de entrada do novo e-mail fornecido para comfirmação.", preferredStyle: .alert)
				}
				else {
					self.alert = UIAlertController(title: "Erro na troca de e-mail", message: result, preferredStyle: .alert)
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
			textField.placeholder = "novo e-mail"
		}
		
		textFieldAlert.addAction(confirmAction)
		textFieldAlert.addAction(cancelAction)
		
		self.present(textFieldAlert, animated: true, completion: nil)
	}
	
	@IBAction func changeSocialNumbers(_ sender: Any) {
		
	}
    
    //MARK:- TableView Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return userInfos.count
		case 2:
			return 1
		case 3:
			if userHistory.count == 0 {
				return 1
			}
			
			return userHistory.count
		default:
			return 1
		}
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if (section == 4){
            return 25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0){
            return 0
        }
        else if(section == 1){
            return 0
        }
        else if(section == 3){
            return 50
        }
        else{
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue: 249/255, alpha: 1)
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25)
        
        return footerView

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue: 249/255, alpha: 1)
		
		let label : UILabel = UILabel(frame: CGRect(x: 12, y: 5, width: 200, height: 50))
		label.backgroundColor = UIColor.clear
		label.font = UIFont(name: "Dosis-SemiBold", size: 21)
		label.textColor = UIColor(red: 75/255, green: 74/255, blue: 74/255, alpha: 1)
		
		if(section == 3){
			label.text = "Histórico de Consultas"
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50)
            headerView.addSubview(label)

		} else {
			label.text = ""
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25)
		}
		
		return headerView
    }
	
    //MARK:- TableView Cells
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell
		
		switch indexPath.section {
			
		case 0:
			let photoCell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoCellTableViewCell
			
			if loginManager.user?.photo != nil {
				photoCell.photo.image = loginManager.user?.photo
			}
            
            photoCell.photo.frame.size = constraintsSize(sizeObj: photoCell.photo.frame.size)
			
			cell = photoCell
			
		case 1:  
			let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoTableViewCell
            
			if let info = userInfos[indexPath.row] as? Int {
				infoCell.contentLabel.text = String(info)
			}
			else {
				var stringInfo = userInfos[indexPath.row] as? String
				
				if userKeys[indexPath.row] == "insurance_expiration" {
					stringInfo = stringInfo!.replacingOccurrences(of: "-", with: "/")
				}
				
				infoCell.contentLabel.text = stringInfo
			}
			
			cell = infoCell
			
		case 2:
			cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonsTableViewCell
			
		case 3:
			if userHistory.count == 0 {
				cell = UITableViewCell()
				cell.textLabel?.text = "Você ainda não possui consultas."
			}
			else {
				let appointmentCell = tableView.dequeueReusableCell(withIdentifier: "doctorCell") as! ScheduledTableViewCell
				let doctor = doctorsManager.doctors[userHistory[indexPath.row].doctorUID]
				
				appointmentCell.doctorLabel.text = doctor?.name
				appointmentCell.doctorPhoto.image = doctor?.photo
				appointmentCell.specializationLabel.text = doctor?.specialty
				appointmentCell.dateLabel.text = userHistory[indexPath.row].scheduleTime.scheduleDescription()
				
                appointmentCell.doctorPhoto.frame.size = constraintsSize(sizeObj: appointmentCell.doctorPhoto.frame.size)
                
				cell = appointmentCell
			}
			
		default:
			let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingsTableViewCell
			
			settingCell.settingButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
			
			cell = settingCell
		}
		
		return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellSize = CGSize()
        var cellHeight = CGFloat()
        
        switch indexPath.section {
        case 0:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 170))
            cellHeight = cellSize.height
            
        case 1:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 30))
            cellHeight = cellSize.height
            
        case 2:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 90))
            cellHeight = cellSize.height
            
        case 3:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 90))
            cellHeight = cellSize.height
            
        default:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 50))
            cellHeight = cellSize.height
        }
        
        return cellHeight
    }
	
	func logout() {
		loginManager.logout { (result) in
			if result == success {
				self.navigationController?.dismiss(animated: true, completion: nil)
			}
		}
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
}
