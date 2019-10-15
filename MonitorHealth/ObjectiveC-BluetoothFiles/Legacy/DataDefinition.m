//
//  DataDefinition.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "DataDefinition.h"
#import "TDUtility.h"

@implementation TDRecordData

@synthesize indexID, mType, value1, value2, value3, value4, value5, value6, meterUID, rawData, timePeriod, uploadStatus, AVG;

- (void) dealloc
{
    [rawData release];
    [super dealloc];
}

@end

@implementation TDGlucoseData

@synthesize indexID, inputDate, rawData, type, machineOrgType, timePeriod, value, upload, meterUID, DontSave, userNO;

- (void) dealloc
{
    [rawData release];
    [super dealloc];
}

@end

@implementation TDBPData

@synthesize indexID, inputDate, rawData, systolic, diastolic, pulse, upload, meterUID, type, ihb, avg, userNO;

- (void) dealloc
{
    [rawData release];
    [super dealloc];
}

@end

@implementation TDTPData

@synthesize indexID, inputDate, rawData, value, upload, meterUID, userNO;

- (void) dealloc
{
    [rawData release];
    [super dealloc];
}

@end

@implementation TDSOData

@synthesize indexID, inputDate, rawData, spo2Value, pulse, upload, meterUID, userNO;

- (void) dealloc
{
    [rawData release];
    [super dealloc];
}

@end


BOOL isImportingOBJC = nil;

@implementation TDSettingData
@synthesize lang,
deviceSerialNumber, bgmACSafeL,bgmACSafeH,bgmPCSafeL,bgmPCSafeH,bgmGENSafeL,bgmGENSafeH,bpmSYSSafeL,bpmSYSSafeH,bpmDIASafeL,bpmDIASafeH,wsSafeH,  tempH, tempL, spo2;


- (void) dealloc
{
    [lang release];
    [deviceSerialNumber release];
    
    [super dealloc];
}
@end


@implementation TDMeterProfile

@synthesize _id, deviceId, deviceType, deviceMacAddress, lastImport, userNO;

- (void) dealloc
{
    //SWAMI COMMENTING
    [deviceType release];
    //[deviceId release];
    //[deviceMacAddress release];
    //[lastImport release];
    
    
    [super dealloc];
}

@end


@implementation TD_Check_Glu_HI_LOW

+(NSString*)  Get_GluValue_DISPLAY:(CGFloat)iGluvalue valueType:(TDSettingData*)pSettingData;
{
    
    if(iGluvalue>GLUCOSE_VALUE_MAX_HI)
    {
        return GLUCOSE_VALUE_MAX_HI_DISPLAY;
    }
    if(iGluvalue<GLUCOSE_VALUE_MIN_LOW)
    {
        return GLUCOSE_VALUE_MIN_LOW_DISPLAY;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *strValue;
    
    
    [formatter setMinimumFractionDigits:0];
    strValue = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithDouble:iGluvalue]]];
    
    [formatter release];
    
    return strValue;
}

@end

@implementation TD_check_Tmp_HI_LOW

+(NSString*)  Get_TmpValue_HI_LO_DISPLAY:(CGFloat)iTmpvalue valueType:(TDSettingData*)pSettingData;
{
    NSString *strValue;
    
    strValue = [NSString stringWithFormat:@"%.1f",iTmpvalue];
    
    return strValue;
}

@end

@implementation TDWSResult

@synthesize iYerar;
@synthesize iMonth  ;
@synthesize iDay  ;
@synthesize iHour  ;
@synthesize iMinute ;
@synthesize iCode ;
@synthesize pWSGenderType ;
@synthesize iHeight ;
@synthesize iAge ;
@synthesize dWeight ;
@synthesize dMachineBmi ;
@synthesize dCaledBmi ;
@synthesize CreateDate;
@synthesize dBodyFat;
@synthesize dBodyWater;
@synthesize dMuscle;
@synthesize dBone;
@synthesize dBMR;
@synthesize iMeterUserNo;

- (void) dealloc
{
    if(CreateDate)
    {
        [CreateDate release];
        CreateDate=nil;
    }
    [super dealloc];
}

@end

@implementation TDWSData

@synthesize indexID;
@synthesize inputDate;
@synthesize rawData;
@synthesize upload;
@synthesize meterUID;

- (void) dealloc
{
    if(rawData)
    {
        [rawData release];
        rawData=nil;
    }
    
    [super dealloc];
}

@end
