//
//  MeterController.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeterCommand.h"
#import "EASessionController.h"
#import "BleSessionController.h"

extern BOOL isWaiting;
extern NSTimer *measuringTimer;

typedef enum
{
    E_Meter_None=0,
    E_Meter_GetProjectCode=1,
    E_Meter_GetRecordNumber=2,
    E_Meter_GetSerialNumber1=3,
    E_Meter_GetSerialNumber2=4,
    E_Meter_GetRecord1=5,
    E_Meter_GetRecord2=6,
    E_Meter_PowerOff=7,
    E_Meter_SetDateTime=8,
    E_Meter_Idle=9,
    E_GetFirmwareVersion=10,
    E_Meter_ReadWSMeasureValue=11,
    E_Meter_GetWaveform=12,
    E_Meter_EnteringCommnunicationMode=13
} E_MeterStatus;


@interface MeterController : NSObject {
    MeterCommand *meterCommand;
    uint32_t _totalBytesRead;
    
    int retryCounter;
}

@property (nonatomic, readwrite) int meterType;
@property (nonatomic, retain) NSMutableData *longCommanddata;
@property (nonatomic, readwrite) int meterStatus;


- (BOOL) openSession;
- (void) closeSession;
- (BOOL) getProjectCode;
- (BOOL) getSerialNumber1;
- (BOOL) getSerialNumber2;
- (BOOL) getRecordsNumberForUserNo:(int)user;
- (BOOL) getRecord1:(int) recIndex UserNo:(int) user;
- (BOOL) getRecord2:(int) recIndex UserNo:(int) user;
- (BOOL) powerOffMeter;
- (BOOL) setDateTime;
- (BOOL) readWSMeasureValue:(int) iIndex;
- (BOOL) getFirmwareVersion;
- (void) removeNotify;

@end
