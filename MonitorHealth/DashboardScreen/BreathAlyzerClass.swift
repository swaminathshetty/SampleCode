//
//  BreathAlyzerClass.swift
//  MonitorHealth
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class BreathAlyzerClass: UIViewController {
    weak var delegate: delegateNew?
    
    @IBOutlet weak var statusPopupView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    var mBacTrack = BacTrackAPI()
    var breathalyzers = NSMutableArray()
    let apiKey = "6ac2eb87293a4e3fbca92783012ef6"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusPopupView.layer.borderWidth = 1
        self.statusPopupView.isHidden = true
        mBacTrack.delegate = self
        self.initalizeBacTrackApi(apiKey: apiKey)
    }
    func initalizeBacTrackApi(apiKey:String){
        mBacTrack = BacTrackAPI(delegate: self, andAPIKey: apiKey)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.transition(with: statusPopupView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            self.statusPopupView.isHidden = false
        }, completion: nil)
        mBacTrack.startScan()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        mBacTrack.stopScan()
        mBacTrack.disconnect()
    }
    
}
extension BreathAlyzerClass: BacTrackAPIDelegate{
    
    func bacTrackAPIKeyAuthorized() {
        print("Key is authorized")
    }
    func bacTrackAPIKeyDeclined(_ errorMessage: String!) {
        print("errorMessage :\(String(describing: errorMessage))")
    }
    
    func bacTrackFound(_ breathalyzer: Breathalyzer!) {
        print(breathalyzer.peripheral.name?.description as Any)
        
        let breathalyzerUUID  = breathalyzer.peripheral.identifier.uuidString
        
        print("breathalyzerUUID :\(breathalyzerUUID)")
        
        for breath in breathalyzers{
            let breathUUID = (breath as AnyObject).peripheral.identifier.uuidString
            if breathUUID == breathalyzerUUID{
                print("Duplicate Breathalyzer UUID found!")
                return
            }
            
        }
        breathalyzers.add(breathalyzer)
        print("breathalyzers: \(breathalyzers)")
        if breathalyzers.count > 0{
            let b = breathalyzers[0]
            mBacTrack.stopScan()
            mBacTrack.connect(b as? Breathalyzer, withTimeout: 10)
        }
    }
    func bacTrackConnected(_ device: BACtrackDeviceType) {
        self.statusLabel.text = "Status:  Connected.."
        print("Connected to bactrack device")
        mBacTrack.startCountdown()
    }
    func bacTrackDisconnected() {
        print("bactrack device is disconnected")
    }
    func bacTrackCountdown(_ seconds: NSNumber!, executionFailure error: Bool) {
        if error{
            print("error:\(error)")
            return
        }else{
            print("Warming Up")
            self.statusLabel.text = "Status:  Warming Up"
        }
    }
    func bacTrackStart() {
        print("Blow now!")
        self.statusLabel.text = "Status:  Blow now"
    }
    func bacTrackBlow() {
        print("keep blowing")
        self.statusLabel.text = "Status:  Keep Blowing"
    }
    func bacTrackAnalyzing() {
        print("Analyzing results")
        self.statusLabel.text = "Status:  Analyzing"
    }
    func bacTrackResults(_ bac: CGFloat) {//
        print("Result :\(String(format: "%.2f", bac))")
        self.statusLabel.text = String(format: "%.2f", bac)
        UserDefaults.standard.setValue("FROMBREATHALYSER", forKey: "NAVIGATION")
        UserDefaults.standard.setValue(self.statusLabel.text, forKey: "bacTrackResult")
        UserDefaults.standard.synchronize()

        mBacTrack.stopScan()
        mBacTrack.disconnect()
        
        self.delegate?.moveToReadingPopUpScreen()
    }
    func bacTrackConnectTimeout() {
        print("timed out")
        mBacTrack.stopScan()
        mBacTrack.disconnect()
    }
    func bacTrackGetTimeout() -> TimeInterval {
        return 10
    }
    func bacTrackBatteryLevel(_ number: NSNumber!) {
        
    }
    func bacTrackError(_ error: Error!) {
        print("bacTrackError:\(error)")
        mBacTrack.disconnect()
        let alert = UIAlertController(title: "Message", message: "Unable to fetch readings from device. Please try again once", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
            
        }))
        self.present(alert, animated: true, completion: nil)

        self.delegate?.removeBreathAlyserScreen()
    }
    
    
}
