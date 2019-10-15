//
//  ImportRootController.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "ImportRootController.h"
#import "MeterEventArgs.h"
#import <Foundation/NSNotification.h>
#import "TDMeterProfileContentProvider.h"
#import "TDGlucoseDataContentProvider.h"
#import "TDBPDataContentProvider.h"
#import "TDWSDataContentProvider.h"
#import "TDTPDataContentProvider.h"
#import "TDSODataContentProvider.h"
#import <QuartzCore/QuartzCore.h>
#import "TDSettingContentProvider.h"
#import "TDUtility.h"
//#import "HKOSSwift-Swift.h"


#define TYPE_BG 1
#define TYPE_BP 2
#define TYPE_WS 8
#define TYPE_MP 6
#define TYPE_SPO2 7
#define TYPE_TM 60

@interface ImportRootController ()
{
    //Swami
    NSString * resultWeightValue;
    NSString * resultBloodGlocoseValue;
    NSString * resultBPValue;
    NSString * resultSPO2Value;
    NSString * resultTempValue;
    NSString * isDeviceType;
    
}

@end

@implementation ImportRootController
@synthesize deviceId, deviceType, directConnect, rootView;
@synthesize imgProc1;
@synthesize imgProc2;
@synthesize settingData;
@synthesize importStatus;
@synthesize meterController;
@synthesize lastedW65result;
@synthesize isW65Importing;
@synthesize devicePopUpView;
@synthesize StatusToplblCons;
@synthesize deviceTypeHeaderLabel,deviceNameLabel,deviceIDLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    isW65Importing=false;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isW65Import:(Boolean) w65Imported w65NewestResult:(TDWSData*)w65Result
{
    isW65Importing=w65Imported;
    lastedW65result =w65Result;
    NSLog(@"Last W65 Result : %@",lastedW65result);
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    isImportingOBJC = 0;
    [meterController removeNotify];
    
    [meterController release];
    meterController = nil;
    [importStatus release];
    [meterProfile release];
    [dataList release];
    [deviceId release];
    [deviceType release];
    [rootView release];
    [imgProc1 release];
    [imgProc2 release];
    [settingData release];
    [devicePopUpView release];
    [StatusToplblCons release];
    [deviceTypeHeaderLabel release];
    [deviceNameLabel release];
    [deviceIDLabel release];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ProjectCode object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_DateTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_SerialNumber1 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_SerialNumber2 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_RecordNumber object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record1 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ReadWSValue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaidocNotification_GetFirmwareVersion object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ShowError object:nil];
    
    [_spinner release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)gotoForeground: (NSNotification *) notification
{
    if ([[self.navigationController topViewController] class]
        == [ImportRootController class])
    {
        [[self.navigationController topViewController] viewWillAppear:NO];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (errorAlert) {
        [errorAlert dismissWithClickedButtonIndex:0 animated:TRUE];
    }
    
    rootView.isOKtoSwitchToOtherView = YES;
    [super viewWillDisappear:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // fade in animation
    [[self view] setAlpha:0.5];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [[self view] setAlpha:1];
    [UIView commitAnimations];
    
    // rotation animation
    CABasicAnimation *theAnimation_imgProc2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation_imgProc2.toValue = [NSNumber numberWithFloat: 2*M_PI];
    theAnimation_imgProc2.duration = 5.0;
    theAnimation_imgProc2.repeatCount = FLT_MAX;
    [[imgProc2 layer] addAnimation:theAnimation_imgProc2 forKey:@"roation"];
    
    if (errorAlert.visible) {
        importStatus.text = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Import RootController viewDidLoad");

    //SwamiN
    NSString * deviceConnectedType = [[NSUserDefaults standardUserDefaults] objectForKey:@"GRXDeviceType"];
    NSString * deviceFullName = [self getDeviceFullName:deviceConnectedType];
    deviceTypeHeaderLabel.text = [NSString stringWithFormat:@"Retrieving Value from %@ Device",deviceFullName];
    NSString * deviceConnectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralName"];
    deviceConnectedName = @"GRx";
    deviceNameLabel.text = deviceConnectedName;

    //SWAMI
    resultWeightValue = @"";
    resultBloodGlocoseValue = @"";
    resultBPValue = @"";
    resultSPO2Value = @"";
    resultTempValue = @"";
    
    self.popUpView.layer.borderWidth = 1;
    self.popUpView.layer.borderColor = [UIColor colorWithRed:19.0/255 green:83.0/255 blue:144.0/255 alpha:1].CGColor;

    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 1024.0) {//iPad
        self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 770, 1024);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 568.0){//iPhone5
        self.devicePopUpView.frame = CGRectMake(0, 0, 320, 568);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 667.0){//iPhone6//6s//7//7s
        self.devicePopUpView.frame = CGRectMake(0, 0, 375, 667);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 736.0){//iPhone6plus//iPhone6splus//iPhone7plus//iPhone8plus
        self.devicePopUpView.frame = CGRectMake(0, 0, 414, 736);
        [self.view addSubview:devicePopUpView];
    }


    isImportingOBJC = 1;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetProjectCode:) name:MeterNotification_ProjectCode object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetDateTime:) name:MeterNotification_DateTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetSerialNumber1:) name:MeterNotification_SerialNumber1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetSerialNumber2:) name:MeterNotification_SerialNumber2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetRecordsNumber:) name:MeterNotification_RecordNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetRecord1:) name:MeterNotification_Record1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetRecord2:) name:MeterNotification_Record2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImportReadWSValue:) name:MeterNotification_ReadWSValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetFirmwareVersion:) name:TaidocNotification_GetFirmwareVersion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowError:) name:MeterNotification_ShowError object:nil];
    
    dataList = [[NSMutableArray alloc] init];
    
    
    if(!isW65Importing)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:NO];
    }
    
    
    if(isW65Importing)
    {
        timerW65 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_importedW65Value:) userInfo:nil repeats:NO];
    }
    
    
    importedCount = 0;
    recordsNumber = 0;
    importType = 0;
    isComplete = NO;
    showAlert = YES;
    UserNo = 0;
    firmwareVersion = 0;
    
    
    TDSettingContentProvider *settingProvider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.settingData = [settingProvider getSettingData];
    [settingProvider release];
    
    importStatus.text = NSLocalizedStringFromTable(@"String_ImportRootController_StatusText", @"MyLocalizable", nil);
    
    [_spinner startAnimating];
    [_spinner setHidden:NO];
}
- (NSString *)getDeviceFullName:(NSString *)deviceName
{
    NSString * deviceFullName = @"";
    if ([deviceName isEqualToString:@"GRXDeviceHeartRate"]) {
        deviceFullName = @"Pulse Oximeter";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceSPO2"])
    {
        deviceFullName = @"Pulse Oximeter";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceBP"])
    {
        deviceFullName = @"BP";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceGlucose"])
    {
        deviceFullName = @"Glucose";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceWeight"])
    {
        deviceFullName = @"Weight";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceTemperature"])
    {
        deviceFullName = @"Temperature";
    }

    return deviceFullName;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void) onShowError: (NSTimer *)theTimer
{
    //time out
    if (showAlert == YES) {
        [self onError];
    }
}



- (void) onGetRecord1:(NSNotification *)notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSData *args = (NSData *) [notification object];
    
    [args getBytes:tmpBytes range:NSMakeRange(2, 4)];
    
    retryCount = 0;
    
    if (meterController != nil){
        [meterController getRecord2:importedCount UserNo:UserNo];

        if (IS_IOS7) {
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOutGetRecord2:) userInfo:nil repeats:NO];
        }else{
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord2:) userInfo:nil repeats:NO];
        }
    }
}

