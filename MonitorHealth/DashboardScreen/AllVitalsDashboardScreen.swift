//
//  AllVitalsDashboardScreen.swift
//  MonitorHealth
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,   
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class AllVitalsDashboardScreen: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var celldata = [vitalInfo]()
    @IBOutlet weak var label_LoginName: UILabel!
    @IBOutlet weak var tableView_VitalDetails: UITableView!
    @IBOutlet weak var headerViewHeightContraint: NSLayoutConstraint!
    var getvitalResponse = [vitalInfo]()
    var ActivityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

    @IBOutlet weak var lexiconLogo: UIImageView!
    //  var array_VitalNames = ["Breathalyzer","BloodPressure","Temperature","PulseOximeter","HeartRate","Weight"]
    //var array_VitalImages = ["BreathalyzerLogo","BPLogo","TempLogo","SPO2Logo","HeartRateLogo","WeightLogo"]
   var array_VitalNames = [String]()
    var array_VitalBg = [0x6A0F49,0xDC143C,0xE6C229,0xF17105,0x71B340,0x355691]
    var array_VitalValue = [String]()
    var array_VitalDateAndTime = [String]()
    var unitsDisplay = String()
    //SwamiN
    //var isViewLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let getPatientID = UserDefaults.standard.object(forKey: "PatientID") as! Int
        let loginName = UserDefaults.standard.object(forKey: "loginName") as! String?
        self.label_LoginName.text = loginName
        UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
        UserDefaults.standard.synchronize()
        //self.tableView_VitalDetails.isHidden = true
        self.headerViewHeightContraint.constant = 70.0
        if UIScreen.main.bounds.size.height == 1024.0
        {
            self.tableView_VitalDetails.rowHeight = 190
        }
        else{
            self.tableView_VitalDetails.rowHeight = 160
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        lexiconLogo.isUserInteractionEnabled = true
        lexiconLogo.addGestureRecognizer(tapGestureRecognizer)

        self.getVitalReadingsInfo(patientID:getPatientID)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //SwamiN
        //self.isViewLoading = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //SwamiN
        //self.isViewLoading = true
    }
    func getVitalReadingsInfo(patientID:Int){
        ActivityIndicator.color = UIColor.black
        ActivityIndicator.center = view.center
        ActivityIndicator.startAnimating()
        self.view.addSubview(ActivityIndicator)
        guard let VitalUrl = URL(string: "http://42.104.96.36:85/api/HealthMonitor/GetVitalsinfo") else {
            ActivityIndicator.stopAnimating()
            return }
        print(VitalUrl)
        let request = NSMutableURLRequest(url: VitalUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters :[String:Any] = ["PatientID":patientID]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let vitalFetchedData = try JSONDecoder().decode(vitalData.self, from: data)
                self.getvitalResponse = vitalFetchedData.message!
                print("getvitalResponse :\(self.getvitalResponse.count)")
                for info in self.getvitalResponse{
                    var vital1 = info.Vital1
                    if info.Vital1 == ""{
                        vital1 = "No Data"
                    }
                    self.array_VitalNames.append(info.HealthVitalType!)
                    self.array_VitalValue.append(vital1!)
                   self.array_VitalDateAndTime.append(info.CreatedDate!)
                }
                DispatchQueue.main.async {
                    self.tableView_VitalDetails.reloadData()
                    self.ActivityIndicator.stopAnimating()
                }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func action_Logout(_ sender: Any) {
        //SwamiN
        //self.isViewLoading = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_VitalNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AllVitalDetailsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllVitalDetailsCell
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier) as? AllVitalDetailsCell
        }
        cell?.view_Bg.backgroundColor = UIColor(rgb: array_VitalBg[indexPath.row])
        cell?.imageView_VitalImage.image = UIImage.init(named: array_VitalNames[indexPath.row])
        cell?.label_VitalName.text = array_VitalNames[indexPath.row]
        let getImageName = self.getVitalImage(vitalName: (cell?.label_VitalName.text)!)
        if array_VitalValue[indexPath.row] == "No Data"{
            unitsDisplay = ""
        }
        cell?.label_Value.text = array_VitalValue[indexPath.row] + " " + unitsDisplay
        print("cell?.label_Value.text: \(cell?.label_Value.text)")
        cell?.label_DateAndTime.text = array_VitalDateAndTime[indexPath.row]
        
        cell?.view_Bg.layer.cornerRadius =  10.0

        if UIScreen.main.bounds.size.height == 1024.0
        {
            cell?.cellBgWidthConstraint.constant = 450
            cell?.cellLogoWidthConstraint.constant = 74
            cell?.cellLogoHeightConstraint.constant = 75
            cell?.cellValueLeadCon.constant = 18
            cell?.cellDateTrailCon.constant = 18
            cell?.cellValueWidthCon.constant = 180
        }
        else{
        cell?.cellBgWidthConstraint.constant = 300
        cell?.cellLogoWidthConstraint.constant = 54
        cell?.cellLogoHeightConstraint.constant = 55
        cell?.cellValueLeadCon.constant = 15
        cell?.cellDateTrailCon.constant = 15
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("Selected IndexPath Name: \(array_VitalNames[indexPath.row])")
        let vitalname = array_VitalNames[indexPath.row]
        //if vitalname == "Breathalyzer"{
        if vitalname == "BreathalyzerTemp"{
            DispatchQueue.main.async {

            let alert = UIAlertController(title: "Breathalyzer", message: "Coming soon", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            }
            
        }else{
        let VitalImage = self.getVitalImage(vitalName: vitalname)
        print("vital Image name: \(VitalImage)")
        UserDefaults.standard.setValue(array_VitalNames[indexPath.row], forKey: "VitalName")
        UserDefaults.standard.setValue(array_VitalBg[indexPath.row], forKey: "VitalBgColor")
        UserDefaults.standard.set(array_VitalValue[indexPath.row], forKey: "vitalValue")
        UserDefaults.standard.set(array_VitalDateAndTime[indexPath.row], forKey: "vitalDate")
        UserDefaults.standard.setValue(VitalImage, forKey: "VitalImage")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            //SwamiN
            //self.isViewLoading = true
            UserDefaults.standard.setValue("FROMSWIFT", forKey: "NAVIGATION")
            UserDefaults.standard.synchronize()

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "IndividualVitalScreen") as? IndividualVitalScreen
            self.present(VC!, animated: true, completion: nil)
        }
        }
        
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Animation1
        /*let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 1.5){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }*/
        
        //Animation2
        /*cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.8, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        },completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        })*/
        
        //Animation3
        /*var rotation = CATransform3DMakeRotation( CGFloat((90.0 * M_PI)/180), 0.0, 0.7, 0.4);
        rotation.m34 = 1.0 / -600
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        cell.alpha = 0;
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        
        //3. Define the final state (After the animation) and commit the animation
        cell.layer.transform = rotation
        UIView.animate(withDuration: 0.8, animations:{cell.layer.transform = CATransform3DIdentity})
        cell.alpha = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        UIView.commitAnimations()*/
        
        //Animation4
        /*let rotationAngleInRadians = 360.0 * CGFloat(.pi/360.0)
        //let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, -500, 100, 0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})*/
        
        //Animation5
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 * Double(indexPath.row),
            options: [.curveEaseIn],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
    }
    func getVitalImage(vitalName:String) -> String {
        var vitalimgname:String = ""
        if vitalName == "Breathalyzer"{ 
            vitalimgname = "BreathalyzerLogoPink"
            unitsDisplay = "g/dL"
        }else if vitalName == "BloodPressure" {
            vitalimgname = "BpLogoRed"
            unitsDisplay = "mmHg"
        }
        else if vitalName == "Temperature" {
            vitalimgname = "TemperatureLogoYellow"
            unitsDisplay = "°F"
        }
        else if vitalName == "PulseOximeter" {
            vitalimgname = "Spo2LogoOrange"
            unitsDisplay = "%"
        }
        else if vitalName == "HeartRate" {
            vitalimgname = "HeartRateLogoGreen"
            unitsDisplay = "bpm"
        }
        else if vitalName == "Weight" {
            vitalimgname = "WeightLogoBlue"
            unitsDisplay = "Kgs"
        }
        return vitalimgname
    }
}



