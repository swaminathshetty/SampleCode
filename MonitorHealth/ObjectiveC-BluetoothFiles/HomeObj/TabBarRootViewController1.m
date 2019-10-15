//
//  TabBarRootViewController1.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TabBarRootViewController1.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingRootViewController.h"
#import "SettingBLEDeviceViewController.h"
#import "AboutRootViewController.h"

#import "TDUtility.h"
#import "ImportRootController.h"
#import "RecordListController.h"
#import "TDGlucoseDataContentProvider.h"
#import "TDDataContentProvider.h"
#import "TDMeterProfileContentProvider.h"
#import "TaidocBleConnectedList.h"
#import "MonitorHealth-Swift.h"


@interface TabBarRootViewController1 (){
    int retryCount;
    NSTimer *timer;
    float popUpWidthConValue;

}

@end

NSString *MYEAAccessoryDidDisconnectNotification = @"MYEAAccessoryDidDisconnectNotification";


@implementation TabBarRootViewController1

@synthesize tabBarView;
@synthesize currentViewController;

@synthesize waveLong, waveShort, waveMiddle;
@synthesize isMeasureComplete;
@synthesize isOKtoSwitchToOtherView;
@synthesize settingData;
@synthesize isComeFromImportView;
@synthesize errorAlert;
@synthesize bleIdentifier;
@synthesize isScaningBLE;
@synthesize isUsingBleDevice;
@synthesize isbhConnect;
@synthesize connectedServices;
@synthesize bgMeterProcessor;
@synthesize lastedW65ImportData;
@synthesize tmpMeterUserNo;
@synthesize devicePopUpView;
@synthesize StatusToplblCons;
@synthesize deviceTypeHeaderLabel,deviceIDLabel,deviceNameLabel;
@synthesize DeviceNameHeightCon;
@synthesize deviceNameTopCon;
@synthesize connectionPopUpHeightCon,connectingPopUpWidthCon;
@synthesize retrievingValHeightCons;
@synthesize backgroundImageView;
@synthesize popUpView;


@synthesize banner;
@synthesize isV3Device;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Switch2ImportView" object:nil];
    
    [tabBarView release];
    [currentViewController release];
    
    [waveLong release];
    [waveShort release];
    [waveMiddle release];
    [animationTimer release];
    [errorAlert release];
    //[internetReachability release];
    [bleIdentifier release];
    [connectedServices release];
    [devicePopUpView release];
    [StatusToplblCons release];
    [deviceTypeHeaderLabel release];
    [deviceNameLabel release];
    [deviceIDLabel release];
    [DeviceNameHeightCon release];
    [deviceNameTopCon release];
    [retrievingValHeightCons release];
    [backgroundImageView release];
    [popUpView release];
    [connectionPopUpHeightCon release];
    [connectingPopUpWidthCon release];

    [banner release];
    [_tbiData release];
    [_tbiSetting release];
    [_tbiAbout release];
    [super dealloc];
}