- (void) timeOutGetRecord1: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getRecord1:importedCount UserNo:UserNo];

            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 5-1
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
    }
}

//Swami
-(void) removeObserversAfterFetchingReadings{
    
    [meterController powerOffMeter];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ProjectCode object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_DateTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_SerialNumber1 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_SerialNumber2 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_RecordNumber object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record1 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ReadWSValue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaidocNotification_GetFirmwareVersion object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_ShowError object:nil];
    //SwamiN
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleDisconnectedNotification object:nil];

}
-(void)navigateToTabBarWithUnknownDevice{
    
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
    NSString *tmpProjectCode = @"";
    tmpProjectCode=self.deviceType;
    if(tmpProjectCode.length>=4)
    {
        tmpProjectCode=[tmpProjectCode substringWithRange:NSMakeRange(0, 3)];
    }
    
    if([tmpProjectCode isEqualToString:@"326"])
    {
        sleep(3);//等待D40關機後，METER BT斷電會DELAY的問題//
    }
    
    importStatus.text = @"";
    
    rootView.isbhConnect=false;
    rootView.isScaningBLE = NO;
    
    [self gotoDataView];

    
}
- (void) onGetRecord2:(NSNotification *)notification
{
    
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSData *args = (NSData *) [notification object];
    BOOL isEnd = NO;
    
    //BG如果有Ketone和Hematocrit這兩種情況要剔除
    unsigned char *pRecviceData = (unsigned char *) [args bytes];
    unsigned char Type1_2;
    Type1_2 = (pRecviceData[5] & 0x3c) >> 2;
    
    if (pRecviceData[1] == 0x26 && Type1_2 != 0x00 && [self.deviceType isEqualToString:@"4272"]) {
        DontSave = YES;
    }else {
        DontSave = NO;
    }
    
    [args getBytes:&tmpBytes[4] range:NSMakeRange(2, 4)];


    if (meterProfile != nil) {
        /* Set Date */
        int mYear = 0, mMonth = 0, mDay = 0, mHour = 0, mMin = 0, ihb = 0, avg = 0, recordType = 0,arrhy=0;
        
        if ([self.deviceType isEqualToString:@"3140"]) {
            
            recordType = 1;
            ihb = (tmpBytes[2] & 0xC0) >> 6;
            
        }else if ([self.deviceType isEqualToString:@"3261"]) {
            recordType = (tmpBytes[2] & 0x80) / 0x80; //0: BG, 1:BP
            ihb = (tmpBytes[3] & 0x60) >> 5;
            arrhy =(tmpBytes[2] & 0x40) / 0x40;
            
        }else{
            recordType = (tmpBytes[2] & 0x80) / 0x80; //0: BG, 1:BP
            ihb = ((tmpBytes[2] & 0x40) / 0x40);
            
        }
        if (recordType == 1) {
            importType = TYPE_BP;
        }else{
            importType = TYPE_BG;
        }
        
        if (meterController.meterType == 0) {
            [self getDataType_V3];
        }else {
            [self getDataType: self.deviceType normalState: NO];
        }
        
        
        
        mMin = tmpBytes[2] & 0x3f;
        mHour = tmpBytes[3] & 0x1f;
        avg = (tmpBytes[3] & 0x80) / 0x80;
        mYear = ((tmpBytes[1] / 0x2) + 2000);
        mMonth = (tmpBytes[0] & 0xe0) /0x20 + ((tmpBytes[1] & 0x1) * 0x8);
        mDay = tmpBytes[0] & 0x1f;
        
        NSDateFormatter *tempForatter = [[NSDateFormatter alloc] init];
        [tempForatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [tempForatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        
        NSString *tmpStr = [NSString stringWithFormat:@"%04d-%02d-%02d at %02d:%02d", mYear, mMonth, mDay, mHour, mMin];
        NSLog(@"Glucose date string: %@",tmpStr);
        NSDate *tmpdate = [tempForatter dateFromString:tmpStr];
        
        [tempForatter release];
        

        switch (importType) {
            case TYPE_BG:
            {
                NSLog(@"TYPE_BG:");
                NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                           stringForKey:@"GRXDeviceType"];
                NSLog(@"GRXDeviceType: %@",GRXDeviceType);
                if ([GRXDeviceType isEqualToString:@"GRXDeviceGlucose"])
                {

                TDGlucoseData *glucoseData = [[TDGlucoseData alloc] init];
                glucoseData.inputDate = [tmpdate timeIntervalSince1970];
                glucoseData.value = tmpBytes[5] * 0x100 + tmpBytes[4];
                NSLog(@"glucoseData.values : %f",glucoseData.value);
                NSLog(@"glucoseData.tmpDateStr : %@",tmpStr);

                if ([resultBloodGlocoseValue isEqualToString:@""]) {
                    resultBloodGlocoseValue = [NSString stringWithFormat:@"%.0f",glucoseData.value];
                    NSLog(@"bloodGlocoseValue : %@",resultBloodGlocoseValue);
                    //Saving in NSUserDefaults
                    [[NSUserDefaults standardUserDefaults] setObject:resultBloodGlocoseValue forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] setObject:tmpStr forKey:@"GlocoseReadingDate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }

                // todo: classified period of time if this field is normal
                glucoseData.machineOrgType = (tmpBytes[7] & 0xc0) / 64;
                
                if (glucoseData.machineOrgType == 0) {
                }else if (glucoseData.machineOrgType == 3){
                    glucoseData.type = 4; //QC
                }else{
                    glucoseData.type = glucoseData.machineOrgType;
                }
                
                glucoseData.userNO = UserNo;
                glucoseData.DontSave = DontSave;
                glucoseData.upload = 0;
                glucoseData.rawData = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X", tmpBytes[0], tmpBytes[1], tmpBytes[2], tmpBytes[3], tmpBytes[4], tmpBytes[5], tmpBytes[6], tmpBytes[7]];
                
                if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport == nil)
                {
                    [dataList addObject:glucoseData];
                }
                else if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport != nil && [glucoseData.rawData compare:meterProfile.lastImport] != NSOrderedSame)
                {
                    [dataList addObject:glucoseData];
                }
                else
                {
                    isEnd = YES;
                }
                [glucoseData release];
                
                
                //SWAMICommenting
                if ([resultBloodGlocoseValue isEqualToString:@""]) {
                }
                else
                {
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];
                    
                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    [self toShowResultValues];
                }
            }
                else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                
                isEnd = YES;
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }
            }

            }
                break;
                
            case TYPE_BP:
            {
                NSLog(@"TYPE_BP:");
                NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                           stringForKey:@"GRXDeviceType"];
                NSLog(@"GRXDeviceType: %@",GRXDeviceType);
                if ([GRXDeviceType isEqualToString:@"GRXDeviceBP"])
                {

                TDBPData *bpData = [[TDBPData alloc] init];
                bpData.inputDate = [tmpdate timeIntervalSince1970];
                bpData.systolic = tmpBytes[4];
                bpData.diastolic = tmpBytes[6];
                bpData.pulse = tmpBytes[7];
                bpData.upload = 0;
                bpData.ihb = ihb;
                bpData.avg = avg;
                bpData.userNO = UserNo;
                NSLog(@"bpData.pulse : %f",bpData.pulse);
                NSLog(@"bpData.systolic : %f",bpData.systolic);
                NSLog(@"bpData.diastolic : %f",bpData.diastolic);

                if ([resultBPValue isEqualToString:@""]) {
                    resultBPValue = [NSString stringWithFormat:@"%.0f/%.0f/%.0f",bpData.systolic,bpData.diastolic,bpData.pulse];
                    NSLog(@"resultBPValue : %@",resultBPValue);
                    //Saving in NSUserDefaults
                    [[NSUserDefaults standardUserDefaults] setObject:resultBPValue forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }



                bpData.rawData = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%f%f%f", tmpBytes[0], tmpBytes[1], tmpBytes[2], tmpBytes[3], tmpBytes[4], tmpBytes[5], tmpBytes[6], tmpBytes[7], bpData.systolic, bpData.diastolic, bpData.pulse];
                
                //NSLog(@"TYPE_BP rawData : %@",[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%f%f%f", tmpBytes[0], tmpBytes[1], tmpBytes[2], tmpBytes[3], tmpBytes[4], tmpBytes[5], tmpBytes[6], tmpBytes[7], bpData.systolic, bpData.diastolic, bpData.pulse]);

                if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport == nil)
                {
                    [dataList addObject:bpData];
                }
                else if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport != nil && [bpData.rawData compare:meterProfile.lastImport] != NSOrderedSame)
                {
                    [dataList addObject:bpData];
                }
                else
                {
                    isEnd = YES;
                }
                //NSLog(@"dataList Array : %@",dataList);

                [bpData release];
                
                //SWAMICommenting
                if ([resultBPValue isEqualToString:@""]) {
                }
                else
                {
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];

                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    [self toShowResultValues];
                }
            }
                else{
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];
                    
                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    
                    isComplete = YES;
                    showAlert = YES;
                    importedCount++;
                    if (isComplete == YES && showAlert == YES) {
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                        
                    }
                }

            }
                break;
                
            case TYPE_TM:
            {
                NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                           stringForKey:@"GRXDeviceType"];
                NSLog(@"GRXDeviceType: %@",GRXDeviceType);
                if ([GRXDeviceType isEqualToString:@"GRXDeviceTemperature"])
                {

                TDTPData *tmData = [[TDTPData alloc] init];
                tmData.inputDate = [tmpdate timeIntervalSince1970];
                tmData.value = ((tmpBytes[5] << 8) + tmpBytes[4]) * 0.1;
                tmData.rawData = [NSString stringWithFormat:@"%d#%f", (int)tmData.inputDate, tmData.value];
                //NSLog(@"tmData.inputDate : %d",tmData.inputDate);
                //NSLog(@"tmData.value : %f",tmData.value);
                NSString * tempFahrenheitValue = [NSString stringWithFormat:@"%f",tmData.value];
                
                if ([resultTempValue isEqualToString:@""]) {
                    double celsius = [tempFahrenheitValue doubleValue];
                    double fahrenheit = (celsius * 1.8) + 32;
                    NSString *resultString = [[NSString alloc] initWithFormat:@"%4.2f",fahrenheit];

                    resultTempValue = [NSString stringWithFormat:@"%@",resultString];
                    NSLog(@"resultTempValue : %@",resultString);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:resultTempValue forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }
                else{
                    NSLog(@"resultTempValue : HAS VALUE");

                }


                //SWAMI COMMENTING
                //if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport == nil)
                if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber)
                {
                    [dataList addObject:tmData];
                }
                else if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport != nil && [tmData.rawData compare:meterProfile.lastImport] != NSOrderedSame)
                {
                    [dataList addObject:tmData];
                }
                else
                {
                    isEnd = YES;
                }
                
                //SWAMICommenting
                if ([resultTempValue isEqualToString:@""]) {
                }
                else
                {
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];

                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    [self toShowResultValues];
                }

            }
                else{
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];
                    
                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    
                    isComplete = YES;
                    showAlert = YES;
                    importedCount++;
                    if (isComplete == YES && showAlert == YES) {
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                        
                    }
                }
        }
                break;
                
            case TYPE_SPO2:
            {
                NSLog(@"TYPE_SPO2:");//GRXDeviceHeartRate
                NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"GRXDeviceType"];
                NSLog(@"GRXDeviceType: %@",GRXDeviceType);
                if ([GRXDeviceType isEqualToString:@"GRXDeviceSPO2"] || [GRXDeviceType isEqualToString:@"GRXDeviceHeartRate"]) {

                TDSOData *tmData = [[TDSOData alloc] init];
                tmData.inputDate = [tmpdate timeIntervalSince1970];
                tmData.spo2Value = tmpBytes[4];
                tmData.pulse = pRecviceData[5];
                //NSLog(@"Pulse Value : %f",tmData.pulse);
                tmData.rawData = [NSString stringWithFormat:@"%ld#%f", (long) tmData.inputDate, tmData.spo2Value];
                if ([resultSPO2Value isEqualToString:@""]) {
                    resultSPO2Value = [NSString stringWithFormat:@"%.0f/%.0f",tmData.spo2Value,tmData.pulse];
                    NSLog(@"resultSPO2Value : %@",resultSPO2Value);
                    [[NSUserDefaults standardUserDefaults] setObject:resultSPO2Value forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }
                else{
                    NSLog(@"resultSPO2Value : HAS VALUE");
                    
                }


                //SWAMI COMMENTING
//                if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport == nil)
                if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber )
                {
                    [dataList addObject:tmData];
                }
                else if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport != nil && [tmData.rawData compare:meterProfile.lastImport] != NSOrderedSame)
                {
                    [dataList addObject:tmData];
                }
                else
                {
                    isEnd = YES;
                }
                //NSLog(@"dataList Array : %@",dataList);
                
                //SWAMICommenting
                if ([resultSPO2Value isEqualToString:@""]) {
                }
                else
                {
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];

                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    [self toShowResultValues];
                }


            }
                else{
                    //clear Plist files
                    [TaidocBleConnectedList clearMemoryConnectedList];
                    
                    isEnd = YES;
                    [self removeObserversAfterFetchingReadings];
                    
                    isComplete = YES;
                    showAlert = YES;
                    importedCount++;
                    if (isComplete == YES && showAlert == YES) {
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                        
                    }


                }
            }
                
                break;
                
            default:
                break;
        }
        
        /*if (importedCount < recordsNumber && isEnd == NO && meterController != nil)
        {
            retryCount = 0;
            importedCount++;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setLocale:[NSLocale currentLocale]];
            
            NSString *strRecordImport=@"%@ ";
            NSString *strRecordsImport=@"%@ ";
            
            strRecordImport = [strRecordImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordImported", @"MyLocalizable", nil)];
            strRecordsImport = [strRecordsImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordsImported", @"MyLocalizable", nil)];
            
            
            importStatus.text = [NSString stringWithFormat: (importedCount == 1) ? strRecordImport : strRecordsImport, [formatter stringFromNumber:[NSNumber numberWithDouble:importedCount]]];
            
            if (meterController != nil){
                [meterController getRecord1:importedCount UserNo:UserNo];
                if (IS_IOS7) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                }else{
                    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                }
            }
            
            [formatter release];
        }
        else
        {
            NSLog(@"meterController : %@",meterController);
            NSLog(@"recordsNumber : %d",recordsNumber);
            NSLog(@"[dataList count] : %@",dataList);

            //Swami Commenting
            if (recordsNumber > 0 && [dataList count] > 0 && meterController != nil)
            {
                TDGlucoseData *tmpGlucoseData;
                TDBPData *tmpBPData;
                TDTPData *tmpTPData;
                TDSOData *tmpSOData;
                int checkCount;
                
                //SWAMI COMMENTING
                if ([[dataList objectAtIndex:0] isKindOfClass:[TDGlucoseData class]]) {
                    tmpGlucoseData = [dataList objectAtIndex:0];
                    //meterProfile.lastImport = tmpGlucoseData.rawData;
                }else if ([[dataList objectAtIndex:0] isKindOfClass:[TDBPData class]]) {
                    tmpBPData = [dataList objectAtIndex:0];
                    //meterProfile.lastImport = tmpBPData.rawData;
                }else if([[dataList objectAtIndex:0] isKindOfClass:[TDTPData class]]) {
                    tmpTPData = [dataList objectAtIndex:0];
                    //meterProfile.lastImport = tmpTPData.rawData;
                }else if([[dataList objectAtIndex:0] isKindOfClass:[TDSOData class]]) {
                    tmpSOData = [dataList objectAtIndex:0];
                    //NSLog(@"tmpSOData : %@",tmpSOData );
                    //NSLog(@"tmpSOData : %@",tmpSOData.rawData );
                    
                    //SWAMI COMMENTING
                    //meterProfile.lastImport = tmpSOData.rawData;
                    //NSLog(@"meterProfile.lastImport : %@",meterProfile.lastImport);
                }
                
                //SWAMI COMMENTING
                //meterProfile.userNO = UserNo;
                
                TDMeterProfileContentProvider *provider = [[TDMeterProfileContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                //SWAMI COMMENTING
                //[provider updateMeterProfile:meterProfile];
                
                //[meterProfile release];
                
                meterProfile = [provider getMeterProfile:self.deviceType deviceID:self.deviceId userNO:UserNo];
                
                [provider release];
                
                TDGlucoseDataContentProvider *glProvider = [[TDGlucoseDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                TDBPDataContentProvider *bpProvider = [[TDBPDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                TDTPDataContentProvider *tpProvider = [[TDTPDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                TDSODataContentProvider *soProvider = [[TDSODataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                
                for (int i= 0; i< [dataList count]; i++)
                {
                    if ([[dataList objectAtIndex:[dataList count] - i - 1] isKindOfClass:[TDGlucoseData class]]) {
                        tmpGlucoseData = [dataList objectAtIndex:[dataList count] - i - 1];
                        tmpGlucoseData.meterUID = meterProfile._id;
                        
                        if (tmpGlucoseData.type != 4) {
                            // Write data to db
                            checkCount = [glProvider checkDataRepeat:tmpGlucoseData.inputDate Data1:tmpGlucoseData.value];
                            if (!checkCount) {
                                if (!tmpGlucoseData.DontSave) {
                                    [glProvider addGlucoseData:tmpGlucoseData];
                                    
                                }
                            }
                        }
                    }
                    else if ([[dataList objectAtIndex:[dataList count] - i - 1] isKindOfClass:[TDBPData class]]) {
                        tmpBPData = [dataList objectAtIndex:[dataList count] - i - 1];
                        tmpBPData.meterUID = meterProfile._id;
                        
                        // Write data to db
                        checkCount = [bpProvider checkDataRepeat:tmpBPData.inputDate Data1:tmpBPData.systolic Data2:tmpBPData.diastolic Data3:tmpBPData.pulse];
                        if (!checkCount) {
                            [bpProvider addBPData:tmpBPData];
                            
                        }
                    }else if ([[dataList objectAtIndex:[dataList count] - i - 1] isKindOfClass:[TDTPData class]]) {
                        tmpTPData = [dataList objectAtIndex:[dataList count] - i - 1];
                        tmpTPData.meterUID = meterProfile._id;
                        
                        checkCount = [tpProvider checkDataRepeat:tmpTPData.inputDate Data1:tmpTPData.value];
                        if (!checkCount) {
                            //Write data to db
                            [tpProvider addTPData:tmpTPData];
                            
                        }
                    }else if ([[dataList objectAtIndex:[dataList count] - i - 1] isKindOfClass:[TDSOData class]]) {
                        tmpSOData = [dataList objectAtIndex:[dataList count] - i - 1];
                        tmpSOData.meterUID = meterProfile._id;
                        
                        checkCount = [soProvider checkDataRepeat:tmpSOData.inputDate Data1:tmpSOData.spo2Value Data3:tmpSOData.pulse];
                        if (!checkCount) {
                            //Write data to db
                            NSLog(@"tmpSOData : %@",tmpSOData);
                            [soProvider addSOData:tmpSOData];
                            NSLog(@"soProvider : %@",soProvider);

                        }
                    }
                }
                
                [soProvider release];
                [tpProvider release];
                [bpProvider release];
                [glProvider release];
            }
            
            if (meterController != nil){
                //SWAMI COMMENTING
                //[meterController powerOffMeter];
                isComplete = YES;
            }
            
            if (isComplete == YES && showAlert == YES) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                
                //SWAMICommenting
                [self performSelectorOnMainThread:@selector(showResultMessage) withObject:nil waitUntilDone:NO];

            }
        }*/

    }
}

