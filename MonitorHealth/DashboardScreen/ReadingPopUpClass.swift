//
//  ReadingPopUpClass.swift
//  MonitorHealth
//
//  Created by Apple on 02/05/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class ReadingPopUpClass: UIViewController {
    weak var delegate: delegateNew?

    @IBOutlet weak var backgroundBg: UIView!
    @IBOutlet weak var bgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readingValueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var pulseReadingValue = String()
    var spo2ReadingValue = String()
    var postParameters = [String:Any]()

    //var popUpTimer = Timer()
    var runTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let vitalname = UserDefaults.standard.object(forKey: "VitalName") as? String{
            self.titleLabel.text = "\(vitalname) value is"
        }
        
        self.backgroundBg.layer.cornerRadius = 10.0
        self.backgroundBg.layer.borderWidth = 2;
        self.backgroundBg.layer.borderColor = UIColor(red: 7/255, green: 50/255, blue: 136/255, alpha: 1.0).cgColor
        self.backgroundBg.isHidden = true
        
        let isNavigation = UserDefaults.standard.object(forKey: "NAVIGATION") as! String?
        print("isNavigation from :\(isNavigation)")
        
        if isNavigation == "FROMOBJC" {
            
            if var deviceReadingValue = UserDefaults.standard.object(forKey: "DeviceReadingValue") as! String?{
                print("deviceReadingValue : \(deviceReadingValue)")
                if deviceReadingValue.count > 0 {
                    if deviceReadingValue == "NotProperDevice" {
                        
                        let alert = UIAlertController(title: "Message", message: "Please Switch On Heart Rate Device and try again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
                            
                            UserDefaults.standard.setValue("NULL", forKey: "DeviceReadingValue")
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        if deviceReadingValue == "NULL" {
                        }
                        else{//Result Value
                            let splitArray = deviceReadingValue.components(separatedBy: "/")
                            if splitArray.count > 0 {
                                deviceReadingValue = splitArray[0]
                                if splitArray.count > 1{
                                    spo2ReadingValue = splitArray[0]
                                    pulseReadingValue = splitArray[1]
                                }
                            }
                            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                                //Pop Up
                                let vitalName = UserDefaults.standard.object(forKey: "VitalName") as? String
                                self.vitalNameComparing(vitalname: vitalName!, deviceReadingValue: deviceReadingValue)
                                self.vitalInsertion()
                                self.runTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.stopTimerCode), userInfo: nil, repeats: false)
                                
                            })
                        }
                    }
                }
            }
            else{
                print("deviceReadingValue : Optional Null")
            }
            
            UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
            UserDefaults.standard.synchronize()
            
        }
        else if isNavigation == "FROMBREATHALYSER" {//GRXSelectedVital
            UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
            let getPatientID = UserDefaults.standard.object(forKey: "PatientID") as! Int
            let userName = UserDefaults.standard.object(forKey: "UserName") as! String
            UserDefaults.standard.synchronize()
            
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in

                let bacTrackResult = UserDefaults.standard.object(forKey: "bacTrackResult") as? String
                self.readingTextAttributedText(readingValue: bacTrackResult!, units: "g/dL")
                
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":"Breathalyzer","Vital1":bacTrackResult!,"Vital2":"","CreatedBy":userName]
                self.vitalInsertion()
                self.runTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.stopTimerCode), userInfo: nil, repeats: false)
                })
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var transition = CATransition()
        transition.duration = 1.5
        transition.type = .moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.backgroundBg.layer.add(transition, forKey: nil)
        self.backgroundBg.isHidden = false


        /*let isNavigation = UserDefaults.standard.object(forKey: "NAVIGATION") as! String?
        print("isNavigation from :\(isNavigation)")
        
        if isNavigation == "FROMOBJC" {
            
            if var deviceReadingValue = UserDefaults.standard.object(forKey: "DeviceReadingValue") as! String?{
                print("deviceReadingValue : \(deviceReadingValue)")
                if deviceReadingValue.count > 0 {
                    if deviceReadingValue == "NotProperDevice" {
                        
                        let alert = UIAlertController(title: "Message", message: "Please Switch On Heart Rate Device and try again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
                            
                            UserDefaults.standard.setValue("NULL", forKey: "DeviceReadingValue")
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        if deviceReadingValue == "NULL" {
                        }
                        else{//Result Value
                            let splitArray = deviceReadingValue.components(separatedBy: "/")
                            if splitArray.count > 0 {
                                deviceReadingValue = splitArray[0]
                                if splitArray.count > 1{
                                    spo2ReadingValue = splitArray[0]
                                    pulseReadingValue = splitArray[1]
                                }
                            }
                            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                                //Pop Up
                                let vitalName = UserDefaults.standard.object(forKey: "VitalName") as? String
                                self.vitalNameComparing(vitalname: vitalName!, deviceReadingValue: deviceReadingValue)
                                self.vitalInsertion()
                                self.runTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.stopTimerCode), userInfo: nil, repeats: false)

                            })
                        }
                    }
                }
            }
            else{
                print("deviceReadingValue : Optional Null")
            }
            
            UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
            UserDefaults.standard.synchronize()
            
        }*/
    }
    func vitalNameComparing(vitalname:String, deviceReadingValue:String) {
        let getPatientID = UserDefaults.standard.object(forKey: "PatientID") as! Int
        let userName = UserDefaults.standard.object(forKey: "UserName") as! String
        let selectedVitalName = UserDefaults.standard.object(forKey: "GRXSelectedVital") as? String
        
        if vitalname == selectedVitalName{
            switch vitalname {
            case "HeartRate":
                readingTextAttributedText(readingValue: pulseReadingValue, units: "bpm")
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":vitalname,"Vital1":pulseReadingValue,"Vital2":"","CreatedBy":userName]
                
            case "Temperature":
                readingTextAttributedText(readingValue: deviceReadingValue, units: "°F")
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":vitalname,"Vital1":deviceReadingValue,"Vital2":"","CreatedBy":userName]
                
            case "PulseOximeter":
                readingTextAttributedText(readingValue: spo2ReadingValue, units: "%")
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":vitalname,"Vital1":spo2ReadingValue,"Vital2":"","CreatedBy":userName]
                
            case "BloodPressure":
                readingTextAttributedText(readingValue: deviceReadingValue, units: "mmHg")
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":vitalname,"Vital1":deviceReadingValue,"Vital2":"","CreatedBy":userName]
                
            case "Weight":
                readingTextAttributedText(readingValue: deviceReadingValue, units: "kgs")
                self.postParameters = ["PatientID":getPatientID,"HealthVitalType":vitalname,"Vital1":deviceReadingValue,"Vital2":"","CreatedBy":userName]
                
            default:
                self.readingValueLabel.text = ""
            }
        }
    }
    func readingTextAttributedText(readingValue:String, units:String)
    {
        var vitalValue = readingValue + " " + units
        let font = UIFont(name: "HelveticaNeue", size: 18)!
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 30)!
        readingValueLabel.attributedText = readingValue.withBoldText(
            boldPartsOfString: [readingValue as NSString], font: font, boldFont: boldFont)
        self.readingValueLabel.text = vitalValue
        
    }
    @objc func stopTimerCode() {
        self.runTimer!.invalidate()
        self.delegate?.removeReadingPopupScreen()
    }

    //Insert Func
    func vitalInsertion(){
        guard let VitalUrl = URL(string: "http://42.104.96.36:85/api/HealthMonitor/InsertHealthVitals") else { return }
        print(VitalUrl)
        let request = NSMutableURLRequest(url: VitalUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: postParameters, options: [])
        print("parameters: \(postParameters)")
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let vitalInsertionData = try JSONDecoder().decode(messageDict.self, from: data)
                
                print("getvitalInsertionData:", vitalInsertionData)

            } catch let err {
                print("Err", err)
            }
            }.resume()
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UserDefaults.standard.setValue("NULL", forKey: "DeviceReadingValue")
        UserDefaults.standard.setValue("", forKey: "GRXDeviceType")
        UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
        UserDefaults.standard.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