-(void)gotoForeground: (NSNotification *) notification
{
    //check demo data
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.settingData  =[provider getSettingData];
    [provider release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TabBar RootViewController viewDidLoad");
    self.popUpView.hidden = YES;
    //SwamiN
    NSString * deviceConnectedType = [[NSUserDefaults standardUserDefaults] objectForKey:@"GRXDeviceType"];
    NSString * deviceFullName = [self getDeviceFullName:deviceConnectedType];
    deviceTypeHeaderLabel.text = [NSString stringWithFormat:@"Retrieving Value from %@ Device",deviceFullName];
    NSString * deviceConnectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralName"];
    deviceConnectedName = @"GRx";
    deviceNameLabel.text = [NSString stringWithFormat:@"Device Name : %@",deviceFullName];

    self.popUpView.layer.borderWidth = 1;
    self.popUpView.layer.borderColor = [UIColor colorWithRed:19.0/255 green:83.0/255 blue:144.0/255 alpha:1].CGColor;
    //self.popUpView.layer.borderColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0].CGColor;

    lastedW65ImportData = [[TDWSData alloc] init];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 1024.0) {//iPad
        //self.StatusToplblCons.constant = 60;
        self.retrievingValHeightCons.constant = 65;
        self.DeviceNameHeightCon.constant = 10;
        //self.deviceNameTopCon.constant = 30;
        //self.connectionPopUpHeightCon.constant = 120;
        self.connectingPopUpWidthCon.constant = popUpWidthConValue;
        self.devicePopUpView.frame = CGRectMake(0, 0, 770, 1024);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 568.0){//iPhone5
        //self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 320, 568);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 667.0){//iPhone6//6s//7//7s
        //self.StatusToplblCons.constant = 60;
        self.DeviceNameHeightCon.constant = 12;
        self.connectionPopUpHeightCon.constant = 80;
        self.connectingPopUpWidthCon.constant = popUpWidthConValue;
        self.devicePopUpView.frame = CGRectMake(0, 0, 375, 667);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 736.0){//iPhone6plus//iPhone6splus//iPhone7plus//iPhone8plus
        //self.StatusToplblCons.constant = 60;
        self.DeviceNameHeightCon.constant = 12;
        self.connectionPopUpHeightCon.constant = 80;
        self.connectingPopUpWidthCon.constant = popUpWidthConValue;
        self.devicePopUpView.frame = CGRectMake(0, 0, 414, 736);
        [self.view addSubview:devicePopUpView];
    }
//BP 266
//BA 246
//Temp 248
//PO 266
//We 245
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switch2ImportView) name:@"Switch2ImportView"object:nil];
    
    self.tabBarView.delegate = self;
    
    isbhConnect = NO;
    isMeasureComplete = NO;
    isOKtoSwitchToOtherView = YES;
    isComeFromImportView = NO;
    isScaningBLE=NO;
    
    
    [tabBarView setHidden: NO];
    [tabBarView setSelectedItem:_tbiData];
    //[self switchView:0];
    //Swami
    [self switchView:2];

    
    currentTag = 99;
    
    // check accessory or bluetooth connection
    NSMutableArray *accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    
    for (EAAccessory *connectAccessory in accessoryList)
    {
        if ([[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] )
        {
            if (!isbhConnect ) {
                isbhConnect = YES;
                [self switchView:41];
            }
        }
    }
    
    [accessoryList release];
    
    // todo: this make bluetooth meter not work well
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taidocBusCommandReceived:) name:EADSessionDataReceivedNotification object:nil];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    //about BLE Scan and init begin
    connectedServices = [NSMutableArray new];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:kAlarmServiceEnteredBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForegroundNotification:) name:kAlarmServiceEnteredForegroundNotification object:nil];
    
    //about BLE Scan and init end
    
    if (!isextConnect && !isbhConnect && !isScaningBLE) {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectToBLE) userInfo:nil repeats:NO];
    }
    
}

- (NSString *)getDeviceFullName:(NSString *)deviceName
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSString * deviceFullName = @"";
    if ([deviceName isEqualToString:@"GRXDeviceHeartRate"]) {
        deviceFullName = @"Pulse Oximeter";
        if (height == 667.0){
            popUpWidthConValue = 268;
            self.connectingPopUpWidthCon.constant = 280;
        }
        else{
            popUpWidthConValue = 266;
            self.connectingPopUpWidthCon.constant = 266;
        }
        self.backgroundImageView.image = [UIImage imageNamed:@"HeartRateBg"];
    }
    else if ([deviceName isEqualToString:@"GRXDeviceSPO2"])
    {
        deviceFullName = @"Pulse Oximeter";
        if (height == 667.0){
            popUpWidthConValue = 268;
            self.connectingPopUpWidthCon.constant = 280;
        }
        else{
            popUpWidthConValue = 266;
            self.connectingPopUpWidthCon.constant = 266;
        }
        self.backgroundImageView.image = [UIImage imageNamed:@"PulseOximeterBg"];
    }
    else if ([deviceName isEqualToString:@"GRXDeviceBP"])
    {
        deviceFullName = @"Blood Pressure";
        if (height == 667.0){
            popUpWidthConValue = 268;
            self.connectingPopUpWidthCon.constant = 280;
        }
        else{
            popUpWidthConValue = 266;
            self.connectingPopUpWidthCon.constant = 266;
        }
        self.backgroundImageView.image = [UIImage imageNamed:@"BloodPressureBg"];
    }
    else if ([deviceName isEqualToString:@"GRXDeviceGlucose"])
    {
        deviceFullName = @"Glucose";
    }
    else if ([deviceName isEqualToString:@"GRXDeviceWeight"])
    {
        deviceFullName = @"Weight";
        popUpWidthConValue = 245;
        self.backgroundImageView.image = [UIImage imageNamed:@"WeightBg"];
    }
    else if ([deviceName isEqualToString:@"GRXDeviceTemperature"])
    {
        deviceFullName = @"Temperature";
        popUpWidthConValue = 248;
        self.backgroundImageView.image = [UIImage imageNamed:@"TemperatureBg"];
    }
    else if ([deviceName isEqualToString:@"GRXBreathalyzer"])
    {
        deviceFullName = @"Breathalyzer";
        popUpWidthConValue = 246;
        self.backgroundImageView.image = [UIImage imageNamed:@"BreathAlyserBg"];
    }

    return deviceFullName;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.popUpView.layer removeAllAnimations];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//#else
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
//#endif

