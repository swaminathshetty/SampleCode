//
//  MeterController.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "MeterController.h"
#import "DataDefinition.h"
#import <Foundation/NSNotification.h>
#import "TDUtility.h"
#import "MeterEventArgs.h"


BOOL isWaiting = nil;
NSTimer *measuringTimer = nil;

@implementation MeterController
@synthesize meterType;
@synthesize longCommanddata;
@synthesize meterStatus;

- (id)init
{
    self = [super init];
    if (self) {
        _totalBytesRead = 0;
        
        meterCommand = [[MeterCommand alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_blesessionDataReceived:) name:BleSessionDataReceivedNotification object:nil];
        
        self.meterStatus = E_Meter_Idle;
    }
    
    return self;
}

- (BOOL) openSession
{
    
    if (meterType == 0) {
        return [[EASessionController sharedController] openSession];
    }else{
        return [[BleSessionController sharedController] openbleSession];
    }
}

- (void) closeSession
{
    if (meterType == 0) {
        [[EASessionController sharedController] closeSession];
        [[EASessionController sharedController] setupControllerForAccessory:nil withProtocolString:nil];
    }
    else
    {
        [[BleSessionController sharedController] closebleSession];
    }
}

- (BOOL) openSessionWithIdentifier: (NSString *)bleIdenfier
{
    if (meterType == 0) {
        return [[EASessionController sharedController] openSession];
    }else{
        return [[BleSessionController sharedController] openSessionWithIdentifier:bleIdenfier];
    }
}

- (E_MeterStatus) getCurrentStatus
{
    return self.meterStatus;
}

- (BOOL) getFirmwareVersion
{
    unsigned char pCmd[8];
    self.meterStatus = E_GetFirmwareVersion;
    
    [[meterCommand getRequestFirmwareVersionCMD] getBytes:pCmd length:8];

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [NSData dataWithBytes:pCmd length:8] Length:7];
    
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    return true;
}

- (BOOL) getProjectCode
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_GetProjectCode;
    
    [[meterCommand getRequestProjectCodeCMD] getBytes:pCmd length:8];

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [meterCommand getRequestProjectCodeCMD] Length:7];
    
    /* sent command */
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    /* Wait response */
    return true;
}

- (BOOL) getSerialNumber1
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_GetSerialNumber1;
    
    [[meterCommand getRequestSerialNumber1CMD] getBytes:pCmd length:8];

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [meterCommand getRequestSerialNumber1CMD] Length:7];
    
    /* sent command */
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    
    /* Wait response */
    return true;
}

- (BOOL) getSerialNumber2
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_GetSerialNumber2;
    
    [[meterCommand getRequestSerialNumber2CMD] getBytes:pCmd length:8];

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [meterCommand getRequestSerialNumber2CMD] Length:7];
    
    /* sent command */
    
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    /* Wait response */
    return true;
}

- (BOOL) getRecordsNumberForUserNo:(int)user
{
    unsigned char pCmd[8];
    //uint32_t timeCount = 0;
    self.meterStatus = E_Meter_GetRecordNumber;
    
    [[meterCommand getRequestRecordNumberCMD] getBytes:pCmd length:8];
    
    pCmd[2] = (unsigned char) user;

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [NSData dataWithBytes:pCmd length:8] Length:7];
    
    /* sent command */
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    /* Wait response */
    return true;
}

- (BOOL) getRecord1:(int) recIndex UserNo:(int) user
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_GetRecord1;
    
    [[meterCommand getRequestRecord1CMD] getBytes:pCmd length:8];
    
    pCmd[2] = (unsigned char) (recIndex & 0xff);
    pCmd[3] = (unsigned char) ((recIndex & 0xff00) >> 8);
    pCmd[5] = (unsigned char) user;
    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [NSData dataWithBytes:pCmd length:8] Length:7];
    
    /* sent command */
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    /* Wait response */
    return true;
}

- (BOOL) getRecord2:(int) recIndex UserNo:(int) user
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_GetRecord2;
    
    [[meterCommand getRequestRecord2CMD] getBytes:pCmd length:8];
    
    pCmd[2] = (unsigned char) (recIndex & 0xff);
    pCmd[3] = (unsigned char) ((recIndex & 0xff00) >> 8);
    pCmd[5] = (unsigned char) user;

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [NSData dataWithBytes:pCmd length:8] Length:7];
    
    /* sent command */
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    
    /* Wait response */
    return true;
}