//Swami
-(void)toShowResultValues
{
    isComplete = YES;
    showAlert = YES;
    importedCount++;
    if (isComplete == YES && showAlert == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
        
        [self performSelectorOnMainThread:@selector(showResultMessage) withObject:nil waitUntilDone:NO];
        
    }
 
}
- (void) timeOutGetRecord2: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getRecord2:importedCount UserNo:UserNo];

            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOutGetRecord2:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 5-1
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord2:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
    }
}

- (void) onGetRecordsNumber:(NSNotification *)notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSData *args = (NSData *) [notification object];
    unsigned char *pData = (unsigned char *) [args bytes];
    
    if (importType == TYPE_BG) {
        int storageNumber = (pData[3] << 8) | pData[2];
        int newestIndex = (pData[5] << 8) | pData[4];
        
        if (storageNumber == 0) {
            recordsNumber = 0;
        }else if (storageNumber - newestIndex == 1) {
            recordsNumber = storageNumber;
        }else if (storageNumber - newestIndex > 1) {
            recordsNumber = storageNumber - 1;
        }
        
    }
    else if(importType == TYPE_WS)
    {
        recordsNumber = (pData[3] << 8) | pData[2];//user future
    }else{
        recordsNumber = (pData[3] << 8) | pData[2];
    }
    
    if (meterController != nil && recordsNumber > 0){
        switch (importType) {
            case TYPE_BG:
            case TYPE_BP:
            case TYPE_MP:
                [meterController getRecord1:importedCount UserNo:UserNo];

                if (IS_IOS7) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                }else{
                    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                }
                break;
                
            case TYPE_WS:
                [meterController readWSMeasureValue:importedCount ];
                if (IS_IOS7) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
                }else{
                    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
                }
                break;
                
            case TYPE_TM:
                [meterController getRecord1:importedCount UserNo:UserNo];
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                break;
                
            case TYPE_SPO2:
                [meterController getRecord1:importedCount UserNo:UserNo];
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutGetRecord1:) userInfo:nil repeats:NO];
                break;
                
            default:
                break;
        }
        
    }else{
        if (meterController != nil){
            //SWAMIN
            [meterController powerOffMeter];
            isComplete = YES;
        }
        
        if (isComplete == YES && showAlert == YES) {
            
            [self performSelectorOnMainThread:@selector(showResultMessage) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void) timeoutGeRecordsNumber: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil && recordsNumber > 0){
            [meterController getRecordsNumberForUserNo:UserNo];
            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
            }else{
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }else{
            if (meterController != nil){
                [meterController powerOffMeter];
                isComplete = YES;
            }
            
            if (isComplete == YES && showAlert == YES) {
                
                [self performSelectorOnMainThread:@selector(showResultMessage) withObject:nil waitUntilDone:NO];
            }
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
    }
}