- (void) switchView: (int) tag
{
    
    NSLog(@"switchView tag : %d",tag);

    // release current controller (view object must be removed from super view)
    [currentViewController.view removeFromSuperview];
    [currentViewController release];
    
    // check: turn on idle timer if not in measurement or import (repeat to prevent screen darken immediately)
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    // set current tag for prevent repeating operation
    currentTag = tag;
    
#ifdef BLE
    //enable for ble
    if (self.isV3Device == YES) {
        if (!isextConnect && !isbhConnect && !isScaningBLE) {
            NSLog(@"into switch");
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectToBLE) userInfo:nil repeats:NO];
        }
    }
#endif
    
    switch (tag)
    {
        case 0:
        {
            RecordListController *controller;
            
            if (IS_IPHONE_5) {
                //controller = [[RecordListController alloc] initWithNibName:@"RecordListController-568h@2x" bundle:nil];
                controller = [[RecordListController alloc] initWithNibName:@"RecordListController" bundle:nil];

            }else{
                controller = [[RecordListController alloc] initWithNibName:@"RecordListController" bundle:nil];
            }
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            [tabBarView setHidden: NO];
            controller.rootView = self;
            //controller.rootView = self;
            [controller release];
            
            TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
            self.settingData  =[provider getSettingData];
            
            
            [provider release];
            
            break;
        }
            
            
        case 41:
        {
            isOKtoSwitchToOtherView = NO;
            
            ImportRootController *controller;
            
            if (IS_IPHONE_5) {
                //controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController-568h@2x" bundle:nil];
                controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController" bundle:nil];

            }else{
                controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController" bundle:nil];
            }
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            
            controller.rootView = self;
            [controller setMeterController:self.bgMeterProcessor];//about Ble meter connected
            [controller release];
            
            // hide navigation and tab bar
            [tabBarView setHidden:YES];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            break;
        }
            
            
        case 411://about w65 importing
        {
            
            isOKtoSwitchToOtherView = NO;
            
            ImportRootController *controller;
            
            if (IS_IPHONE_5) {
                //controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController-568h@2x" bundle:nil  isW65Import:true w65NewestResult:lastedW65ImportData];
                controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController" bundle:nil  isW65Import:true w65NewestResult:lastedW65ImportData];

            }else{
                controller  = [[ImportRootController alloc] initWithNibName:@"ImportRootController" bundle:nil  isW65Import:true w65NewestResult:lastedW65ImportData];
            }
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            
            controller.rootView = self;
            [controller release];
            
            // hide navigation and tab bar
            [tabBarView setHidden:YES];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            break;
            
        }
            
            
        case 2:
        {
            SettingBLEDeviceViewController *controller;
            
            if (IS_IPHONE_5) {
                //controller  = [[SettingRootViewController alloc] initWithNibName:@"SettingRootViewController-568h@2x" bundle:nil];
               // controller  = [[SettingBLEDeviceViewController alloc] initWithNibName:@"SettingBLEDeviceViewController-568h@2x" bundle:nil];
                controller  = [[SettingBLEDeviceViewController alloc] initWithNibName:@"SettingBLEDeviceViewController" bundle:nil];

            }else{
                //controller  = [[SettingRootViewController alloc] initWithNibName:@"SettingRootViewController" bundle:nil];
                controller  = [[SettingBLEDeviceViewController alloc] initWithNibName:@"SettingBLEDeviceViewController" bundle:nil];
            }
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            [tabBarView setHidden: NO];
            
            //controller.rootView = self.rootView;
            [controller setRootView:self];
            [controller release];
            
            break;
        }
            
        case 3:
        {
            AboutRootViewController *controller;
            
            //if (IS_IPHONE_5) {
            //controller  = [[AboutRootViewController alloc] initWithNibName:@"AboutRootViewController-568h@2x" bundle:nil];
            //    controller  = [[AboutRootViewController alloc] initWithNibName:@"AboutRootViewController-568h@2x" bundle:nil];
            //}else{
            //controller  = [[AboutRootViewController alloc] initWithNibName:@"AboutRootViewController" bundle:nil];
            controller  = [[AboutRootViewController alloc] initWithNibName:@"AboutRootViewController" bundle:nil];
            //}
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            [tabBarView setHidden: YES];
            
            //controller.rootView = self.rootView;
            [controller setRootView:self];
            [controller release];
            
            break;
        }
            //Swami
        case 888://Navigate to Ble ResultList
        {
            RecordListController *controller;
            
            if (IS_IPHONE_5) {
                //controller = [[RecordListController alloc] initWithNibName:@"RecordListController-568h@2x" bundle:nil];
                controller = [[RecordListController alloc] initWithNibName:@"RecordListController" bundle:nil];
                
            }else{
                controller = [[RecordListController alloc] initWithNibName:@"RecordListController" bundle:nil];
            }
            
            currentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.view insertSubview:currentViewController.view belowSubview:tabBarView];
            [currentViewController setNavigationBarHidden:YES animated:NO];
            [tabBarView setHidden: NO];
            //controller.rootView = self;
            controller.rootView = self;
            [controller release];
            
            
            //Swami
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Switch2ImportView" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:BleConnectedNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:BleDisconnectedNotification object:nil];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];

            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];

            [timer invalidate];
            timer = nil;
            
            isWaiting = NO;
            [measuringTimer invalidate];
            measuringTimer = nil;
            
            [waveLong release];
            [waveShort release];
            [waveMiddle release];
            [animationTimer release];
            [errorAlert release];
            [bleIdentifier release];
            [connectedServices release];
            
            [banner release];
            [_tbiData release];
            [_tbiSetting release];
            [_tbiAbout release];

            
             [[EASessionController sharedController] closeSession];
             isbhConnect = NO;
             self.isScaningBLE = NO;
             self.isUsingBleDevice = NO;
             isOKtoSwitchToOtherView = YES;

            [tabBarView release];
            [currentViewController release];
            [currentViewController.view removeFromSuperview];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"FROMOBJC" forKey:@"NAVIGATION"];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pinIsOpened"];
            [[NSUserDefaults standardUserDefaults] synchronize];


            [self performSelector:@selector(navigateToSwiftClass) withObject:self afterDelay:0.3];
            
            break;
        }
            
    }
}