- (BOOL) powerOffMeter
{
    unsigned char pCmd[8];
    
    [[meterCommand getRequestPowerOffCMD] getBytes:pCmd length:8];

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [meterCommand getRequestPowerOffCMD] Length:7];
    
    /* sent command */
    
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    /* Wait response */
    return true;
}



- (BOOL) setDateTime
{
    unsigned char pCmd[8];
    self.meterStatus = E_Meter_SetDateTime;
    
    [[meterCommand setDateTimeCMD] getBytes:pCmd length:8];
    
    /* Get Date */
    NSInteger mYear, mMonth, mDay, mHour, mMin;
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
    
    mYear = [comps year];
    mMonth = [comps month];
    mDay = [comps day];
    mHour = [comps hour];
    mMin = [comps minute];
    
    pCmd[2] = (unsigned char) (mMonth * 0x20) + mDay;//month + day
    if (mMonth > 7) {
        pCmd[3] = (unsigned char) ((mYear - 2000) * 0x2) + 1; //year + month
    }else{
        pCmd[3] = (unsigned char) ((mYear - 2000) * 0x2);
    }
    
    pCmd[4] = (unsigned char) mMin;//min
    pCmd[5] = (unsigned char) mHour;//min

    pCmd[7] = (unsigned char) [TDUtility calculateCheckSum:(NSData *) [NSData dataWithBytes:pCmd length:8] Length:7];
    
    /* sent command */
    
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:8] autorelease]];
    }
    /* Wait response */
    return true;
}

- (BOOL) readWSMeasureValue:(int) iIndex
{
    if(longCommanddata!=nil)
    {
        [longCommanddata release];
        longCommanddata =[[NSMutableData alloc] init];
    }
    else
    {
        longCommanddata =[[NSMutableData alloc] init];
    }
    
    unsigned char pCmd[7];
    self.meterStatus = E_Meter_ReadWSMeasureValue;
    
    [[meterCommand getRequestWSReadMeasureValueCMD] getBytes:pCmd length:7];
    
    int iLo = 0;
    int iHi=0;
    if(iIndex>0xff)
    {
        iLo =  iIndex & 0xff;
        iHi = iIndex >>8;
    }
    else
    {
        iLo =  iIndex;
    }
    
    pCmd[3] = iLo;
    pCmd[4] = iHi;
    
    NSData *data = [NSData dataWithBytes:pCmd length:7];

    pCmd[6] = (unsigned char) [TDUtility calculateCheckSum:(NSData *)data Length:6];
    
    NSString *tmpStr=@"";
    
    for(int i=0;i<7;++i)
    {
        tmpStr = [tmpStr stringByAppendingFormat:@"%X",pCmd[i]];
        //NSLog(@"tmpStr : %@",tmpStr);
    }
    
    if (meterType == 0) {
        /* sent command */
        [[EASessionController sharedController] writeData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:7] autorelease]];
    }else{
        /* sent command */
        [[BleSessionController sharedController] writebleData:[[[NSData alloc] initWithBytes:(const void *) pCmd length:7] autorelease]];
    }
    
    
    return true;
}

