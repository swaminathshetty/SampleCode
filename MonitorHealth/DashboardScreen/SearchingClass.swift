//
//  SearchingClass.swift
//  MonitorHealth
//
//  Created by HYLPMB00015 on 29/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class SearchingClass: UIViewController {
    var mBacTrack = BacTrackAPI()

    
    weak var delegate: delegateNew?

    //Ble Extension
    var centralManager:CBCentralManager!
    var sensorPeripheralTag:CBPeripheral!
    let sensorPeripheralName = "TAIDOC"
    let breathalyzerPeripheralName = "BACtrack"
    
    
    
    //NEXT PERIPHERAL NAME: Ionic
    //NEXT PERIPHERAL UUID: A1000E59-ABC4-53CE-07D3-A85AEC8344C3

    let timerScanInterval:TimeInterval = 20.0
    var scanTimer = Timer()
    var progressBarTimer = Timer()
    var progressBarInt = Float()

    @IBOutlet weak var vitalimg: UIImageView!
    @IBOutlet weak var label_search: UILabel!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var progressBarWidthCon: NSLayoutConstraint!
    @IBOutlet weak var popUpViewWidthCon: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.vitalimg.image = UIImage(named: UserDefaults.standard.object(forKey: "VitalImage") as! String)
        let vitalname = UserDefaults.standard.object(forKey: "VitalName") as? String
        vitalNameStoredinDefaults(vitalname: vitalname!)
        self.label_search.text = "Searching " + vitalname! + " device"
        // self.alphaView.layer.cornerRadius = 10.0
        self.alphaView.layer.borderWidth = 1
        self.alphaView.isHidden = true

        //progressBarHeightConstarint.constant = 10.0
        popUpViewWidthCon.constant = 310
        //progressBarWidthCon.constant = 150

        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:false])

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.transition(with: alphaView, duration: 0.8, options: [.transitionCurlDown], animations: {
            self.alphaView.isHidden = false
        }, completion: nil)
    }
    

    @IBAction func btnClick(_ sender: UIButton) {
        scanTimer.invalidate()
        progressBarTimer.invalidate()
        self.centralManager.stopScan()
        self.delegate?.removeSearchingScreen()
    }
    
    func vitalNameStoredinDefaults(vitalname:String) {
        
        switch vitalname {
        case "Breathalyzer":
            UserDefaults.standard.setValue("GRXBreathalyzer", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("Breathalyzer", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        case "HeartRate":
            UserDefaults.standard.setValue("GRXDeviceHeartRate", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("HeartRate", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        case "Temperature":
            UserDefaults.standard.setValue("GRXDeviceTemperature", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("Temperature", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        case "PulseOximeter":
            UserDefaults.standard.setValue("GRXDeviceSPO2", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("PulseOximeter", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        case "BloodPressure":
            UserDefaults.standard.setValue("GRXDeviceBP", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("BloodPressure", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        case "Weight":
            UserDefaults.standard.setValue("GRXDeviceWeight", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("Weight", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        default:
            UserDefaults.standard.setValue("", forKey: "GRXDeviceType")
            UserDefaults.standard.setValue("", forKey: "GRXSelectedVital")
            UserDefaults.standard.synchronize()
        }

    }

}

extension SearchingClass:CBCentralManagerDelegate,CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var showAlert = true
        var message = ""
        
        switch central.state {
        case .poweredOff:
            message = "Bluetooth on this device is currently powered off. Please turn on bluetooth from settings"
        case .unsupported:
            message = "This device does not support Bluetooth Low Energy."
        case .unauthorized:
            message = "This app is not authorized to use Bluetooth Low Energy."
        case .resetting:
            message = "The BLE Manager is resetting; a state update is pending."
        case .unknown:
            message = "The state of the BLE Manager is unknown."
        case .poweredOn:
            showAlert = false
            message = "Bluetooth LE is turned on and ready for communication."
            
            print(message)
            progressBarInt = 0.0
            progressBar.setProgress(progressBarInt, animated: true)

            scanTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)

            progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(progressBarAnimation), userInfo: nil, repeats: true)

            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            
        }
        
        if showAlert {
            
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("centralManager didDiscoverPeripheral - CBAdvertisementDataLocalNameKey is \"\(CBAdvertisementDataLocalNameKey)\"")
        
        if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("NEXT PERIPHERAL NAME: \(peripheralName)")
            print("NEXT PERIPHERAL UUID: \(peripheral.identifier.uuidString)")
            if peripheralName.contains(sensorPeripheralName) {
                
                print("GRX Device Found")
                //UserDefaults.standard.setValue("GRXDeviceHeartRate", forKey: "GRXDeviceType")
                UserDefaults.standard.setValue(peripheralName, forKey: "peripheralName")
                UserDefaults.standard.removeObject(forKey: "DeviceReadingValue")
                UserDefaults.standard.synchronize()

                scanTimer.invalidate()
                progressBarTimer.invalidate()
                progressBar.setProgress(0.0, animated: true)

                centralManager.stopScan()
                self.sensorPeripheralTag = peripheral
                self.sensorPeripheralTag!.delegate = self

                self.delegate?.moveToObjectiveCScreens()
            }
            else if peripheralName.contains(breathalyzerPeripheralName) {
                scanTimer.invalidate()
                progressBarTimer.invalidate()
                progressBar.setProgress(0.0, animated: true)
                
                centralManager.stopScan()
                self.sensorPeripheralTag = peripheral
                self.sensorPeripheralTag!.delegate = self
                
                self.delegate?.moveToBreathAlyserScreen()
            }
        }
    }
    @objc func progressBarAnimation()
    {
        print("*** progressBarAnimation SCAN...")
        let completionPercentage = Int(((Float(timerScanInterval) - Float(progressBarInt))/Float(timerScanInterval)) * 100)
        print("*** completionPercentage SCAN: %@",completionPercentage)
        progressBar.setProgress(Float(progressBarInt) / Float(timerScanInterval - 1.0), animated: true)
        progressBarInt += 1
        
    }

    @objc func pauseScan() {
        print("*** PAUSING SCAN...")
        scanTimer.invalidate()
        progressBarTimer.invalidate()
        centralManager.stopScan()
        progressBar.setProgress(0.0, animated: true)
        let alert = UIAlertController(title: "Message", message: "Device not found, please turn power on the device.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
            self.delegate?.removeSearchingScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    


}
extension SearchingClass:BacTrackAPIDelegate{
    //BacTrackAPI * mBacTrack;
    
    func bacTrackAPIKeyDeclined(_ errorMessage: String!) {
        print("errorMessage :\(String(describing: errorMessage))")
    }
    func bacTrackAPIKeyAuthorized() {
        
    }
    
}
