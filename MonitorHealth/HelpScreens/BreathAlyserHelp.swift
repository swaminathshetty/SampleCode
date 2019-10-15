//
//  BreathAlyserHelp.swift
//  MonitorHealth
//
//  Created by Apple on 09/08/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class BreathAlyserHelp: UIViewController {

    weak var delegate: delegateNew?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_Close(_ sender: Any) {
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