- (void) onGetProjectCode:(NSNotification *)notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    ProjectInfoEventArgs *args = (ProjectInfoEventArgs *) [notification object];
    
    self.deviceType = args.projectNo;
    
    [self getDataType:self.deviceType normalState:YES];
    
    if ([self.deviceType isEqualToString:@"3261"] || [self.deviceType isEqualToString:@"3280"] || [self.deviceType isEqualToString:@"3128"]) {
        UserNo = 1;
    }else{
        UserNo = 0;
    }
    
    
    /* Check meter */
    TDMeterProfileContentProvider *contentProvider = [[TDMeterProfileContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    

    meterProfile = [contentProvider getMeterProfile:deviceType deviceID:deviceId userNO:UserNo];
    
    // new meter
    if (meterProfile == nil)
    {
        meterProfile = [[TDMeterProfile alloc] init];
        meterProfile._id = 0;
        meterProfile.deviceId = deviceId;
        meterProfile.deviceType = deviceType;
        meterProfile.deviceMacAddress = @"1234";
        meterProfile.lastImport = nil;
    }
    
    [contentProvider release];
    
    if (meterController != nil){
        [meterController getRecordsNumberForUserNo:UserNo];
        
        if (IS_IOS7) {
            // timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutonGetFirmwareVersion:) userInfo:nil repeats:NO];
        }else{
            //  timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutonGetFirmwareVersion:) userInfo:nil repeats:NO];
        }
    }
}

- (void) timeoutGetProjectCode: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getProjectCode];
            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetProjectCode:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 5-1
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGetProjectCode:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
    }
}



