//
//  ImportRootController.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeterController.h"
#import "DataDefinition.h"
#import "TabBarRootViewController1.h"

@interface UIAlertView(Taidoc)
{
}

@property (nonatomic, readwrite) int *tag;
@end

@interface ImportRootController : UIViewController<UIAlertViewDelegate>
{
    MeterController *meterController;
    NSTimer *timer;
    NSTimer *timerW65;
    
    
    NSString *deviceId;
    NSString *deviceType;
    
    int recordsNumber;
    int importedCount;
    int retryCount;
    int importType;
    TDMeterProfile *meterProfile;
    NSMutableArray *dataList;
    unsigned char tmpBytes[8];
    
    BOOL isComplete;
    BOOL showAlert;
    BOOL directConnect;
    
    UIAlertView *errorAlert;
    int UserNo;
    BOOL bleConnected;
    int firmwareVersion;
    BOOL DontSave;
    
}

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, retain) TabBarRootViewController1 *rootView;
@property (strong, nonatomic) IBOutlet UIView *devicePopUpView;
@property (strong, nonatomic) IBOutlet UILabel *deviceTypeHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *StatusToplblCons;

@property (nonatomic, retain) MeterController *meterController;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *deviceType;
@property (nonatomic, readwrite) BOOL directConnect;
@property (nonatomic, retain) IBOutlet UIImageView *imgProc1;
@property (nonatomic, retain) IBOutlet UIImageView *imgProc2;
@property (nonatomic, retain) TDSettingData *settingData;
@property (nonatomic, retain) IBOutlet UILabel *importStatus;
@property (nonatomic, readwrite) BOOL isW65Importing;
@property (nonatomic, retain) TDWSData  *lastedW65result;;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


- (void) onError;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isW65Import:(Boolean) w65Imported w65NewestResult:(TDWSData*)w65Result;


@end
