//
//  MeterCommand.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDefinition.h"

extern NSString *MeterNotification_ProjectCode;
extern NSString *MeterNotification_RecordNumber;
extern NSString *MeterNotification_Record1;
extern NSString *MeterNotification_Record2;
extern NSString *MeterNotification_SerialNumber1;
extern NSString *MeterNotification_SerialNumber2;
extern NSString *MeterNotification_PowerOff;
extern NSString *MeterNotification_Error;
extern NSString *MeterNotification_DateTime;
extern NSString *MeterNotification_ReadWSValue;
extern NSString *TaidocNotification_GetFirmwareVersion;
extern NSString *MeterNotification_ShowError;

@interface MeterCommand : NSObject {
    
}
@property (nonatomic, retain) TDSettingData *settingData;

-(void) getSettingData;
- (NSData *) getRequestProjectCodeCMD;
- (NSData *) getRequestSerialNumber1CMD;
- (NSData *) getRequestSerialNumber2CMD;
- (NSData *) getRequestRecordNumberCMD;
- (NSData *) getRequestRecord1CMD;
- (NSData *) getRequestRecord2CMD;
- (NSData *) getRequestPowerOffCMD;
- (NSData *) setDateTimeCMD;
- (NSData *) getRequestWSReadMeasureValueCMD;
- (NSData *) getRequestFirmwareVersionCMD;

@end
