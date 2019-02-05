//
//  ViewController.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 10/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var loginClass: Login?
    
    
    
    //Delete fake info
    let fakeAppointment1 = Appointment(patientEmail: "patient@email.com", doctorEmail: "doctor@email.com", scheduleTime: Date())
    let fakeAppointment2 = Appointment(patientEmail: "patient@email.com", doctorEmail: "doctor@email.com", scheduleTime: Date())
    var fakeTodayArray: [Appointment] = []
    var fakeScheduledArray: [Appointment] = []
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
//        let logo = UIImage(named: "Group.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        
        //Delete fake info
        fakeTodayArray += [fakeAppointment1, fakeAppointment2]
        fakeScheduledArray += [fakeAppointment1, fakeAppointment2]
        
        fakeAppointment1.status = Status.confirmed
		
        tableView.dataSource = self
        tableView.delegate = self
        loginClass = Login.sharedInstance
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
          return fakeTodayArray.count
        } else if section == 1 {
            return fakeScheduledArray.count
        } else if section == 2 {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCellReuseIdentifier") as! Today_Table_View_Cell
            
            let appointment = fakeTodayArray[indexPath.row]
            
            //puxar infos do médico
            cell.doctorLabel.text = "Dr. Gustavo Olenka"
            cell.specializationLabel.text = "Urologista"
            
            let hour = DateFormatter()
            hour.dateFormat = "HH"
            let min = DateFormatter()
            min.dateFormat = "mm"
            
            var date = appointment.scheduleTime
            
            if appointment.status == Status.notConfirmed {
                
                cell.cancelButton.isHidden = false
                cell.confirmButton.isHidden = false
                cell.predictionLabel.isHidden = true
                
            } else if appointment.status == Status.confirmed {
                
                date = appointment.predictionTime
                
                cell.cancelButton.isHidden = true
                cell.confirmButton.isHidden = true
                cell.predictionLabel.isHidden = false
                
            }
            
            cell.timeLabel.text = "\(hour.string(from: date!))h\(min.string(from: date!))"
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledCellReuseIdentifier") as! Scheduled_Table_View_Cell
            
            let appointment = fakeScheduledArray[indexPath.row]
            
            //puxar infos dos médicos
            cell.doctorLabel.text = "Dr. Jacinto Leite Feitosa"
            cell.specializationLabel.text = "Obstetra"
            
            let date = appointment.scheduleTime
            
            let dayMonth = DateFormatter()
            dayMonth.dateFormat = "dd/MM"
            let hour = DateFormatter()
            hour.dateFormat = "HH"
            let min = DateFormatter()
            min.dateFormat = "mm"
            
            cell.dateLabel.text = "\(dayMonth.string(from: date!)) às \(hour.string(from: date!))h\(min.string(from: date!))"
            
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "doctorsCellReuseIdentifier") as! Doctors_Table_View_Cell
            
//            cell.textLabel?.text = "Médico"
            
            return cell
            
        } else {
            
            //Fix this
            
            let cell = UITableViewCell()
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Section \(indexPath.section), row \(indexPath.row) selected")
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label : UILabel = UILabel()
        if(section == 0){
            label.text = "Hoje"
        } else if (section == 1){
            label.text = "Agendado"
        } else if section == 2{
            label.text = "Seus Médicos"
        } else {
            label.text = ""
        }
        
        label.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 255/255, blue: 249/255, alpha: 255/255)
        return label
    }



}

