//
//  TabBarRootViewController1.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DataDefinition.h"

//about BLE
#import "LeW65AlarmService.h"
#import "MeterController.h"

#define w65ResultString @"55"
#define w65ProfileString @"33"


@interface TabBarRootViewController1 : UIViewController<UITabBarDelegate, UINavigationControllerDelegate, LeTemperatureAlarmProtocol>
{
    int currentTag;
    int tabToGo;
    BOOL isbhConnect;
    BOOL isextConnect;
    BOOL isMeasureComplete;
    int showIndex;
    NSTimer *animationTimer;
    BOOL isOKtoSwitchToOtherView;
    UIAlertView *errorAlert;
}
@property (nonatomic, weak) id delegate;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, nonatomic) IBOutlet NSLayoutConstraint *retrievingValHeightCons;

@property (nonatomic, nonatomic) IBOutlet NSLayoutConstraint *DeviceNameHeightCon;
@property (nonatomic, nonatomic) IBOutlet NSLayoutConstraint *connectionPopUpHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectingPopUpWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceNameTopCon;

@property (nonatomic, retain) UINavigationController *currentViewController;
@property (nonatomic, retain) IBOutlet UITabBar *tabBarView;
@property (strong, nonatomic) IBOutlet UIView *devicePopUpView;
@property (strong, nonatomic) IBOutlet UILabel *deviceTypeHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *StatusToplblCons;

@property (nonatomic, retain) IBOutlet UIImageView *waveShort;
@property (nonatomic, retain) IBOutlet UIImageView *waveMiddle;
@property (nonatomic, retain) IBOutlet UIImageView *waveLong;
@property (nonatomic, readwrite) BOOL isMeasureComplete;
@property (nonatomic, readwrite) BOOL isOKtoSwitchToOtherView;
@property (nonatomic, retain) TDSettingData *settingData;
@property (nonatomic, readwrite) BOOL isComeFromImportView;
@property (nonatomic, retain) UIAlertView *errorAlert;

//about BLE
@property (retain, nonatomic) NSMutableArray *connectedServices;
@property (nonatomic, retain) UIColor *thisAppBackColor;

@property (nonatomic, retain) MeterController *bgMeterProcessor;
@property (nonatomic, retain) NSString *bleIdentifier;
@property (nonatomic, readwrite) BOOL isUsingBleDevice;
@property (nonatomic, retain) TDSettingData *mainSettingData;
@property (nonatomic, retain) TDWSData *lastedW65ImportData;
@property (nonatomic, readwrite) NSInteger tmpMeterUserNo;

@property (nonatomic, readwrite) BOOL isScaningBLE;
@property (nonatomic, readwrite) BOOL isbhConnect;


@property (retain, nonatomic) IBOutlet UIImageView *banner;
@property (nonatomic, readwrite) BOOL isV3Device;



- (void) switchView: (int) tagnumber;
- (void) gotoDataViewandUploadData;
//Swami
- (void)navigateToResultVC;


@property (retain, nonatomic) IBOutlet UITabBarItem *tbiData;
@property (retain, nonatomic) IBOutlet UITabBarItem *tbiSetting;
@property (retain, nonatomic) IBOutlet UITabBarItem *tbiAbout;


- (void)connectToBLE;


- (void) doSomething: (NSString*) response;

@end
