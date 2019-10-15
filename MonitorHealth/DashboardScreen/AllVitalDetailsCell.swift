//
//  AllVitalDetailsCell.swift
//  MonitorHealth
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

class AllVitalDetailsCell: UITableViewCell {

    @IBOutlet weak var view_Bg: UIView!
    @IBOutlet weak var label_VitalName: UILabel!
    @IBOutlet weak var imageView_VitalImage: UIImageView!
    @IBOutlet weak var label_Value: UILabel!
    @IBOutlet weak var label_DateAndTime: UILabel!
    
    @IBOutlet weak var cellBgWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cellLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellLogoHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cellValueWidthCon: NSLayoutConstraint!
    @IBOutlet weak var cellValueLeadCon: NSLayoutConstraint!
    @IBOutlet weak var cellDateTrailCon: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellBgWidthConstraint.constant = 180
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellContent(content:vitalInfo)  {
        self.label_VitalName.text = content.HealthVitalType
        self.label_Value.text = content.Vital1
        
    }

}
