//
//  SettingRootViewController.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "SettingRootViewController.h"
#import "TDSettingContentProvider.h"
#import "SettingBLEDeviceViewController.h"

@interface SettingRootViewController ()

@end

@implementation SettingRootViewController
@synthesize rootView;
@synthesize settingData;
@synthesize settingDataedited;
@synthesize btnBle;

- (void)dealloc
{
    [rootView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    settingDataedited = NO;
    
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    settingData = [provider getSettingData];
    [provider release];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) saveSettingData
{
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    [provider updateSettingData: settingData];
    [provider release];
}


@end