//Swami
-(void)navigateToSwiftClass
{
    NSLog(@"navigateToSwiftClass method called");    
    [self dismissViewControllerAnimated:YES completion:nil];

    //
    /*
    NSString * deviceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"GRXDeviceType"];
    
    bool ComplianceSTO = [[NSUserDefaults standardUserDefaults] boolForKey:@"ComplianceSTO"];
    if (ComplianceSTO)
    {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"ComplianceSTO"];
        
        if ([deviceName isEqualToString:@"GRXDeviceHeartRate"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pulse_compilance"];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceSPO2"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pulse_compilance"];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceBP"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"bp_compilance"];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceGlucose"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"glucose_compilance"];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceWeight"])
        {
             [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"weight_compilance"];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceTemperature"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"temp_compilance"];
        }

        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Dismissing VC due to coming from Compliance screen");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {*/
        
        //NEWNavigationCommented
        /*if ([deviceName isEqualToString:@"GRXDeviceHeartRate"]) {
            HeartPulseMain * vc = [[HeartPulseMain alloc] initWithNibName:@"HeartPulseMain" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceSPO2"])
        {
            PulseOximeterMainScreen * vc = [[PulseOximeterMainScreen alloc] initWithNibName:@"PulseOximeterMainScreen" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceBP"])
        {
            BPMainScreen * vc = [[BPMainScreen alloc] initWithNibName:@"BPMainScreen" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceGlucose"])
        {
            GlucoseMainView * vc = [[GlucoseMainView alloc] initWithNibName:@"GlucoseMainView" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceWeight"])
        {
            WeightMainVC * vc = [[WeightMainVC alloc] initWithNibName:@"WeightMainVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([deviceName isEqualToString:@"GRXDeviceTemperature"])
        {
            TemperatureMain * vc = [[TemperatureMain alloc] initWithNibName:@"TemperatureMain" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }//GRXDeviceTemperature*/

   // }
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (isOKtoSwitchToOtherView) {
        switch (item.tag)
        {
                
            case 0:
                [self switchView:0];
                break;
                
            case 2:
                [self switchView:2];
                break;
                
            case 3:
                [self switchView:3];
                break;
                
            case 41:
                [self switchView:41];
                break;
                
                
            default:
                [self switchView:0];
                
                // highlight the item because it is not pressed by user
                NSArray *items = tabBarView.items;
                tabBarView.selectedItem = [items objectAtIndex:0];
                break;
        }
    }
}