- (void) onSetDateTime:(NSNotification *)notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    if (meterController != nil){
        [meterController getSerialNumber1];
        if (IS_IOS7) {
            timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeoutGetSerialNumber1:) userInfo:nil repeats:NO];
        }else{
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGetSerialNumber1:) userInfo:nil repeats:NO];
        }
    }
}

- (void) timeoutsetDateTime: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        
        if (meterController != nil){
            [meterController setDateTime];

            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeoutsetDateTime:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 15-1
                timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeoutsetDateTime:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
        
    }
}

- (void) onGetSerialNumber1:(NSNotification *)notification
{
    self.deviceId=@"";
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSString *args = (NSString *) [notification object];
    
    self.deviceId = args;
    
    if (meterController != nil){
        [meterController getSerialNumber2];

        if (IS_IOS7) {
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetSerialNumber2:) userInfo:nil repeats:NO];
        }else{
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGetSerialNumber2:) userInfo:nil repeats:NO];
        }
    }
}

- (void) timeoutGetSerialNumber1: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getSerialNumber1];
            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetSerialNumber1:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 5-1
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGetSerialNumber1:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }    }
}

- (void) onGetSerialNumber2:(NSNotification *)notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSString *args = (NSString *) [notification object];
    
    self.deviceId = [self.deviceId stringByAppendingString:args];
    
    
    if(self.deviceId.length>16)
    {
        NSString *tmp=self.deviceId;
        self.deviceId =[tmp substringWithRange:NSMakeRange(0, 16)];
    }
    
    
    if(self.deviceId.length>16)
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
        return;
    }
    
    
    if (meterController != nil){
        [meterController getProjectCode];
        if (IS_IOS7) {
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetProjectCode:) userInfo:nil repeats:NO];
        }else{
            //SwamiN 10 - 1
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetProjectCode:) userInfo:nil repeats:NO];
        }
    }
}

