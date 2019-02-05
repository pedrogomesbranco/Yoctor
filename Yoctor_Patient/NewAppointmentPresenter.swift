//
//  NewAppointmentPresenter.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 18/11/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class NewAppointmentPresenter: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private var selectedDoctor: Doctor!
	private var selectedNextAvailableTime: Bool!
	private var selectedTimeIntervalsPerWeekday: [[Bool]]!
    private var screenSize: CGSize!

	@IBOutlet weak var requestOptionsTable: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		selectedNextAvailableTime = false
		
        requestOptionsTable.delegate = self
		requestOptionsTable.dataSource = self
		
		requestOptionsTable.tableFooterView = UIView()
        
        screenSize = self.view.frame.size

    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
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
		
		let label : UILabel = UILabel(frame: CGRect(x: 12, y: 5, width: tableView.bounds.size.width, height: 50))
		label.backgroundColor = UIColor.clear
		label.font = UIFont(name: "Dosis-SemiBold", size: 21)
		label.textColor = UIColor(red: 75/255, green: 74/255, blue: 74/255, alpha: 1)
		
		if section == 0 {
			label.text = "Escolha o médico"
			headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50)
		}
		else {
			label.text = "Escolha um dia e horário"
			headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25)
		}
		headerView.addSubview(label)
		
		return headerView
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		else {
			if selectedDoctor == nil {
				return 1
			}
			
			return selectedDoctor.workingDays.count + 1 /* Next availabel slot */
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		
		if indexPath.section == 0 {
			var allDoctors: [Doctor] = []
			for (_, doctor) in DoctorManager.sharedInstance.doctors {
				allDoctors.append(doctor)
			}
			
			let collectionCell = tableView.dequeueReusableCell(withIdentifier: "AllDoctorsCell", for: indexPath) as! AllDoctorsCell
			collectionCell.dataSource = allDoctors
			collectionCell.changeSelectedDoc = didSelectDoctor
			
			cell = collectionCell
		}
		else {
			if selectedDoctor == nil {
				cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
				cell.textLabel?.textAlignment = .center
				cell.textLabel?.text = "Nenhum médico selecionado"
			}
			else {
				if indexPath.row == 0 {
					let nextAvailableCell = tableView.dequeueReusableCell(withIdentifier: "NextAppointmentCell", for: indexPath) as! NextAppointmentCell
					nextAvailableCell.selectedHandler = didSelectNextAvailableAppointment
					
					cell = nextAvailableCell
				}
				else {
					let timeIntervalCell = tableView.dequeueReusableCell(withIdentifier: "TimeIntervalCell", for: indexPath) as! TimeIntervalCell
					
					timeIntervalCell.weekdayLabel.text = weekdaysDescription[selectedDoctor.workingDays[indexPath.row - 1] - 1]
					
					timeIntervalCell.firstIntervalButton.setTitle(getTimeIntervalText(of: 1), for: .normal)
					timeIntervalCell.firstIntervalButton.tag = indexPath.row + 100
					timeIntervalCell.firstIntervalButton.addTarget(self, action: #selector(self.didSelectTimeInterval), for: .touchUpInside)
					
					timeIntervalCell.secondIntervalButton.setTitle(getTimeIntervalText(of: 2), for: .normal)
					timeIntervalCell.secondIntervalButton.tag = indexPath.row + 200
					timeIntervalCell.secondIntervalButton.addTarget(self, action: #selector(self.didSelectTimeInterval), for: .touchUpInside)
					
					timeIntervalCell.thirdIntervalButton.setTitle(getTimeIntervalText(of: 3), for: .normal)
					timeIntervalCell.thirdIntervalButton.tag = indexPath.row + 300
					timeIntervalCell.thirdIntervalButton.addTarget(self, action: #selector(self.didSelectTimeInterval), for: .touchUpInside)
					
					if selectedNextAvailableTime {
						timeIntervalCell.setDisabled()
					}
					else {
						timeIntervalCell.setEnabled()
					}
					
					cell = timeIntervalCell
				}
			}
		}
		
		return cell
	}
	
	func getTimeIntervalText(of button: Int) -> String {
		let startOfTimeIntervals = selectedDoctor.getServiceIntervals()
		
		switch button {
		case 1:
			let firstStart = startOfTimeIntervals[0].timeDescription().components(separatedBy: "-")[0]
			let secondStart = startOfTimeIntervals[1].timeDescription().components(separatedBy: "-")[0]
			
			return firstStart + "-" + secondStart + "h"
		case 2:
			let secondStart = startOfTimeIntervals[1].timeDescription().components(separatedBy: "-")[0]
			let thirdStart = startOfTimeIntervals[2].timeDescription().components(separatedBy: "-")[0]
			
			return secondStart + "-" + thirdStart + "h"
		default:
			let thirdStart = startOfTimeIntervals[2].timeDescription().components(separatedBy: "-")[0]
			let end = selectedDoctor.workingTimeInterval[1].timeDescription().components(separatedBy: "-")[0]
			
			return thirdStart + "-" + end + "h"
		}
	}
	
	@IBAction func sendAppointmentRequest(_ sender: Any) {
		RequestManager.sharedInstance.sendRequest(with: selectedDoctor, on: selectedTimeIntervalsPerWeekday) { (result) in
			if result == success {
				self.navigationController?.popViewController(animated: true)
			}
			else {
				let alert = UIAlertController(title: "Erro", message: success, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func didSelectDoctor(_ doctor: Doctor) {
		selectedDoctor = doctor
		
		selectedTimeIntervalsPerWeekday = []
		for _ in doctor.workingDays {
			selectedTimeIntervalsPerWeekday.append([false, false, false])
		}
		
		// Reload "Escolha um dia e horário" section
		requestOptionsTable.reloadSections(IndexSet(integer: 1), with: .fade)
	}
	
	func didSelectNextAvailableAppointment(_ selected: Bool) {
		selectedNextAvailableTime = selected
		
		// Reload just the weekday cells
		var rowsToReload = [IndexPath]()
		for i in 1...selectedDoctor.workingDays.count {
			rowsToReload.append(IndexPath(row: i, section: 1))
		}
		requestOptionsTable.reloadRows(at: rowsToReload, with: .fade)
	}
	
	func didSelectTimeInterval(_ button: UIButton) {
		var timeInterval = button.tag / 100
		let weekday = button.tag - (timeInterval * 100) - 1
		timeInterval -= 1
		
		selectedTimeIntervalsPerWeekday[weekday][timeInterval] = button.isSelected
		print("\n", #function, selectedTimeIntervalsPerWeekday, "\n")
	}
	
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = CGFloat()
        var cellSize = CGSize()
        
        switch indexPath.section {
        case 0:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 170))
            cellHeight = cellSize.height
        default:
            cellSize = constraintsSize(sizeObj: CGSize(width: 0, height: 50))
            cellHeight = cellSize.height
        }
        
        return cellHeight
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
