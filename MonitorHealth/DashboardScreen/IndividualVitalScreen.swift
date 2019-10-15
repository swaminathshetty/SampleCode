//
//  IndividualVitalScreen.swift
//  MonitorHealth
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

@objc protocol delegateNew{
    func moveToSearchingScreen()
    func removeSearchingScreen()
    func moveToObjectiveCScreens()
    func moveToReadingPopUpScreen()
    func removeReadingPopupScreen()
    func moveToBreathAlyserScreen()
    func removeBreathAlyserScreen()
    func removeAllHelpScreens()
}

class IndividualVitalScreen: UIViewController {
    //weak var delegate: delegateNew?
    
    var searchingVC:SearchingClass?
    var bleClasses:TabBarRootViewController1?
    var readingPopUpClass:ReadingPopUpClass?
    var dashboardClass:AllVitalsDashboardScreen?
   // var breathAlyserCass:MainScreen?//BreathAlyzerClass
    var breathAlyserCass:BreathAlyzerClass?
    var breathAlyserHelpClass:BreathAlyserHelp?
    var bpHelpscreen:BPHelp?
    

    var pulseReadingValue = String()
    var spo2ReadingValue = String()
    var postParameters = [String:Any]()

    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var lexiconLogoBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var headerLineView: UIView!
    
    @IBOutlet weak var getMyReeadingLblTopCons: NSLayoutConstraint!
    @IBOutlet weak var vitalLogoTopSpaceCons: NSLayoutConstraint!
    @IBOutlet weak var myLastReadinglblTopCons: NSLayoutConstraint!
    @IBOutlet weak var datelblTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stackViewBg: UIStackView!
    var unitsStr: String = ""
    var VitalValue:String = ""
    @IBOutlet weak var getMyReadingsBtn: UIButton!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var vitallogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vitalLogoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_MyReadingInnerView: UIView!
    @IBOutlet weak var view_MyReadingOuterView: UIView!
    @IBOutlet weak var view_MyReadingBg: UIView!
    @IBOutlet weak var label_DeviceName: UILabel!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var label_VitalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var label_VitalWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var label_Value: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_MyReadingBg.isHidden = true
        self.view_MyReadingInnerView.isHidden = true
        self.getMyReadingsBtn.isHidden = true
        //self.lexiconLogoBtn.isHidden = true
        //self.logOutBtn.isHidden = true
        self.headerLineView.isHidden = true