- (void) gotoDataViewandUploadData
{
    [self switchView:0];
    NSArray *items = tabBarView.items;
    tabBarView.selectedItem = [items objectAtIndex:0];
}
//Swami
- (void)navigateToResultVC
{
    [self switchView:888];

}


- (void) _accessoryDidConnect:(NSNotification *) notification
{
    
    EAAccessory *connectAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ( (isbhConnect) && ([[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP]  )){
        return;
    }else if( (!isbhConnect) && ([[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[connectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] )){
        
        isbhConnect = YES;
        self.isUsingBleDevice = NO;
        self.isScaningBLE = NO;
        
        [self switchView:41];
        
    }
    
    connectAccessory = nil;
}


- (void)_accessoryDidDisconnect:(NSNotification *)notification
{
    EAAccessory *disConnectAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    // we must to check it because some empty notification may be received here
    if (isbhConnect && ( [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] ))
    {
        [[EASessionController sharedController] closeSession];
        isbhConnect = NO;
        self.isScaningBLE = NO;
        self.isUsingBleDevice = NO;
        isOKtoSwitchToOtherView = YES;
    }
    
    NSMutableArray *_accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    
    for (disConnectAccessory in _accessoryList) {
        if ( (isbhConnect) && ( [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] ) ){
            return;
        }else if( (!isbhConnect) && ( [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BG] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_BP] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_WS] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_TAIDOC_MP] )){
            
            isbhConnect = YES;
            
            [self switchView:41];
            
        }
    }
    
    [_accessoryList release];
    
    disConnectAccessory = nil;
}

- (void) taidocBusCommandReceived: (NSNotification *) notification
{
    if (currentTag == 41)
    {
        // don't do anything if bluetooth meter is connected to prevent the incoming data is consumed
        return;
    }
    else if (currentTag != 40)
    {
        // not in measurement view, deal with the incoming taidoc bus command
        EASessionController *sessionController = (EASessionController *) [notification object];
        NSUInteger bytesAvailable = 0;
        NSData *data;
        int totalBytesRead = 0;
        
        while ((bytesAvailable = [sessionController readBytesAvailable]) > 0)
        {
            data = [sessionController readData:bytesAvailable];
            
            if (data)
            {
                totalBytesRead += bytesAvailable;
            }
        }
        
        if (totalBytesRead >= 8)
        {
            const unsigned char* pRecviceData = [data bytes];
            
            // start measurement when strip is inserted (no matter the strip is used or not)
            if (pRecviceData[4] == 0x41 || pRecviceData[4] == 0x44)
            {
            }
        }
    }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0: //cancel, stay
        {
            break;
        }
            
        case 1 : // yes, save and leave
        {
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(saveandleaveSattingView) userInfo:nil repeats:NO];
            break;
        }
            
        case 2:  // no, leave without save
        {
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(leavewithoutSettingView) userInfo:nil repeats:NO];
            break;
        }
    }
}


- (void) saveandleaveSattingView
{
    SettingRootViewController* settingController = (SettingRootViewController*)[currentViewController topViewController];
    settingController.settingDataedited = NO;
    [settingController saveSettingData];
    
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.settingData  =[provider getSettingData];
    
    [self switchView: tabToGo];
    
    // highlight the item because it is not pressed by user
    NSArray *items = tabBarView.items;
    tabBarView.selectedItem = [items objectAtIndex:tabToGo];
}


