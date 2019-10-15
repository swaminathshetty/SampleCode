//
//  SettingBLEDeviceViewController.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarRootViewController1.h"
#import "MeterController.h"
#import "SettingBleDialog.h"

@interface SettingBLEDeviceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SettingBleDialogProtocol>
{
    NSMutableArray *arryForSavedBLEDevice;
    NSMutableArray *arryForFoundBLEDevice;
    NSMutableArray *arryForAddBLEDevice;
    int foundBLEDeviceSelectedRow;
    UITextField *txtField;
    UIAlertView *errorAlert;
    UIButton *btnForAddDevice;
    UIButton *btnForRemoveDevice;
    
    UIView *viewForSaveBLETableViewRadius;
    BOOL isScaningBLE;
}
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *StatusToplblCons;

@property (strong, nonatomic) IBOutlet UIView *devicePopUpView;
@property (strong, nonatomic) IBOutlet UILabel *deviceTypeHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (nonatomic, retain) TabBarRootViewController1 *rootView;
@property (nonatomic, retain) TDSettingData *settingData;
@property (nonatomic, retain) IBOutlet UITableView *savedBLETableView;
@property (nonatomic, retain) IBOutlet UITableView *foundBLETableView;
@property (nonatomic, retain) IBOutlet UIButton *btnEdit;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, readwrite) BOOL edited;
@property (nonatomic, retain) IBOutlet UIView *scanBLEDeviceView;
@property (nonatomic, retain) IBOutlet UIView *scanBLEDeviceViewRadius;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIButton *btnScan;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;


- (IBAction)AddButtonAction:(id)sender;
- (IBAction)DeleteButtonAction:(id)sender;
- (IBAction)DeleteButtonBleSaved:(id)sender;

- (IBAction)EditSavedBLEDeviceTable:(id)sender;
- (IBAction)ScanButtonAction:(id)sender;
- (void)scanForBLE;
- (void)discoveryDidRefresh;
- (IBAction)pressBackButton:(id)sender;
- (IBAction)CancelButtonAction:(id)sender;
- (void)stopScanForBLE;


@end