- (void) doResponse:(NSData *) recData
{
    
    unsigned char *pRecviceData = (unsigned char *) [recData bytes];
    
    
    /////// For WS
    NSData *d1 = [recData subdataWithRange:NSMakeRange(0, recData.length)];
    unsigned char *pRecviceData1 = (unsigned char *) [d1 bytes];
    
    bool bTEST=false;
    bTEST =pRecviceData1[ recData.length-2] == 0xa5?true:false;
    Byte bTest=0x0;
    bTest = pRecviceData1[ recData.length-1];

    bTest = [TDUtility calculateCheckSum:recData Length: (int)recData.length-1 ];
    
    if (pRecviceData1[ recData.length-2] == 0xa5 && pRecviceData1[recData.length-1] == [TDUtility calculateCheckSum:recData Length: (int)recData.length-1 ])
    {
        switch (self.meterStatus) {
            case E_Meter_ReadWSMeasureValue://get WS Result
            {
                self.meterStatus = E_Meter_Idle;
                TDWSData *args = [[TDWSData alloc] autorelease];
                [self convertWsResut:pRecviceData :args];
                [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_ReadWSValue object:args userInfo:nil];
                break;
            }
                
            default:
                break;
        }
    }
    
    if (pRecviceData[6] == 0xa5 && pRecviceData[7] == [TDUtility calculateCheckSum:recData Length:7])
    {
        int iTEST=-1;
        iTEST=self.meterStatus;
        
        if(pRecviceData[1] == 0x24)
            self.meterStatus =E_Meter_GetProjectCode;
        else if(pRecviceData[1] == 0x28)
            self.meterStatus = E_Meter_GetSerialNumber1;
        else if(pRecviceData[1] == 0x27)
            self.meterStatus = E_Meter_GetSerialNumber2;
        else if(pRecviceData[1] == 0x2B)
            self.meterStatus =E_Meter_GetRecordNumber ;
        else if(pRecviceData[1] == 0x25)
            self.meterStatus = E_Meter_GetRecord1;
        else if(pRecviceData[1] == 0x26)
            self.meterStatus = E_Meter_GetRecord2;
        else if(pRecviceData[1] == 0x33)
            self.meterStatus =E_Meter_SetDateTime ;
        else if(pRecviceData[1] == 0x47)
            self.meterStatus = E_Meter_GetWaveform;
        else if(pRecviceData[1] == 0x54)
            self.meterStatus = E_Meter_EnteringCommnunicationMode ;
        
        
        switch (self.meterStatus) {
            case E_Meter_GetProjectCode:
                if (pRecviceData[1] == 0x24)
                {
                    ProjectInfoEventArgs *args = [[ProjectInfoEventArgs alloc] autorelease];
                    
                    self.meterStatus = E_Meter_Idle;
                    
                    args.projectNo = [NSString stringWithFormat:@"%02x%02x",pRecviceData[3], pRecviceData[2]];
                    args.subModel = [NSString stringWithFormat:@"%c", pRecviceData[4]];
                    args.userNumber = pRecviceData[5];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_ProjectCode object:args userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_GetSerialNumber1:
                if (pRecviceData[1] == 0x28)
                {
                    self.meterStatus = E_Meter_Idle;
                    
                    NSString *tmpStr = [NSString stringWithFormat:@"%02x%02x%02x%02x",
                                        pRecviceData[5], pRecviceData[4], pRecviceData[3], pRecviceData[2]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_SerialNumber1 object:tmpStr userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_GetSerialNumber2:
                if (pRecviceData[1] == 0x27)
                {
                    self.meterStatus = E_Meter_Idle;
                    
                    NSString *tmpStr = [NSString stringWithFormat:@"%02x%02x%02x%02x",
                                        pRecviceData[5], pRecviceData[4], pRecviceData[3], pRecviceData[2]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_SerialNumber2 object:tmpStr userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_GetRecordNumber:
                if (pRecviceData[1] == 0x2B)
                {
                    self.meterStatus = E_Meter_Idle;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_RecordNumber object:recData userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_GetRecord1:
                if (pRecviceData[1] == 0x25)
                {
                    self.meterStatus = E_Meter_Idle;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_Record1 object:recData
                                                                      userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_GetRecord2:
                if (pRecviceData[1] == 0x26)
                {
                    
                    self.meterStatus = E_Meter_Idle;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_Record2 object:recData
                                                                      userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_SetDateTime:
                if (pRecviceData[1] == 0x33)
                {
                    self.meterStatus = E_Meter_Idle;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_DateTime object:recData
                                                                      userInfo:nil];
                }
                else
                {
                }
                break;
                
            case E_Meter_ReadWSMeasureValue://get WS Result
            {
                self.meterStatus = E_Meter_Idle;
                TDWSData *args = [[TDWSData alloc] autorelease];
                [self convertWsResut:pRecviceData :args];
                [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_ReadWSValue object:args userInfo:nil];
                break;
            }
                
            case E_Meter_GetWaveform :
                self.meterStatus = E_Meter_Idle;
                if(measuringTimer == nil) {
                    retryCounter = 0;
                    measuringTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeout4EnteringCommunicationCmd:) userInfo:nil repeats:NO];
                }
                isWaiting = YES;
                
                break;
            case E_Meter_EnteringCommnunicationMode :
                
                [measuringTimer invalidate];
                measuringTimer = nil;
                
                self.meterStatus = E_Meter_Idle;
                if(!isImportingOBJC)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Switch2ImportView" object:nil userInfo:nil];
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        
    }
    
}

-(void) timeout4EnteringCommunicationCmd: (NSTimer *)theTimer {
    if(retryCounter < 25)   {
        
        measuringTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeout4EnteringCommunicationCmd:) userInfo:nil repeats:NO];
        if([BleSessionController sharedController].discoveredPeripheral.state != CBPeripheralStateConnected  )  {
            retryCounter = 25;
        }
        else  {
            retryCounter++;
        }
        
    }
    
    if (retryCounter >= 25) {
        [measuringTimer invalidate];
        measuringTimer = nil;
        isWaiting = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:MeterNotification_ShowError object:nil userInfo:nil];
    }
}

- (void) _sessionDataReceived: (NSNotification *) notification
{
    EASessionController *sessionController = (EASessionController *) [notification object];
    
    NSUInteger bytesAvailable = 0;
    _totalBytesRead = 0;
    NSData *data;
    
    while ((bytesAvailable = [sessionController readBytesAvailable]) > 0) {
        data = [sessionController readData:bytesAvailable];
        
        if (data) {
            _totalBytesRead += bytesAvailable;
        }
    }
    
    if (_totalBytesRead >= 8)
        [self doResponse:data];
}

- (void) convertWsResut:(unsigned char*) temp :(TDWSResult *) tempresult;
{
    @try
    {
        tempresult.iYerar = (int)temp[4]+2000;
        tempresult.iMonth = temp[5];
        tempresult.iDay = temp[6];
        tempresult.iHour = temp[7];
        tempresult.iMinute = temp[8];
        tempresult.iCode = temp[9];
        Byte gendervaule = temp[10];
        switch(gendervaule)
        {
            case 0:
                tempresult.pWSGenderType= Female;
                break;
            case 1:
                tempresult.pWSGenderType=Male;
                break;
            default:
                tempresult.pWSGenderType= NotDefined;
                break;
        }
        
        tempresult.iHeight = temp[11];
        tempresult.iAge = temp[14];
        tempresult.dWeight = ((double)(temp[16]<<8)+temp[17])/10;
        tempresult.dMachineBmi = ((double)(temp[20]<<8)+temp[21])/10;
        tempresult.dCaledBmi = 0;
        //Swami
        //NSLog(@"dWeight : %f",tempresult.dWeight);
        
        tempresult.CreateDate = [TDUtility convertNsdateFromIntegerYear:tempresult.iYerar Month:tempresult.iMonth Day:tempresult.iDay Hour:tempresult.iHour Minute:tempresult.iMinute Second:0];
        NSDate *TESTDATE;
        TESTDATE = tempresult.CreateDate ;
    }
    @catch (NSException *exception)
    {
        
    }
}

- (void) _blesessionDataReceived: (NSNotification *) notification
{
    BleSessionController *blesessionController = (BleSessionController *) [notification object];
    
    _totalBytesRead = 0;
    
    NSData *data = [[NSData alloc] init];
    
    
    if (meterType == 1)
    {
        if( self.meterStatus == E_Meter_ReadWSMeasureValue) //is long command
        {
            if( self.meterStatus == E_Meter_ReadWSMeasureValue) //is long command
            {
                [longCommanddata appendData:blesessionController.data];
                NSInteger longCommandResponse = longCommanddata.length;
                if(longCommandResponse>=2)
                {
                    if(longCommandResponse==34) //only for 71 command, Check bCurrent...
                    {
                        [self doResponse:longCommanddata];
                    }
                }
            }
        }
        else //8 bytes command
        {
            
            if(longCommanddata!=nil)
            {
                [longCommanddata release];
                longCommanddata =[[NSMutableData alloc] init];
            }
            else
            {
                longCommanddata =[[NSMutableData alloc] init];
            }
            
            
            data = blesessionController.data;
            if (data != nil) {
                _totalBytesRead += data.length;
            }
            
            if (_totalBytesRead >= 8)
                [self doResponse:data];
        }
        
    }
}


- (void)dealloc
{
    [super dealloc];
    //SwamiN
    //self.meterStatus = E_Meter_Idle;

    [NSThread sleepForTimeInterval:0.25];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EADSessionDataReceivedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleSessionDataReceivedNotification object:nil];
    
    
}

-(void) removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EADSessionDataReceivedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleSessionDataReceivedNotification object:nil];
    
}


@end