- (void) timeoutGetSerialNumber2: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getSerialNumber2];

            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetSerialNumber2:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 10-1
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGetSerialNumber2:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
    }
}

- (void) onGetFirmwareVersion:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaidocNotification_GetFirmwareVersion object:nil];
    
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    NSData *args = (NSData *) [notification object];
    unsigned char *pData = (unsigned char *) [args bytes];
    
    firmwareVersion = pData[4];
    
    if (meterController != nil){
        [meterController getRecordsNumberForUserNo:UserNo];
        if (IS_IOS7) {
            timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
        }else{
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutGeRecordsNumber:) userInfo:nil repeats:NO];
        }
    }
    
    args = NULL;
    [args release];
}

- (void) timeoutonGetFirmwareVersion: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController getFirmwareVersion];
            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeoutonGetFirmwareVersion:) userInfo:nil repeats:NO];
            }else{
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeoutonGetFirmwareVersion:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    
}


- (void) WSMeasureValue: (NSTimer *)theTimer
{
    if (retryCount < 2)
    {
        if (meterController != nil){
            [meterController readWSMeasureValue:importedCount];
            if (IS_IOS7) {
                timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
            }else{
                //SwamiN 5-1
                timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
            }
            retryCount++;
        }
    }
    else
    {
        //error
        if (showAlert == YES) {
            [self onError];
        }
        
    }
}




- (void) onImportReadWSValue: (NSNotification *) notification
{
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    

    if (meterProfile != nil) {

        BOOL isEnd = NO;
        TDWSData *arg = (TDWSData *) [notification object];
        
        TDWSData *wsData = [[TDWSData alloc] init];
        wsData.dWeight = arg.dWeight;
        wsData.dMachineBmi = arg.dMachineBmi;
        wsData.dCaledBmi = 0;
        wsData.inputDate  = [ arg.CreateDate timeIntervalSince1970];
        wsData.CreateDate = arg.CreateDate;
        
        NSLog(@"wsData.dWeight : %f",wsData.dWeight);
        if ([resultWeightValue isEqualToString:@""]) {
            resultWeightValue = [NSString stringWithFormat:@"%.01f",wsData.dWeight];
            [[NSUserDefaults standardUserDefaults] setObject:resultWeightValue forKey:@"DeviceReadingValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            //[[NSUserDefaults standardUserDefaults] setObject:resultWeightValue forKey:@"TYPE_WS"];
            //[[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        wsData.iCode = arg.iCode;  //2016112501 Kenneth Chan, added
        
        if([deviceType isEqualToString:@"2551"]) { //2016112501 Kenneth Chan , added to match extension ID to user no.
            wsData.iMeterUserNo = arg.iCode - 1;
        }
        else
            wsData.iMeterUserNo = arg.iCode;
        
        
        wsData.rawData = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02f%02f%02f%2@", arg.iYerar,arg.iMonth,arg.iDay,arg.iHour,arg.iMinute,arg.iCode,arg.pWSGenderType,arg.iHeight,arg.iAge,arg.dWeight,arg.dMachineBmi,arg.dCaledBmi,arg.CreateDate];
        wsData.upload = 0;
        //Swami
        //wsData.meterUID = meterProfile._id;
        
        //if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport == nil )
        if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber)
        {
            [dataList addObject:wsData];
        } 
        else if (meterController != nil && recordsNumber > 0 && importedCount < recordsNumber && meterProfile.lastImport != nil && [wsData.rawData compare:meterProfile.lastImport] != NSOrderedSame )
        {
            [dataList addObject:wsData];
        }
        else
        {
            isEnd = YES;
        }
        
        [wsData release];
        
        //SWAMICommenting
        if ([resultWeightValue isEqualToString:@""]) {
        }
        else
        {
            isEnd = YES;
            [self removeObserversAfterFetchingReadings];
            [self toShowResultValues];
        }

        
        
        /*if (importedCount < recordsNumber && isEnd == NO && meterController != nil)
        {
            retryCount = 0;
            importedCount++;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setLocale:[NSLocale currentLocale]];
            
            NSString *strRecordImport=@"%@ ";
            NSString *strRecordsImport=@"%@ ";
            
            strRecordImport = [strRecordImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordImported", @"MyLocalizable", nil)];
            strRecordsImport = [strRecordsImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordsImported", @"MyLocalizable", nil)];
            
            
            importStatus.text = [NSString stringWithFormat: (importedCount == 1) ? strRecordImport : strRecordsImport, [formatter stringFromNumber:[NSNumber numberWithDouble:importedCount]]];
            [formatter release];
            
            if (meterController != nil){
                [meterController readWSMeasureValue:importedCount];
                if (IS_IOS7) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
                }else{
                    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(WSMeasureValue:) userInfo:nil repeats:NO];
                }
            }
        }
        else
        {
            if (recordsNumber > 0 && [dataList count] > 0 && meterController != nil)
            {
                TDWSData *tmpWSData;
                
                tmpWSData = [dataList objectAtIndex:0];
                
                //SWAMI
                //meterProfile.lastImport = tmpWSData.rawData;
                //meterProfile.userNO = UserNo;
                
                TDMeterProfileContentProvider *provider = [[TDMeterProfileContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                
                //SWAMI
                //[provider updateMeterProfile:meterProfile];
                //[meterProfile release];
                
                meterProfile = [provider getMeterProfile:self.deviceType deviceID:self.deviceId userNO:UserNo];
                
                [provider release];
                
                TDWSDataContentProvider *wsProvider = [[TDWSDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
                
                for (int i= 0; i< [dataList count]; i++)
                {
                    tmpWSData = [dataList objectAtIndex:[dataList count] - i - 1];
                    tmpWSData.meterUID = meterProfile._id;
                    // Write data to db //
                    int count = [wsProvider checkDataRepeat:tmpWSData.inputDate Data1:tmpWSData.dWeight Data3:tmpWSData.dMachineBmi];
                    if (!count ) {
                        
                        [wsProvider addWSData:tmpWSData];
                    }
                }
                [wsProvider release];
            }
            
            if (meterController != nil){
                //SWAMI
               // [meterController powerOffMeter];
                isComplete = YES;
            }
            
            if (isComplete == YES && showAlert == YES) {
                
                [self performSelectorOnMainThread:@selector(showResultMessage) withObject:nil waitUntilDone:NO];
            }
        }*/

    }
    
    
}

- (void) targetMethod: (NSTimer *)theTimer
{
    if (self.rootView.isUsingBleDevice) {
        self.rootView.isV3Device = NO;
        if (meterController.meterType==0)
        {
            [meterController closeSession];
        }
        
        if (self.meterController == nil) {
            self.meterController = [[MeterController alloc] init];
            self.meterController.meterType = 1;
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(connectToBLE) userInfo:nil repeats:NO];
        }else{
            [self bleConnected:nil];
        }
    }else
    {
        int isTaidocbusDevice = 0;
        
        NSMutableArray *accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
        
        
        /* Create taidocbus processor */
        
        
        for (EAAccessory *selectAccessory in accessoryList)
        {
            
            if ( [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] )
            {
                
                isTaidocbusDevice = 1;
                
                if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG]){
                    importType = TYPE_BG;
                    
                    // Create session
                    [[EASessionController sharedController] setupControllerForAccessory:selectAccessory withProtocolString:PROTOCOL_STRING_TAIDOC_BG];
                }else if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP]){
                    importType = TYPE_BP;
                    
                    // Create session
                    [[EASessionController sharedController] setupControllerForAccessory:selectAccessory withProtocolString:PROTOCOL_STRING_TAIDOC_BP];
                }else if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS]){
                    importType = TYPE_WS;
                    
                    // Create session
                    [[EASessionController sharedController] setupControllerForAccessory:selectAccessory withProtocolString:PROTOCOL_STRING_TAIDOC_WS];
                }else if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP]){
                    importType = TYPE_MP;
                    
                    // Create session
                    [[EASessionController sharedController] setupControllerForAccessory:selectAccessory withProtocolString:PROTOCOL_STRING_TAIDOC_MP];
                }
                
                //ORIGANEL
                if (!meterController) {
                    meterController = [[MeterController alloc] init];
                }else{
                    [meterController closeSession];//0914 mark
                }
                
                //ORIANGL
                meterController.meterType=0;
                self.rootView.isV3Device = YES;
                
                
                if ([meterController openSession])
                {
                    sleep(3);//???
                    retryCount = 0;
                    [meterController setDateTime];
                    if (IS_IOS7) {
                        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeoutsetDateTime:) userInfo:nil repeats:NO];
                    }else{
                        //SwamiN 15-1
                        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeoutsetDateTime:) userInfo:nil repeats:NO];
                    }
                }else{
                    if (showAlert == YES) {
                        [self onError];
                    }
                }
                break;
            }
        }
        
        [accessoryList release];
        
        if (isTaidocbusDevice == 0)
        {
            [self onError];
        }
    }
}