- (void) leavewithoutSettingView
{
    SettingRootViewController* settingController = (SettingRootViewController*)[currentViewController topViewController];
    settingController.settingDataedited = NO;
    [self switchView: tabToGo];
    
    // highlight the item because it is not pressed by user
    NSArray *items = tabBarView.items;
    tabBarView.selectedItem = [items objectAtIndex:tabToGo];
}


- (void) showWave
{
    if (animationTimer != nil)
    {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    showIndex ++;
    showIndex = showIndex % 4;
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.5];
    
    switch (showIndex) {
        case 0:
            waveLong.alpha = 0;
            waveMiddle.alpha = 0;
            waveShort.alpha = 1;
            break;
        case 1:
            waveLong.alpha = 0;
            waveMiddle.alpha = 1;
            waveShort.alpha = 0;
            break;
        case 2:
            waveLong.alpha = 1;
            waveMiddle.alpha = 0;
            waveShort.alpha = 0;
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
    
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showWave) userInfo:nil repeats:NO];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // delay for showing banner
    [self performSelector:@selector(hideBanner) withObject:nil afterDelay:1.0];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.popUpView.layer addAnimation:transition forKey:nil];
    self.popUpView.hidden = NO;

}



- (void) hideBanner
{
    [self.banner setHidden: YES];
}

//Notifying 
- (void)bleConnected:(NSNotification *) notification
{
    self.bleIdentifier = @"";
    
    if ([[[[BleSessionController sharedController] meterName] uppercaseString] hasPrefix:TAIDOC_METER_NAME_TAIDOC] || [[[[BleSessionController sharedController] meterName] uppercaseString] hasPrefix:@"GLUCORX"])
    {
        self.bleIdentifier = [[BleSessionController sharedController] bleIdentifier];
        if (!isbhConnect && currentTag != 41) {
            isbhConnect = YES;
            isUsingBleDevice=YES;
            isScaningBLE=false;
            self.isScaningBLE = NO;
            
            retryCount = 0;
            
            if ( ([[[BleSessionController sharedController] meterName] isEqualToString: TAIDOC_METER_NAME_FORA_BP8]) ) {
                
                isWaiting = NO;
                
                [measuringTimer invalidate];
                measuringTimer = nil;
                //SwamiN 10 - 3
                timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timeoutcheckIsMeasuring:) userInfo:nil repeats:NO];
            }
            else  {
                
                [self switchView:41];
            }
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BleConnectedNotification object:nil];
    }
}



- (void) switch2ImportView {
    [timer invalidate];
    timer = nil;
    [self switchView:41];
}

- (void) timeoutcheckIsMeasuring: (NSTimer *)theTimer
{
    if (retryCount <  2)
    {
        //if (meterController != nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeoutcheckIsMeasuring:) userInfo:nil repeats:NO];
        retryCount++;
        //}
    }
    else  {
        retryCount = 0;
        [timer invalidate];
        timer = nil;
        
        if(!isWaiting) {
            [self switchView:41];
            
        }
        
    }
}



//Repeating Method
- (void)connectToBLE
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleDisconnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleDisconnected:) name:BleDisconnectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnected:) name:BleConnectedNotification object:nil];
    
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.mainSettingData  =[provider getSettingData];
    [provider release];
    
    [[BleSessionController sharedController] setSettingData:self.mainSettingData];
    [[BleSessionController sharedController] setScanOnly:NO];
    [[BleSessionController sharedController] setBleDeviceConnected:NO];
    [[BleSessionController sharedController] setPeripheralDelegate:self];
    
    [self.bgMeterProcessor closeSession];
    [self.bgMeterProcessor removeNotify];
    [self.bgMeterProcessor release];
    self.bgMeterProcessor = nil;
    
    if (self.bgMeterProcessor == nil) {
        self.bgMeterProcessor = [[MeterController alloc] init];
        self.bgMeterProcessor.meterType = 1;
        if ([self.bgMeterProcessor openSession])
        {
            self.isUsingBleDevice = YES;
            self.isScaningBLE = YES;
        }
    }
    else//
    {
        
        [self.bgMeterProcessor closeSession];
        
        [self.bgMeterProcessor removeNotify];
        [self.bgMeterProcessor release];//20150914
        self.bgMeterProcessor = nil;//20150914
        self.bgMeterProcessor = [[MeterController alloc] init];//20150914
        
        self.bgMeterProcessor.meterType = 1;//using BLE
        if ([self.bgMeterProcessor openSession])
        {//20150914
            self.isUsingBleDevice = YES;
            self.isScaningBLE = YES;
        }
        
    }
}

