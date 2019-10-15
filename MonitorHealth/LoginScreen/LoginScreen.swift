//
//  LoginScreen.swift
//  MonitorHealth
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {

    var result:String?
    var validationMsg: String = ""
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var lexiconLogoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lexiconLogo: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    var ActivityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    var getResponse = [loginInfo]()
    
    @IBOutlet weak var textView_Data: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.main.bounds.size.height == 667.0
        {
            lexiconLogoTopConstraint.constant = 80.0
        }else{
            lexiconLogoTopConstraint.constant = 100.0
        }

        let myclr = UIColor.init(red: 124/255, green: 125/255, blue: 124/255, alpha: 1.0)
        username_txt.layer.borderColor = myclr.cgColor
        password_txt.layer.borderColor = myclr.cgColor
        username_txt.layer.cornerRadius = 10
        password_txt.layer.cornerRadius = 10
        username_txt.layer.borderWidth = 2.0
        password_txt.layer.borderWidth = 2.0
        
        self.username_txt.isHidden = true
        self.password_txt.isHidden = true
        self.lexiconLogo.isHidden = true
        self.loginBtn.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textView_Data.text = "Click the below link to view google home page https://www.google.com/ and know more"
        
        /*UIView.transition(with: lexiconLogo, duration: 0.8, options: [.transitionFlipFromTop], animations: {
            self.lexiconLogo.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: username_txt, duration: 1.0, options: [.transitionFlipFromLeft], animations: {
            self.username_txt.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: password_txt, duration: 1.0, options: [.transitionFlipFromRight], animations: {
            self.password_txt.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: loginBtn, duration: 1.5, options: [.transitionFlipFromBottom], animations: {
            self.loginBtn.isHidden = false
        }, completion: nil)*/
        
        let transitionLogo = CATransition()
        let transitionUser = CATransition()
        let transitionPwd = CATransition()
        let transitionLogin = CATransition()

        transitionLogo.duration = 1.5
        transitionUser.duration = 1.5
        transitionPwd.duration = 1.5
        transitionLogin.duration = 1.5

        transitionLogo.type = .moveIn
        transitionUser.type = .moveIn
        transitionPwd.type = .moveIn
        transitionLogin.type = .moveIn

        transitionLogo.subtype = CATransitionSubtype.fromBottom
        transitionUser.subtype = CATransitionSubtype.fromLeft
        transitionPwd.subtype = CATransitionSubtype.fromRight
        transitionLogin.subtype = CATransitionSubtype.fromTop

        transitionLogo.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transitionUser.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transitionPwd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transitionLogin.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        self.lexiconLogo.layer.add(transitionLogo, forKey: nil)
        self.username_txt.layer.add(transitionUser, forKey: nil)
        self.password_txt.layer.add(transitionPwd, forKey: nil)
        self.loginBtn.layer.add(transitionLogin, forKey: nil)

        self.lexiconLogo.isHidden = false
        self.username_txt.isHidden = false
        self.password_txt.isHidden = false
        self.loginBtn.isHidden = false

    }
    func validationResult() -> String {
        if  username_txt.text?.trimmingCharacters(in: .whitespaces) == "" || username_txt.text == ""{
            validationMsg = "Username should not be empty \n"
        }
        if  password_txt.text?.trimmingCharacters(in: .whitespaces) == "" || password_txt.text == ""{
            validationMsg += "Password should not be empty."
        }
        return validationMsg
    }
    func getLoginResponse(){
        ActivityIndicator.color = UIColor.black
        ActivityIndicator.center = view.center
        ActivityIndicator.startAnimating()
        self.view.addSubview(ActivityIndicator)

        guard let loginUrl = URL(string: "http://42.104.96.36:85/api/HealthMonitor/IsValidLogindata") else {
            ActivityIndicator.stopAnimating()
            return }
        print(loginUrl)
        let request = NSMutableURLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var userName:String = username_txt.text!
        userName = userName.trimmingCharacters(in: .whitespaces)
        var Password:String = password_txt.text!
        Password = Password.trimmingCharacters(in: .whitespaces)
        
        print("userName : \(userName)", "Password :\(Password)")
        
        let parameters :[String:String] = ["UserName":userName, "Password":Password]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.ActivityIndicator.stopAnimating()
                    self.result = "Unable to fetch information. Please try after sometime"
                    self.showAlert()
                    }
                return
            }
            do {
                let LoginFetchedData = try JSONDecoder().decode(LoginData.self, from: data)
                print("response data:", LoginFetchedData)
                if LoginFetchedData.message == "valid" || LoginFetchedData.message == "Valid"{
                    self.getResponse = LoginFetchedData.info!
                    print("getResponse :\(self.getResponse)")
                    if let patientID = self.getResponse[0].PatientID{
                        UserDefaults.standard.setValue(patientID, forKey: "PatientID")
                        UserDefaults.standard.setValue(userName, forKey: "UserName")
                        UserDefaults.standard.synchronize()
                    }

                    DispatchQueue.main.async {
                        self.ActivityIndicator.stopAnimating()
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AllVitalsDashboardScreen") as? AllVitalsDashboardScreen
                        self.present(VC!, animated: true, completion: nil)
                    }


                }else{
                    DispatchQueue.main.async {
                        self.ActivityIndicator.stopAnimating()
                        self.result = "Please check your credentials."
                        self.showAlert()
                    }
                    
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    func showAlert(){
        let alertmsg = UIAlertController(title: "Message.", message: result, preferredStyle: UIAlertController.Style.alert)
        
        alertmsg.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    {(alert :UIAlertAction!) in
            self.validationMsg = ""
            self.result = ""
        }))
        
        self.present(alertmsg, animated: true, completion: nil)
    }
    @IBAction func btnlogin(_ sender: UIButton) {
         result =  self.validationResult()
         if result == ""
         {
            let userNameString = self.username_txt.text
            UserDefaults.standard.setValue(userNameString, forKey: "loginName")
            UserDefaults.standard.synchronize()

            self.getLoginResponse()
         }
         else{
            self.showAlert()
         }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view!.endEditing(true)
    }

}