        self.ParentView.alpha = 0
        self.AdjustLayout()
        
    }
    func AdjustLayout(){
        if UIScreen.main.bounds.size.height == 1024.0
        {
            self.headerViewHeightConstant.constant = 70.0
            
            self.label_VitalWidthConstraint.constant = 200.0
            self.label_VitalHeightConstraint.constant = 200.0
            
            self.myLastReadinglblTopCons.constant = 90.0
            self.datelblTopCons.constant = 45.0
            
            self.getMyReeadingLblTopCons.constant = 90
            self.vitalLogoTopSpaceCons.constant = 51
            
            self.vitallogoHeightConstraint.constant = 160.0
            self.vitalLogoWidthConstraint.constant = 160.0

        }
        else{
            
        self.headerViewHeightConstant.constant = 70.0
        
        self.label_VitalWidthConstraint.constant = 160.0
        self.label_VitalHeightConstraint.constant = 180.0
        
        self.myLastReadinglblTopCons.constant = 50.0
        self.datelblTopCons.constant = 30.0
        
        self.getMyReeadingLblTopCons.constant = 50
        self.vitalLogoTopSpaceCons.constant = 40
        
        self.vitallogoHeightConstraint.constant = 100.0
        self.vitalLogoWidthConstraint.constant = 100.0
        }
        
        print("Get image path : \(UserDefaults.standard.object(forKey: "VitalImage") as! String)")
        self.getMyReadingsBtn.setBackgroundImage(UIImage(named: UserDefaults.standard.object(forKey: "VitalImage") as! String), for: .normal)
        self.label_DeviceName.text = UserDefaults.standard.object(forKey: "VitalName") as? String
       // self.label_Value.text = UserDefaults.standard.object(forKey: "vitalValue") as? String
        let FetchedVital = (UserDefaults.standard.object(forKey: "vitalValue") as? String)!
        unitsStr =  getVitalUnits(vitalname: self.label_DeviceName.text!)
        self.VitalValue = FetchedVital + " " + unitsStr
        let font = UIFont(name: "HelveticaNeue-Bold", size: 22)!
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 40)!
        if FetchedVital == "No Data"{
            self.label_Value.text = FetchedVital
            self.label_date.isHidden = true
        }else{
            label_Value.attributedText = VitalValue.withBoldText(
                boldPartsOfString: [FetchedVital as NSString], font: font, boldFont: boldFont)
            self.label_Value.text = self.VitalValue
            self.label_date.isHidden = false
        }
        
        //date
        let dateValue = (UserDefaults.standard.object(forKey: "vitalDate") as? String)!
        self.label_date.text = "taken on \(dateValue)"
        
        //VitalBgColor
        
        self.view_MyReadingBg.layer.cornerRadius =  10.0
        self.view_MyReadingBg.backgroundColor = UIColor(rgb: UserDefaults.standard.object(forKey: "VitalBgColor") as! Int)
        self.view_MyReadingInnerView.layer.cornerRadius = 10.0
        self.view_MyReadingInnerView.layer.borderWidth = 2;
        self.view_MyReadingInnerView.layer.borderColor = UIColor(red: 7/255, green: 50/255, blue: 136/255, alpha: 1.0).cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.ViewAction))
        self.view_MyReadingInnerView.addGestureRecognizer(gesture)
        
    }
    @objc func ViewAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("view clicked")
       
        moveToSearchingScreen()
       
    }
    @IBAction func action_GetMyReadings(_ sender: Any) {
        moveToSearchingScreen()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.transition(with: headerLineView, duration: 0.5, options: [.curveEaseIn], animations: {
            self.headerLineView.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: view_MyReadingInnerView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view_MyReadingInnerView.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: view_MyReadingBg, duration: 0.8, options: [.transitionFlipFromTop], animations: {
            self.view_MyReadingBg.isHidden = false
        }, completion: nil)

        UIView.transition(with: getMyReadingsBtn, duration: 1.0, options: [.transitionFlipFromBottom], animations: {
            self.getMyReadingsBtn.isHidden = false
        }, completion: nil)


        let isNavigation = UserDefaults.standard.object(forKey: "NAVIGATION") as! String?
        if isNavigation == "FROMOBJC" {

        if var deviceReadingValue = UserDefaults.standard.object(forKey: "DeviceReadingValue") as! String?{
            print("deviceReadingValue : \(deviceReadingValue)")
            if deviceReadingValue.characters.count > 0 {
                if deviceReadingValue == "NotProperDevice" {
                    
                    let selectedVitalName = UserDefaults.standard.object(forKey: "GRXSelectedVital") as? String

                    let alert = UIAlertController(title: "Message", message: "Please Switch On \(selectedVitalName!) Device and try again.", preferredStyle: UIAlertController.Style.alert)
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
                            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                                //Pop Up
                                self.moveToReadingPopUpScreen()
                            })
                        }
                    }
                }
            }
        }
        else{
            print("deviceReadingValue : Optional Null")
        }
        }
    }
    func getVitalUnits(vitalname:String) -> String {
        switch vitalname {
        case "BloodPressure":
            unitsStr = "mmHg"
            return unitsStr
        case "Breathalyzer":
            unitsStr = "g/dL"
            return unitsStr
        case "HeartRate":
            unitsStr = "bpm"
            return unitsStr
        case "PulseOximeter":
            unitsStr = "%"
            return unitsStr
        case "Temperature":
            unitsStr = "°F"
            return unitsStr
        case "Weight":
            unitsStr = "Kgs"
            return unitsStr
        default:
            unitsStr = ""
            return unitsStr
        }
       
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func action_LogoBtn(_ sender: Any) {
    }
    @IBAction func action_LogoutBtn(_ sender: Any) {
        print("Navigate to help screen")
        removeAllScreen()
        bpHelpscreen = storyboard?.instantiateViewController(withIdentifier: "BPHelp") as? BPHelp
        self.addChild(bpHelpscreen!)
        bpHelpscreen?.delegate = self
        bpHelpscreen?.view.frame = self.view.bounds
        self.ParentView.addSubview((bpHelpscreen?.view)!)
        bpHelpscreen?.didMove(toParent: self)
    }
    func removeAllScreen() {
        self.ParentView.alpha = 1.0
        self.stackViewBg.alpha = 0.2
        self.headerView.alpha = 0.2
        
        searchingVC?.willMove(toParent: nil)
        searchingVC?.view.removeFromSuperview()
        searchingVC?.removeFromParent()
        
        readingPopUpClass?.willMove(toParent: nil)
        readingPopUpClass?.view.removeFromSuperview()
        readingPopUpClass?.removeFromParent()
        
        breathAlyserCass?.willMove(toParent: nil)
        breathAlyserCass?.view.removeFromSuperview()
        breathAlyserCass?.removeFromParent()
        
        breathAlyserHelpClass?.willMove(toParent: nil)
        breathAlyserHelpClass?.view.removeFromSuperview()
        breathAlyserHelpClass?.removeFromParent()

    }

}
extension IndividualVitalScreen: delegateNew {
    func moveToSearchingScreen() {
        print("moveToSearchingScreen funct called")
        removeAllScreen()
        searchingVC = storyboard?.instantiateViewController(withIdentifier: "SearchingClass") as? SearchingClass
        self.addChild(searchingVC!)
        searchingVC?.delegate = self
        searchingVC?.view.frame = self.view.bounds
        self.ParentView.addSubview((searchingVC?.view)!)
        searchingVC?.didMove(toParent: self)
    }
    func removeSearchingScreen()
    {
        print("removeSearchingScreen funct called")
        removeAllScreen()
        self.ParentView.alpha = 0
        self.stackViewBg.alpha = 1.0
        self.headerView.alpha = 1.0
    }
    func moveToObjectiveCScreens()
    {
        print("moveToObjectiveCScreens funct called")
        removeSearchingScreen()
        DispatchQueue.main.async {
            self.bleClasses = TabBarRootViewController1(nibName: "TabBarRootViewController1",bundle: nil)
            self.present( self.bleClasses!, animated: false, completion: nil)
        }
    }
    func moveToReadingPopUpScreen()
    {
        print("moveToSearchingScreen funct called")
        removeAllScreen()
        readingPopUpClass = storyboard?.instantiateViewController(withIdentifier: "ReadingPopUpClass") as? ReadingPopUpClass
        self.addChild(readingPopUpClass!)
        readingPopUpClass?.delegate = self
        readingPopUpClass?.view.frame = self.view.bounds
        self.ParentView.addSubview((readingPopUpClass?.view)!)
        readingPopUpClass?.didMove(toParent: self)
    }
    func removeReadingPopupScreen()
    {
        removeSearchingScreen()
        DispatchQueue.main.async {
            self.dashboardClass = self.storyboard?.instantiateViewController(withIdentifier: "AllVitalsDashboardScreen") as? AllVitalsDashboardScreen
            self.present( self.dashboardClass!, animated: true, completion: nil)
        }
    }
    func moveToBreathAlyserScreen()
    {
        print("moveToBreathAlyserScreen funct called")
        removeAllScreen()
        breathAlyserCass = storyboard?.instantiateViewController(withIdentifier: "BreathAlyzerClass") as? BreathAlyzerClass
        self.addChild(breathAlyserCass!)
        breathAlyserCass?.delegate = self
        breathAlyserCass?.view.frame = self.view.bounds
        self.ParentView.addSubview((breathAlyserCass?.view)!)
        breathAlyserCass?.didMove(toParent: self)
    }
    func removeBreathAlyserScreen()
    {
        print("removeBreathAlyserScreen funct called")
        removeAllScreen()
        self.ParentView.alpha = 0
        self.stackViewBg.alpha = 1.0
        self.headerView.alpha = 1.0
    }
    func removeAllHelpScreens()
    {
        print("removeBreathAlyserHelpScreen funct called")
        removeAllScreen()
        self.ParentView.alpha = 0
        self.stackViewBg.alpha = 1.0
        self.headerView.alpha = 1.0
    }

}
extension String {
    func withBoldText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}

