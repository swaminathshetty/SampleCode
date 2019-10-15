//
//  BPHelp.swift
//  MonitorHealth
//
//  Created by Apple on 09/08/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class BPHelp: UIViewController {

    enum deviceSelection:String{
        case breathAlyser = "Breathalyzer"
        case BP = "BloodPressure"
        case temp = "Temperature"
        case pulseOximeter = "PulseOximeter"
        case heartRate = "HeartRate"
        case weight = "Weight"
    }

    weak var delegate: delegateNew?
    @IBOutlet weak var textView_Points: UITextView!
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mainView.layer.cornerRadius = 10.0
        self.mainView.layer.borderWidth = 2;
        self.mainView.layer.borderColor = UIColor(red: 7/255, green: 50/255, blue: 136/255, alpha: 1.0).cgColor
        
        let deviceName = UserDefaults.standard.object(forKey: "VitalName") as? String
        deviceSelectionSwitchCase(deviceName: deviceName!)

        
        //Temperature
        /*Press START to connect your bluetooth approved device. Please make sure your bluetooth is turned on in your device to ransfer the data. */

    }
    func deviceSelectionSwitchCase(deviceName:String) {
        switch deviceName {
        case deviceSelection.breathAlyser.rawValue:
            
            self.textView_Points.text = """
            1. Press and hold the Power Button for one second to turn on the BACtrack device.\n\n2. If the rear blue LED light is off, hold the power button for seven seconds to switch from standalone to BACtrack App mode.\n\n3. Once BACtrack in App mode, Click on "Get My Reading" icon from App.\n\n4. When the app connected/pair with BACtrack, the app screen will momentarily show the status of connection.\n\n5. When the screen on your mobile device reads "Blow Now", take a deep breath, and blow into your BACtrack continuosly until app shows "Analyzed" popup.\n\n6. Once BACtrack has analyzed the breath sample then the app will display the "Blood Alcohol Content" value.\n\n7. Blood Alcohol Content level will return 0.00% if no additional drinks are consumed.\n\n8. Your BACtrack will power off automatically in 10 seconds. You can also turn it off at any time by with pressing the power button for two seconds.
            """
            break
            
        case deviceSelection.BP.rawValue:
            self.textView_Points.text = """
            1. Please make sure your bluetooth is turned on in your device to transfer the data.\n\n2. Press "Get My Reading" button in app to connect to your bluetooth approved device.\n\n3. When the app is connected with Blood Pressure device, the app screen will momentarily show the status of connection.\n\n4. After successful Connection with Blood Pressure device, app will show a popup with the return result value and device will get power off automatically.
            """
            break
            
        case deviceSelection.temp.rawValue:
            self.textView_Points.text = """
            1. Please make sure your bluetooth is turned on in your device to transfer the data.\n\n2. Press "Get My Reading" button to connect to your bluetooth approved device.\n\n3. When the app is connected with Temperature device, the app screen will momentarily show the status of connection.\n\n4. After successful Connection with Temperature device, app will show a popup with the return result value and device will get power off automatically.
            """
            break
            
        case deviceSelection.pulseOximeter.rawValue:
            self.textView_Points.text = """
            1. Please make sure your bluetooth is turned on in your device to transfer the data.\n\n2. Press "Get My Reading" button to connect to your bluetooth approved device.\n\n3. When the app is connected/pair with PulseOximeter device, the app screen will momentarily show the status of connection.\n\n4. After successful Connection with PulseOximeter device, app will show a popup with the return result value and device will get power off automatically.
            """
            break
            
        case deviceSelection.heartRate.rawValue:
            self.textView_Points.text = """
            1. Please make sure your bluetooth is turned on in your device to transfer the data.\n\n2. Press "Get My Reading" button to connect to your bluetooth approved device.\n\n3. When the app is connected/pair with PulseOximeter device, the app screen will momentarily show the status of connection.\n\n4. After successful Connection with PulseOximeter device, app will show a popup with the return result value and device will get power off automatically.
            """
            break
            
        case deviceSelection.weight.rawValue:
            self.textView_Points.text = """
            1. Please make sure your bluetooth is turned on in your device to transfer the data.\n\n2. Press "Get My Reading" button to connect to your bluetooth approved device.\n\n3. When the app is connected/pair with Weight device, the app screen will momentarily show the status of connection.\n\n4. After successful Connection with Weight device, app will show a popup with the return result value and device will get power off automatically.
            """
            break
            
        default:
            self.textView_Points.text = "Device Selection is none"
            break
        }
    }
    

    @IBAction func action_CloseBtn(_ sender: Any) {
        self.delegate?.removeAllHelpScreens()
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