- (void) getDataType_V3
{
    NSMutableArray *accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    for (EAAccessory *selectAccessory in accessoryList)
    {
        if ( [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS])
        {
            if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG]){
                importType = TYPE_BG;
                
            }else if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP]){
                importType = TYPE_BP;
                
            }else if ([[selectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS]){
                importType = TYPE_WS;
                
            }
        }
    }
    
}

- (void) onError
{
    
    [timer invalidate];
    timer = nil;
    retryCount = 0;
    
    //[meterController closeSession];
    importStatus.text = @"";
    
    errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"String_ImportRootController_Import", @"MyLocalizable", nil) message:NSLocalizedStringFromTable(@"String_ImportRootController_ImportFailed", @"MyLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"String_Alert_Ok", @"MyLocalizable", nil) otherButtonTitles:nil];
    [errorAlert show];
    
    rootView.isbhConnect=false;
}

- (void) showResultMessage
{
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
    NSString *tmpProjectCode = @"";
    tmpProjectCode=self.deviceType;
    if(tmpProjectCode.length>=4)
    {
        tmpProjectCode=[tmpProjectCode substringWithRange:NSMakeRange(0, 3)];
    }
    
    if([tmpProjectCode isEqualToString:@"326"])
    {
        sleep(3);//等待D40關機後，METER BT斷電會DELAY的問題//
    }
    
    importStatus.text = @"";
    
    rootView.isbhConnect=false;
    rootView.isScaningBLE = NO;
    
    
    
    if (importedCount == 0) {
        
        errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"String_ImportRootController_Import", @"MyLocalizable", nil) message:NSLocalizedStringFromTable(@"String_ImportRootController_NoRecordToImport", @"MyLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"String_Alert_Ok", @"MyLocalizable", nil) otherButtonTitles:nil];
        [errorAlert show];
    }
    else {
        
        if (importType == TYPE_BG)
        {
            NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"GRXDeviceType"];
            NSLog(@"GRXDeviceType: %@",GRXDeviceType);
            if ([GRXDeviceType isEqualToString:@"GRXDeviceGlucose"]) {
                NSLog(@"TYPE_BG : %@",resultBloodGlocoseValue);
                [self performSelector:@selector(gotoDataView) withObject:self afterDelay:0.1];

            }
            else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }

            }
        }
        else if (importType == TYPE_TM)
        {
            NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"GRXDeviceType"];
            NSLog(@"GRXDeviceType: %@",GRXDeviceType);
            if ([GRXDeviceType isEqualToString:@"GRXDeviceTemperature"]) {
                NSLog(@"arrayForTemp : %@",resultTempValue);
                [self performSelector:@selector(gotoDataView) withObject:self afterDelay:0.1];

            }
            else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }
            }            
        }
        else if (importType == TYPE_WS)
        {
            NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                                stringForKey:@"GRXDeviceType"];
            NSLog(@"GRXDeviceType: %@",GRXDeviceType);
            if ([GRXDeviceType isEqualToString:@"GRXDeviceWeight"]) {
                NSLog(@"arrayForWeightValues : %@",resultWeightValue);
                [self performSelector:@selector(gotoDataView) withObject:self afterDelay:0.1];

            }
            else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }
            }
        }
        else if (importType == TYPE_BP)
        {
            NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"GRXDeviceType"];
            NSLog(@"GRXDeviceType: %@",GRXDeviceType);
            if ([GRXDeviceType isEqualToString:@"GRXDeviceBP"]) {
                NSLog(@"arrayBP : %@",resultBPValue);
                [self performSelector:@selector(gotoDataView) withObject:self afterDelay:0.1];

            }
            else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }
            }

            //[self gotoDataView];

            /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:[NSString stringWithFormat:@"BP : %@",resultBPValue] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     //BUTTON OK CLICK EVENT
                                     [self gotoDataView];

                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];*/

        }
        else if (importType == TYPE_SPO2)
        {
            NSString *GRXDeviceType = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"GRXDeviceType"];
            NSLog(@"GRXDeviceType: %@",GRXDeviceType);
            if ([GRXDeviceType isEqualToString:@"GRXDeviceSPO2"] || [GRXDeviceType isEqualToString:@"GRXDeviceHeartRate"]) {
                NSLog(@"arraySPO2 : %@",resultSPO2Value);
                [self performSelector:@selector(gotoDataView) withObject:self afterDelay:0.1];

            }
            else{
                //clear Plist files
                [TaidocBleConnectedList clearMemoryConnectedList];
                [self removeObserversAfterFetchingReadings];
                
                isComplete = YES;
                showAlert = YES;
                importedCount++;
                if (isComplete == YES && showAlert == YES) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MeterNotification_Record2 object:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NotProperDevice" forKey:@"DeviceReadingValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelectorOnMainThread:@selector(navigateToTabBarWithUnknownDevice) withObject:nil waitUntilDone:NO];
                    
                }
            }
        }

    }
}

