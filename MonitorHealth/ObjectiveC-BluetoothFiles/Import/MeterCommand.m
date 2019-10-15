//
//  MeterCommand.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "MeterCommand.h"
#import "TDSettingContentProvider.h"

NSString *MeterNotification_ProjectCode = @"TDLinkMeterProjectCodeNotification";
NSString *MeterNotification_RecordNumber = @"TDLinkMeterRecordNumberNotification";
NSString *MeterNotification_Record1 = @"TDLinkMeterRecord1Notification";
NSString *MeterNotification_Record2 = @"TDLinkMeterRecord2Notification";
NSString *MeterNotification_SerialNumber1 = @"TDLinkMeterSerialNumber1Notification";
NSString *MeterNotification_SerialNumber2 = @"TDLinkMeterSerialNumber2Notification";
NSString *MeterNotification_PowerOff = @"TDLinkMeterPowerOffNotification";
NSString *MeterNotification_SerialNumber = @"TDLinkMeterSerialNumberNotification";
NSString *MeterNotification_Error = @"TDLinkMeterErrorNotification";
NSString *MeterNotification_DateTime = @"TDLinkMeterDateTimeNotification";
NSString *MeterNotification_ReadWSValue = @"TDLinkTaidocReadWSValueNotification";
NSString *TaidocNotification_GetFirmwareVersion = @"TaidocNotification_GetFirmwareVersion";

NSString *MeterNotification_ShowError = @"TDLinkTaidocShowErrorNotification";

@implementation MeterCommand
@synthesize settingData;

/* Request command */
const uint8_t cmdRequestProjectCode[] = {0x51, 0x24, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestRecordNumber[] = {0x51, 0x2B, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestRecord1[] = {0x51, 0x25, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestRecord2[] = {0x51, 0x26, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestPowerOff[] = {0x51, 0x50, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestSerialNumber1[] = {0x51, 0x28, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequestSerialNumber2[] = {0x51, 0x27, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdSetDateTime[] = {0x51, 0x33, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};
const uint8_t cmdRequsetWsReadMeasureValue[] = {0x51, 0x71, 0x2, 0x0, 0x0, 0xA3};
const uint8_t cmdSetWsProfile[] = {0x51, 0x72, 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xa3,0x0};
const uint8_t cmdgetRequestFirmwareVersionCMD[] = {0x51, 0x29, 0x0, 0x0, 0x0, 0x0, 0xa3, 0x0};



-(void) getSettingData
{
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    settingData  =[provider getSettingData];
    [provider release];
}

- (NSData *) getRequestSerialNumber1CMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestSerialNumber1 length:sizeof(cmdRequestSerialNumber1)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestSerialNumber2CMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestSerialNumber2 length:sizeof(cmdRequestSerialNumber2)] autorelease];
    
    return reqData;
}


- (NSData *) getRequestProjectCodeCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestProjectCode length:sizeof(cmdRequestProjectCode)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestFirmwareVersionCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdgetRequestFirmwareVersionCMD length:sizeof(cmdgetRequestFirmwareVersionCMD)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestRecordNumberCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestRecordNumber length:sizeof(cmdRequestRecordNumber)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestRecord1CMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestRecord1 length:sizeof(cmdRequestRecord1)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestRecord2CMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestRecord2 length:sizeof(cmdRequestRecord2)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestPowerOffCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequestPowerOff length:sizeof(cmdRequestPowerOff)] autorelease];
    
    return reqData;
}

- (NSData *) setDateTimeCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdSetDateTime length:sizeof(cmdSetDateTime)] autorelease];
    
    return reqData;
}

- (NSData *) getRequestWSReadMeasureValueCMD
{
    NSData *reqData = [[[NSData alloc] initWithBytes:(const void *) cmdRequsetWsReadMeasureValue length:sizeof(cmdRequsetWsReadMeasureValue)] autorelease];
    
    return reqData;
}

@end