- (void) bleDisconnected:(NSNotification *) notification
{
    if (bgMeterProcessor != nil) {
        [bgMeterProcessor closeSession];
        [self.bgMeterProcessor removeNotify];
        [bgMeterProcessor release];
        bgMeterProcessor = nil;
    }
    
    
    if (isextConnect) {
        isextConnect = NO;
    }else if (isbhConnect) {
        isbhConnect = NO;
    }
    isUsingBleDevice = NO;
    isScaningBLE = NO;
    isImportingOBJC = 0;
    
    EAAccessory *disConnectAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    NSMutableArray *_accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    
    for (disConnectAccessory in _accessoryList) {
        if ( (isbhConnect || isextConnect || isUsingBleDevice) && ([[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_BG_EXT] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_BG_BLUTOOTH] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_MP_BLUTOOTH]) ) {
            return;
        }else if( (!isbhConnect && !isextConnect && !isUsingBleDevice) && ([[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_BG_EXT] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_BG_BLUTOOTH] || [[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_MP_BLUTOOTH]))
        {
            if ([[disConnectAccessory protocolStrings] containsObject:PROTOCOL_STRING_BG_BLUTOOTH])
            {
                isbhConnect = YES;
                
                [self switchView:41];//importRootControler
                
            }
            
        }
    }
    
    [_accessoryList release];
    
    disConnectAccessory = nil;
    
    isbhConnect=false;
    
   //Need to change swami
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectToBLE) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleDisconnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleConnectedNotification object:nil];

}
-(void)gotoForeground
{
#ifdef BLE
    //enable for ble
    if (!isextConnect && !isbhConnect  && !isScaningBLE) {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectToBLE) userInfo:nil repeats:NO];
    }
#endif
}

- (void) discoveryDidRefresh
{
    int itest=0;
    itest++;
    //[sensorsTable reloadData];
}

/** Peripheral connected or disconnected */
- (void) alarmServiceDidChangeStatus:(LeW65AlarmService*)service
{
    if ( [[service peripheral] state] == CBPeripheralStateConnected )
    {
        if (![connectedServices containsObject:service])
        {
            [connectedServices addObject:service];
        }
    }
    else
    {
        if ([connectedServices containsObject:service]) {
            [connectedServices removeObject:service];
        }
    }
}

/****************************************************************************/
/*                  LeTemperatureAlarm Interactions                         */
/****************************************************************************/
- (LeW65AlarmService*) serviceForPeripheral:(CBPeripheral *)peripheral
{
    for (LeW65AlarmService *service in connectedServices) {
        if ( [[service peripheral] isEqual:peripheral] ) {
            return service;
        }
    }
    
    return nil;
}

- (void)didEnterBackgroundNotification:(NSNotification*)notification
{
    NSLog(@"Entered background notification called.");
    for (LeW65AlarmService *service in self.connectedServices) {
        [service enteredBackground];
    }
}

- (void)didEnterForegroundNotification:(NSNotification*)notification
{
    NSLog(@"Entered foreground notification called.");
    for (LeW65AlarmService *service in self.connectedServices) {
        [service enteredForeground];
    }
}


//W65 回傳的結果字串 , from BLE Controller
- (void) w65ResultResponse: (NSString*) response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething:response];
    });
}


- (void) doSomething: (NSString*) response
{
    response =[response uppercaseString];
    if(response.length<3)
        return;
    NSString *w65OnResultString=@"";
    w65OnResultString= [response substringWithRange:NSMakeRange(0,2)] ;
    
    if([w65OnResultString isEqual:w65ResultString])
    {
        [self switchView:411];//import w65 result only//
    }
    
}



-(bool ) checkResultIsValid:(NSString*) tmpString
{
    if([tmpString isEqual:@"FFFF"])
        return false;
    if([tmpString isEqual:@"ffff"])
        return false;
    if([tmpString isEqual:@"FF"])
        return false;
    if([tmpString isEqual:@"ff"])
        return false;
    
    return true;
}



-(NSInteger) convertHexStringToInteger:(NSString*) hexString
{
    unsigned result = 0;
    @try
    {
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&result];
    }
    @catch (NSException *exception)
    {
        return 0;
    }
    
    return result;
}

@end