- (void) _importedW65Value : (NSTimer *)theTimer
{
    [timerW65 invalidate];
    importStatus.text = @"";
    rootView.isbhConnect=false;
    rootView.isScaningBLE = NO;
    
    BOOL isEnd = NO;
    TDWSData *wsData = [[TDWSData alloc] init];
    wsData.dWeight = lastedW65result.dWeight;
    wsData.dMachineBmi =0;
    wsData.inputDate  =  [[NSDate date ]timeIntervalSince1970];
    wsData.CreateDate =[NSDate date ];
    //add w65
    wsData.dBodyFat=lastedW65result.dBodyFat;
    wsData.dBodyWater=lastedW65result.dBodyWater;
    wsData.dMuscle=lastedW65result.dMuscle;
    wsData.dBone=lastedW65result.dBone;
    wsData.dBMR=lastedW65result.dBMR;
    
    wsData.rawData =@"unknown";
    wsData.upload = 0;
    
    
    wsData.meterUID = meterProfile._id;  //20160914
    
    
    wsData.iCode = lastedW65result.iMeterUserNo;  //20160913 Kenneth Chan, added for display user No.
    wsData.iMeterUserNo = lastedW65result.iMeterUserNo;
    [dataList addObject:wsData];
    isEnd = YES;
    
    [wsData release];
    
    
    
    NSString *strRecordImport=@"%d ";
    NSString *strRecordsImport=@"%d ";
    
    strRecordImport = [strRecordImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordImported", @"MyLocalizable", nil)];
    strRecordsImport = [strRecordsImport stringByAppendingFormat:NSLocalizedStringFromTable(@"String_ImportRootController_RecordsImported", @"MyLocalizable", nil)];
    
    importStatus.text = [NSString stringWithFormat: strRecordImport , 1];
    [importStatus setNeedsDisplay];
    
    TDWSData *tmpWSData;
    tmpWSData = [dataList objectAtIndex:0];
    
    TDWSDataContentProvider *wsProvider = [[TDWSDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    int count = [wsProvider checkDataRepeat:tmpWSData.inputDate Data1:tmpWSData.dWeight Data3:tmpWSData.dMachineBmi];
    if (!count) {
        [wsProvider addWSData:tmpWSData];
        [wsProvider release];
    }
    
    errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"String_ImportRootController_Import", @"MyLocalizable", nil) message:NSLocalizedStringFromTable(@"String_ImportRootController_ImportSuccess", @"MyLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"String_Alert_Ok", @"MyLocalizable", nil) otherButtonTitles:nil];
    [errorAlert show];
    
}



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gotoDataView) userInfo:nil repeats:NO];
}

- (void) gotoDataView
{
    //SWAMI COMMENTING
    rootView.isComeFromImportView = YES;
    [rootView navigateToResultVC];

//    BleResultValuesList *bleResultList =[[BleResultValuesList alloc] initWithNibName:@"BleResultValuesList" bundle:nil];
//    [self.navigationController pushViewController:bleResultList animated:true];


}



- (void) connectToBLE
{
    bleConnected = NO;
    if (meterController == nil) {
        meterController = [[MeterController alloc] init];
        meterController.meterType = 1;
        self.rootView.isUsingBleDevice = NO;
        [[BleSessionController sharedController] setSettingData:self.settingData];
        [[BleSessionController sharedController] setScanOnly:NO];
        [[BleSessionController sharedController] setBleDeviceConnected:NO];
        
        if ([meterController openSession])
        {
            self.rootView.isUsingBleDevice = YES;
        }else{
            self.rootView.isUsingBleDevice = NO;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeOutForConnectToBLE) userInfo:nil repeats:NO];
    }
}

- (void)bleConnected:(NSNotification *) notification
{
    sleep(5);
    
    if (self.rootView.isUsingBleDevice) {
        bleConnected = YES;
        self.rootView.isbhConnect = YES;
        self.rootView.isScaningBLE=false;
        
        retryCount = 0;
        [timer invalidate];
        timer = nil;
        [meterController setDateTime];
        //SWAMIN 15-8
        timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timeoutsetDateTime:) userInfo:nil repeats:NO];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BleConnectedNotification object:nil];
    }
    
}


-(void) getDataType : (NSString *)projectCode normalState : (BOOL) normalState
{
    if([projectCode isEqualToString:@"3261"] && (normalState == NO))
        return;
    
    if([[projectCode substringToIndex:1] isEqualToString:@"1"])
        importType = TYPE_TM;
    else if([[projectCode substringToIndex:1] isEqualToString:@"2"])
        importType = TYPE_WS;
    else if([[projectCode substringToIndex:1] isEqualToString:@"3"])
        importType = TYPE_BP;
    else if([[projectCode substringToIndex:1] isEqualToString:@"4"])
        importType = TYPE_BG;
    else if([[projectCode substringToIndex:1] isEqualToString:@"8"])
        importType = TYPE_SPO2;
    else
        NSLog(@"error! projectCode=%@ can't be identify", projectCode);
    
    
    if([projectCode isEqualToString:@"3261"] && normalState) {  
        importType = TYPE_MP;
    }
    
    
}


@end
