//
//  MainViewController.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 10/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	private var agendaManager: AgendaAppointment!
	private var doctorsManager: DoctorManager!
	private var todayAppointments: [Appointment]!
	private var scheduledAppointments: [Appointment]!
    private var screenSize: CGSize!
    
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 40)!,
                NSForegroundColorAttributeName: UIColor(red: 68/255, green: 190/255, blue: 141/255, alpha: 1)
            ]
        }
		
        // delegate of notification
        UNUserNotificationCenter.current().delegate = self
		
        screenSize = self.view.frame.size
        
		agendaManager = AgendaAppointment.sharedInstance
		doctorsManager = DoctorManager.sharedInstance
		
		loadDataSources()
		
		tableView.dataSource = self
		tableView.delegate = self
		
        tableView.tableFooterView = UIView()
        
		//Set the observe of all todayAppoitments
		agendaManager.setAllObserversForTodayAppointments { (result) in
			if result == success {
				DispatchQueue.main.async {
					self.loadDataSources()
					self.tableView.reloadData()
				}
			}
		}
        
        //Set the observe of new Appointments 
        agendaManager.setObserverNewAppointment(tableNameOfPatient: "patients", key: "uid_appointments") { (result) in
            if result == success {
				DispatchQueue.main.async {
					self.loadDataSources()
					self.tableView.reloadData()
				}
            }
        }
        
	}
	
	func loadDataSources() {
		todayAppointments = []
		for appointment in agendaManager.todayAppointments() {
			if appointment.status == .confirmed || appointment.status == .notConfirmed {
				todayAppointments.append(appointment)
			}
		}
		todayAppointments = agendaManager.sortByHour(todayAppointments)
		
		scheduledAppointments = agendaManager.sort(agendaManager.futureAppointments())
	}
	
	//MARK:- TableView Sections
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let headerView = UIView()
		headerView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue: 249/255, alpha: 1)
		headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50)
		
		let label : UILabel = UILabel(frame: CGRect(x: 12, y: 5, width: 200, height: 50))
		label.backgroundColor = UIColor.clear
		label.font = UIFont(name: "Dosis-Medium", size: 21)
		label.textColor = UIColor(red: 75/255, green: 74/255, blue: 74/255, alpha: 1)
		
		if(section == 0){
			label.text = "Hoje"
		} else if (section == 1){
			label.text = "Futuras"
		} else {
			label.text = ""
		}
		
		headerView.addSubview(label)
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if section == 0 { //Today
			if todayAppointments.count == 0 {
				return 1
			}
			
			return todayAppointments.count
		}
		else { //Scheduled
			if scheduledAppointments.count == 0 {
				return 1
			}
			
			return scheduledAppointments.count
		}
		
	}
	
	//MARK:- TableView Cells
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell
		
		if indexPath.section == 0 { //Today
			if todayAppointments.count == 0 {
				cell = UITableViewCell()
				cell.textLabel?.text = "Você não possui consultas hoje."
                cell.textLabel?.adjustsFontSizeToFitWidth = true
			}
			else {
				let todayCell = tableView.dequeueReusableCell(withIdentifier: "todayCellReuseIdentifier") as! TodayTableViewCell
				
				todayCell.confirmButton.tag = indexPath.row
				todayCell.confirmButton.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
				todayCell.cancelButton.frame.size = constraintsSize(sizeObj: todayCell.cancelButton.frame.size)
				todayCell.confirmButton.isHidden = true
				
				todayCell.cancelButton.tag = indexPath.row
				todayCell.cancelButton.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
				todayCell.confirmButton.frame.size = constraintsSize(sizeObj: todayCell.confirmButton.frame.size)
				todayCell.cancelButton.isHidden = true
				
				let appointment = todayAppointments[indexPath.row]
				let doctor = doctorsManager.doctors[appointment.doctorUID]
				
				todayCell.doctorLabel.text = doctor?.name
				todayCell.specializationLabel.text = doctor?.specialty
				todayCell.doctorPhoto.image = doctor?.photo
                todayCell.doctorPhoto.frame.size = constraintsSize(sizeObj: todayCell.doctorPhoto.frame.size)

				var timeString = appointment.scheduleTime.timeDescription().replacingOccurrences(of: "-", with: "h")
				todayCell.predictionLabel.adjustsFontSizeToFitWidth = true
				todayCell.predictionLabel.isHidden = true
				
				if appointment.status == Status.notConfirmed {
					
					todayCell.cancelButton.isHidden = false
					todayCell.confirmButton.isHidden = false
					todayCell.predictionLabel.isHidden = true
					
				} else if appointment.status == Status.confirmed {
					
					timeString = appointment.predictionTime.timeDescription().replacingOccurrences(of: "-", with: "h")
					
					todayCell.cancelButton.isHidden = true
					todayCell.confirmButton.isHidden = true
					todayCell.predictionLabel.isHidden = false
					
				}
				
				todayCell.timeLabel.text = timeString
				
				cell = todayCell
			}
		}
		else { //Scheduled
			if scheduledAppointments.count == 0 {
				cell = UITableViewCell()
				cell.textLabel?.text = "Você não possui consultas agendadas."
                cell.textLabel?.adjustsFontSizeToFitWidth = true
			}
			else {
				let scheduledCell = tableView.dequeueReusableCell(withIdentifier: "scheduledCellReuseIdentifier") as! ScheduledTableViewCell
				
				let appointment = scheduledAppointments[indexPath.row]
				let doctor = doctorsManager.doctors[appointment.doctorUID]
				
				scheduledCell.doctorLabel.text = doctor?.name
				scheduledCell.specializationLabel.text = doctor?.specialty
				scheduledCell.doctorPhoto.image = doctor?.photo
				scheduledCell.dateLabel.text = appointment.scheduleTime.scheduleDescription()
				
                scheduledCell.doctorPhoto.frame.size = constraintsSize(sizeObj: scheduledCell.doctorPhoto.frame.size)
				cell = scheduledCell
			}
		}
		
		return cell
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = CGFloat()
        var cellSize = CGSize()
        
        switch indexPath.section {
        case 0:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 110))
            cellHeight = cellSize.height
        default:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 90))
            cellHeight = cellSize.height
        }
        
        return cellHeight
    }
    
	func confirmAction(_ sender: UIButton) {
		agendaManager.changeStatus(of: todayAppointments[sender.tag], to: .confirmed) { (result) in
			if result == success {
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
	
	func cancelAction() {
		let alert = UIAlertController(title: "Tem certeza que deseja cancelar a consulta?", message: "Ao cancelar a consulta, você não poderá mais voltar atrás.", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Cancelar consulta", style: .destructive, handler: nil))
		alert.addAction(UIAlertAction(title: "Não cancelar", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
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

extension MainViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}

