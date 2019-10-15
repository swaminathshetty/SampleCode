//
//  ModelClass.swift
//  MonitorHealth
//
//  Created by HYLPMB00015 on 19/04/19.
//  Copyright © 2019 Lexicon. All rights reserved.
//

import UIKit

struct loginInfo:Codable{
    let UserName: String?
    let Password: String?
    let PatientID: Int?
    let UserID: String?
    let PatientFirstName: String?
    let PatientLastName: String?
    let Gender: String?
    let EmailID: String?
    let MobileNo: String?
    let DateOfBirth: String?
    let Address: String?
    let State: String?
    let Country: String?
    let IsActive: Bool?
    let CreatedDate:String?
    let CreatedBy: String?
    let UpdatedDate: String?
    let UpdatedBy: String?
}

struct LoginData:Codable {
    let message:String?
    let info:[loginInfo]?
}
//vital fetching struct
struct vitalInfo:Codable {
    let RowID:String?
    let PatientID: String?
    let HealthVitalType:String?
    let Vital1:String?
    let Vital2:String?
    let CreatedDate:String?
    let CreatedBy:String?
    let UpdatedDate:String?
    let UpdatedBy:String?
}
struct vitalData:Codable {
    let message:[vitalInfo]?
}
//Vital Insertion
struct messageDict:Codable {
    let message:String?
}

