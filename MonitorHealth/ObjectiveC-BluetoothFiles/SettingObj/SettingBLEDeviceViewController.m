//
//  SettingBLEDeviceViewController.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "SettingBLEDeviceViewController.h"
#import "TDSettingContentProvider.h"
#import "TaidocBleConnectedList.h"


#define DRED_COLOR [UIColor colorWithRed:171.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]

@interface SettingBLEDeviceViewController ()

@end

@implementation SettingBLEDeviceViewController

@synthesize savedBLETableView;
@synthesize foundBLETableView;
@synthesize btnEdit;
@synthesize tapRecognizer;
@synthesize scanBLEDeviceView;
@synthesize scanBLEDeviceViewRadius;
@synthesize btnCancel;
@synthesize btnScan;
@synthesize spinner;
@synthesize StatusToplblCons;
@synthesize devicePopUpView;
@synthesize deviceTypeHeaderLabel,deviceIDLabel,deviceNameLabel;

- (void)dealloc
{
    [self.savedBLETableView removeObserver:self forKeyPath:@"contentSize" context:NULL];
    
    [[BleSessionController sharedController] setDiscoveryDelegate:nil];
    
    
    [savedBLETableView release];
    [foundBLETableView release];
    [btnEdit release];
    [scanBLEDeviceView release];
    [scanBLEDeviceViewRadius release];
    [btnCancel release];
    [btnScan release];
    [spinner release];
    [StatusToplblCons release];
    [devicePopUpView release];
    [deviceTypeHeaderLabel release];
    [deviceNameLabel release];
    [deviceIDLabel release];

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //Clean the cell before design it
    for (id subView in [self.view subviews])
    {
        UIView *tmpView = (UIView *)subView;
        if (tmpView.tag == 88) {
            [tmpView removeFromSuperview];
        }
    }
    
    
    if ([arryForSavedBLEDevice count] > 1) {
        [self.savedBLETableView setFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y, self.savedBLETableView.frame.size.width, [arryForSavedBLEDevice count] * 40)];
        viewForSaveBLETableViewRadius = [[UIView alloc] initWithFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y + 10, self.savedBLETableView.frame.size.width, self.savedBLETableView.frame.size.height)];
    }else if ([arryForSavedBLEDevice count] == 1) {
        [self.savedBLETableView setFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y, self.savedBLETableView.frame.size.width, [arryForSavedBLEDevice count] * 40)];
        viewForSaveBLETableViewRadius = [[UIView alloc] initWithFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y + 10, self.savedBLETableView.frame.size.width, self.savedBLETableView.frame.size.height)];
    }else{
        viewForSaveBLETableViewRadius = [[UIView alloc] initWithFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y + 10, self.savedBLETableView.frame.size.width, 40)];
        [self.savedBLETableView setFrame:CGRectMake(self.savedBLETableView.frame.origin.x, self.savedBLETableView.frame.origin.y, self.savedBLETableView.frame.size.width, 55)];
    }
    
    viewForSaveBLETableViewRadius.layer.backgroundColor = [UIColor clearColor].CGColor;
    viewForSaveBLETableViewRadius.layer.cornerRadius = 0.0;
    viewForSaveBLETableViewRadius.tag = 88;
    viewForSaveBLETableViewRadius.layer.frame = self.savedBLETableView.frame;
    viewForSaveBLETableViewRadius.layer.borderColor = [UIColor grayColor].CGColor;
    viewForSaveBLETableViewRadius.layer.borderWidth = 0.5;
    //
    viewForSaveBLETableViewRadius.userInteractionEnabled = NO;
    
    if ([arryForSavedBLEDevice count] > 0) {
        btnEdit.alpha = 1;
    }else{
        btnEdit.alpha = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Settings BLEDevice viewDidLoad");

    //SwamiN
    NSString * deviceConnectedType = [[NSUserDefaults standardUserDefaults] objectForKey:@"GRXDeviceType"];
    NSString * deviceFullName = [self getDeviceFullName:deviceConnectedType];

    deviceTypeHeaderLabel.text = [NSString stringWithFormat:@"Retrieving Value from %@ Device",deviceFullName];
    NSString * deviceConnectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralName"];
    deviceConnectedName = @"GRx";

    deviceNameLabel.text = deviceConnectedName;

    // Do any additional setup after loading the view from its nib.
    btnForAddDevice=nil;
    
    [[BleSessionController sharedController] setDiscoveryDelegate:nil];
    
    [self.rootView.tabBarView setHidden:YES];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 1024.0) {
        self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 770, 1024);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 568.0){//iPhone5
        self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 320, 568);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 667.0){//iPhone6//6s//7//7s
        self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 375, 667);
        [self.view addSubview:devicePopUpView];
    }
    else if (height == 736.0){//iPhone6plus//iPhone6splus//iPhone7plus//iPhone8plus
        self.StatusToplblCons.constant = 60;
        self.devicePopUpView.frame = CGRectMake(0, 0, 414, 736);
        [self.view addSubview:devicePopUpView];
    }


    
    arryForSavedBLEDevice = [[NSMutableArray alloc] init];
    arryForFoundBLEDevice = [[NSMutableArray alloc] init];
    arryForAddBLEDevice = [[NSMutableArray alloc] init];
    
    isScaningBLE = NO;
    
    TDSettingContentProvider *provider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.settingData  =[provider getSettingData];
    [provider release];
    
    
    NSArray* saveBLEArray = [TaidocBleConnectedList readBleSavedUUIDAndDeviceName];
    
    for(int i=0;i< [saveBLEArray count];++i)
    {
        NSString *deviceUUIDAndDeviceName=[saveBLEArray objectAtIndex:i];
        [arryForSavedBLEDevice addObject:deviceUUIDAndDeviceName];
    }
    
    
    [self.savedBLETableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.savedBLETableView.frame.size.width, 1)];
    if ([arryForSavedBLEDevice count] > 1) {
        v.backgroundColor = [UIColor whiteColor];
    }else{
        v.backgroundColor = [UIColor clearColor];
    }
    
    [self.savedBLETableView setTableFooterView:v];
    
    if ([self.savedBLETableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.savedBLETableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.foundBLETableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.foundBLETableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    scanBLEDeviceView.alpha=0;
    [self stopScanForBLE];
    isScaningBLE=false;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(215, 103);
    [self.view addSubview:spinner];
    
    //Swami
    [self ScanButtonAction:nil];
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


- (IBAction)helpBackBtn:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBackButton:(id)sender
{
    if (self.edited) {
        //Swami
        
        [self performSelector:@selector(saveandleave) withObject:self afterDelay:0.1];

        /*SettingBleDialog *pSettingBleDialog =[[SettingBleDialog alloc] initWithNibName:@"SettingBleDialog" bundle:nil];
        [[self.rootView view] addSubview:pSettingBleDialog.view];
        pSettingBleDialog.delegate=self;
        
        [pSettingBleDialog.buttonIndex1 setTitle:NSLocalizedStringFromTable(@"String_Alert_Yes", @"MyLocalizable", nil) forState:UIControlStateNormal];
        [pSettingBleDialog.buttonIndex2 setTitle:NSLocalizedStringFromTable(@"String_Alert_No", @"MyLocalizable", nil) forState:UIControlStateNormal];
        [pSettingBleDialog.buttonIndex3 setTitle:NSLocalizedStringFromTable(@"String_Alert_Cancel", @"MyLocalizable", nil) forState:UIControlStateNormal];
        [pSettingBleDialog.dialogTitle setText:NSLocalizedStringFromTable(@"String_RootView_AskForSave", @"MyLocalizable", nil)];
        [pSettingBleDialog settitleLabe:NSLocalizedStringFromTable(@"String_RootView_AskForSave", @"MyLocalizable", nil)];
        //20150410 custom dialog end*/
        
        
    }else{
        [self stopScanForBLE];
        [self.rootView.tabBarView setHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
        //[self tryToconnectToBLE];
        [self.rootView connectToBLE];
        [self.view removeFromSuperview];
        
        [self exitSetting];
    }
    
    
}

-(void) exitSetting {
    [self.rootView.tabBarView setSelectedItem:self.rootView.tbiData];
    [self.rootView switchView:0];
}

- (void) onSettingBleDialogButtonClick:(NSInteger) eventButtonIndex
{
    switch(eventButtonIndex)
    {
        case 3: //cancel, stay
        {
            break;
        }
            
        case 1 : // yes, save and leave
        {
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(saveandleave) userInfo:nil repeats:NO];
            break;
        }
            
        case 2:  // no, leave without save
        {
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(leavewithoutsave) userInfo:nil repeats:NO];
            break;
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
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(saveandleave) userInfo:nil repeats:NO];
            break;
        }
            
        case 2:  // no, leave without save
        {
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(leavewithoutsave) userInfo:nil repeats:NO];
            break;
        }
    }
}

- (void) saveSettingData
{
    [TaidocBleConnectedList clearMemoryConnectedList];//clear Plist files
    NSArray *strSplit;
    for (int i = 0; i < [arryForSavedBLEDevice count]; i++)
    {
        NSString* saveUUIDandDevicename=[arryForSavedBLEDevice objectAtIndex:i];
        strSplit = [saveUUIDandDevicename componentsSeparatedByString:@"###"];
        
        NSString *strPeripheralForSaveName = [strSplit objectAtIndex:0];
        NSString *strPeripheralForSaveUUID = [strSplit objectAtIndex:1];
        
        [TaidocBleConnectedList writeBleUUIDToMemory:strPeripheralForSaveUUID stringOfDeviceName:strPeripheralForSaveName];
    }
    
    
}

- (void) saveandleave
{
    [self saveSettingData];
    [self stopScanForBLE];
    [self.rootView.tabBarView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    //[self tryToconnectToBLE];//程式CONNECT後無EVENT進來，故改成[self.rootView connectToBLE]//
    [self exitSetting];
    [self.rootView connectToBLE];
    
    
}

- (void) leavewithoutsave
{
    [self stopScanForBLE];
    [self.rootView.tabBarView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    [self exitSetting];
    [self.rootView connectToBLE];
    
}



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.savedBLETableView) {
        return [arryForSavedBLEDevice count];
        
        
    }else{//foundBLETableView//
        return [arryForFoundBLEDevice count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=nil;
    
    if (tableView == self.savedBLETableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        txtField=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, 320, 39)];
        txtField.tag = indexPath.row;
        txtField.backgroundColor = [UIColor clearColor];
        [txtField setDelegate:self];
        [txtField setEnabled:NO];
        
        [txtField setTextColor:[UIColor colorWithRed:91.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]];
        //if (cell == nil)
        {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        [[cell textLabel] setText:@""];
        [txtField setText:@""];
        
        if (indexPath.row <[arryForSavedBLEDevice count])
        {
            NSInteger row = [indexPath row];
            
            NSString *strPeripheralForSavedBLEDevice = [arryForSavedBLEDevice objectAtIndex:row];
            NSArray *strSplit;
            strSplit = [strPeripheralForSavedBLEDevice componentsSeparatedByString:@"###"];
            
            
            NSString *strPeripheralForSaveName = [strSplit objectAtIndex:0];
            
            if (strPeripheralForSaveName.length > 0) {
                [txtField setText:strPeripheralForSaveName];
            }
            
            [cell.contentView addSubview:txtField];
            ///////////////add remove button begin
            NSInteger cellHigh = cell.frame.size.height;
            btnForRemoveDevice=[[UIButton alloc]initWithFrame:CGRectMake(220, 3, 76, cellHigh-(6*2))];
            
            btnForRemoveDevice.tag = indexPath.row;
            
            [btnForRemoveDevice setBackgroundColor:[UIColor lightGrayColor]];
            
            [btnForRemoveDevice setTitle:NSLocalizedStringFromTable(@"String_Alert_Remove", @"MyLocalizable", nil) forState:UIControlStateNormal];
            
            [btnForRemoveDevice.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
            [btnForRemoveDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnForRemoveDevice addTarget:self action:@selector(DeleteButtonBleSaved:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:btnForRemoveDevice];
            
            UIImageView *myaddSpepareLineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, (cell.frame.origin.y)+(cell.frame.size.height)-9, cell.frame.size.width, 1)];
            
            [myaddSpepareLineView setImage:[UIImage imageNamed:@"pair_block06_1.png"]];
            [cell.contentView addSubview:myaddSpepareLineView];
            //}
        }
        
    }else{//foundBLETableView//
        if(arryForFoundBLEDevice.count!=0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            int count = 0;
            if(self.editing && indexPath.row != 0)
                count = 1;
            
            cell.backgroundColor = [UIColor clearColor];
            
            
            btnForAddDevice=[[UIButton alloc]initWithFrame:CGRectMake(190, 3, 68, 26)];
            
            btnForAddDevice.tag = indexPath.row;
            
            [btnForAddDevice setBackgroundColor:DRED_COLOR];
            
            [btnForAddDevice setTitle:NSLocalizedStringFromTable(@"String_Alert_Add", @"MyLocalizable", nil) forState:UIControlStateNormal];
            
            
            [btnForAddDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnForAddDevice.titleLabel setFont:[UIFont systemFontOfSize:15]];  //
            
            [btnForAddDevice addTarget:self action:@selector(AddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger		row	= [indexPath row];
            
            NSString *strPeripheralForFoundBLEDevice = [arryForFoundBLEDevice objectAtIndex:row];
            NSArray *strSplit;
            strSplit = [strPeripheralForFoundBLEDevice componentsSeparatedByString:@"###"];
            
            NSString *strPeripheralForFoundName = [strSplit objectAtIndex:0];
            
            
            if (strPeripheralForFoundName.length > 0) {
                [[cell textLabel] setText:strPeripheralForFoundName];
                [[cell textLabel]  setTextColor:[UIColor colorWithRed:91.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]];
                [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14]];
            }
            [cell.contentView addSubview:btnForAddDevice];//0911
            
        }//end for if(arryForFoundBLEDevice.count!=0)
        
    }
    if(cell!=nil)
    {
        return cell;
    }
    else
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.foundBLETableView) {
        [arryForAddBLEDevice addObject:[arryForFoundBLEDevice objectAtIndex:indexPath.row]];
    }
}

- (IBAction)AddButtonAction:(id)sender
{
    NSLog(@"pair_button sender.tag : %ld",(long)[sender tag]);
    [btnForAddDevice setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pair_button002" ofType:@"png"]] forState:UIControlStateNormal];
    
    [arryForAddBLEDevice addObject:[arryForFoundBLEDevice objectAtIndex:[sender tag]]];
    
    for (int i = 0; i < [arryForAddBLEDevice count]; i++) {
        [arryForSavedBLEDevice addObject:[arryForAddBLEDevice objectAtIndex:i]];
        [arryForFoundBLEDevice removeObjectsInArray:arryForAddBLEDevice];
        
        [self.savedBLETableView reloadData];
        [self.foundBLETableView reloadData];
        
        if (arryForSavedBLEDevice.count > 5) {
            [self.savedBLETableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arryForSavedBLEDevice.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    [arryForAddBLEDevice removeAllObjects];
    
    self.edited = YES;
    
    //swami
    [self stopScanForBLE];
    
    // fade in animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.scanBLEDeviceView.alpha = 0;
    //[self.btnScan setTitle:@"  Search" forState:UIControlStateNormal];
    [self.btnScan setTitle:NSLocalizedStringFromTable(@"String_Alert_Search", @"MyLocalizable", nil) forState:UIControlStateNormal];
    [UIView commitAnimations];
    
    
}

- (IBAction)DeleteButtonBleSaved:(id)sender
{
    self.edited=true;
    UIButton *delButton =sender;
    
    [arryForSavedBLEDevice removeObjectAtIndex:delButton.tag];
    [self.savedBLETableView reloadData];
}


- (IBAction)DeleteButtonAction:(id)sender
{
    
    [arryForSavedBLEDevice removeLastObject];
    [self.savedBLETableView reloadData];
}

- (IBAction) EditSavedBLEDeviceTable:(id)sender
{
    if(self.savedBLETableView.editing)
    {
        [super setEditing:NO animated:NO];
        [self.savedBLETableView setEditing:NO animated:NO];
        [self.savedBLETableView reloadData];
        [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.savedBLETableView setEditing:YES animated:YES];
        [self.savedBLETableView reloadData];
        [self.btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
}



#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.

#pragma BLE
- (void) bleDisconnected:(NSNotification *) notification
{
    [arryForFoundBLEDevice removeAllObjects];
    if (self.rootView.bgMeterProcessor != nil) {
        [self.rootView.bgMeterProcessor closeSession];
        [self.rootView.bgMeterProcessor removeNotify];
        [self.rootView.bgMeterProcessor release];
        self.rootView.bgMeterProcessor = nil;
    }
}

- (IBAction)CancelButtonAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    viewForSaveBLETableViewRadius.alpha = 1;
    self.scanBLEDeviceView.alpha = 0;
    //[self.btnScan setTitle:@"  Search" forState:UIControlStateNormal];
    [self.btnScan setTitle:NSLocalizedStringFromTable(@"String_Alert_Search", @"MyLocalizable", nil) forState:UIControlStateNormal];
    [UIView commitAnimations];
    
    [spinner stopAnimating];
    [self stopScanForBLE];
    
}

- (IBAction)ScanButtonAction:(id)sender
{
    [self discoveryDidRefresh];
    
    
    [self.savedBLETableView setEditing:NO animated:NO];
    [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    
    if(!isScaningBLE)
    {
        [self.btnScan setTitle:NSLocalizedStringFromTable(@"String_Alert_Stop", @"MyLocalizable", nil) forState:UIControlStateNormal];
        
        [spinner startAnimating];
        
        [self scanForBLE];
        
        isScaningBLE=true;
    }
    else
    {
        [self.btnScan setTitle:NSLocalizedStringFromTable(@"String_Alert_Search", @"MyLocalizable", nil) forState:UIControlStateNormal];
        
        [spinner stopAnimating];
        
        [self stopScanForBLE];
        isScaningBLE=false;
    }
}

- (void)scanForBLE
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleDisconnected:) name:BleDisconnectedNotification object:nil];
    
    [[BleSessionController sharedController] setDiscoveryDelegate:(id)self];
    [[BleSessionController sharedController] setSettingData:self.settingData];
    [[BleSessionController sharedController] setScanOnly:YES];
    
    if (self.rootView.bgMeterProcessor != nil) {
        [self.rootView.bgMeterProcessor closeSession];
        [self.rootView.bgMeterProcessor removeNotify];
        [self.rootView.bgMeterProcessor release];
        self.rootView.bgMeterProcessor = nil;
    }
    
    [arryForFoundBLEDevice removeAllObjects];
    
    self.rootView.bgMeterProcessor = [[MeterController alloc] init];
    self.rootView.bgMeterProcessor.meterType = 1;
    if ([self.rootView.bgMeterProcessor openSession])
    {
        isScaningBLE = YES;
    }
}

- (void)stopScanForBLE
{
    if (self.rootView.bgMeterProcessor != nil) {
        [self.rootView.bgMeterProcessor closeSession];
        [self.rootView.bgMeterProcessor removeNotify];
        [self.rootView.bgMeterProcessor release];
        self.rootView.bgMeterProcessor = nil;
    }
    
    isScaningBLE = NO;
}

#pragma mark -
#pragma mark BLEDiscoveryDelegate
/****************************************************************************/
/*                       LeDiscoveryDelegate Methods                        */
/****************************************************************************/
- (void) discoveryDidRefresh
{
    
    BOOL aleradyAddedDevice = NO;
    NSMutableArray *arryForTempProcessDevice = [[NSMutableArray alloc] init];
    
    arryForTempProcessDevice = [[BleSessionController sharedController] foundPeripherals];
    NSLog(@"arryForTempProcessDevice : %@",arryForTempProcessDevice);

    for (int i = 0; i < [arryForTempProcessDevice count]; i++) {
        
        if (aleradyAddedDevice) {
            continue;
        }
        
        CBPeripheral *peripheralForAddBLEDevice = (CBPeripheral*)[arryForTempProcessDevice objectAtIndex:i];
        
        NSString *strPeripheralForAddName = [peripheralForAddBLEDevice name];
        NSString *strPeripheralForAddUUID = [[peripheralForAddBLEDevice identifier] UUIDString];
        NSLog(@"PERIPHERAL NAME : %@",strPeripheralForAddName);
        NSLog(@"PERIPHERAL UUID : %@",strPeripheralForAddUUID);
        if ([arryForSavedBLEDevice count] > 0) {
            NSLog(@"arryForSavedBLEDevice : %@",arryForSavedBLEDevice);

            for (int j = 0; j < [arryForSavedBLEDevice count]; j++) {
                NSString *strPeripheralForSavedBLEDevice = [arryForSavedBLEDevice objectAtIndex:j];
                NSArray *strSplit;
                strSplit = [strPeripheralForSavedBLEDevice componentsSeparatedByString:@"###"];
                NSString *strPeripheralForSaveUUID = [strSplit objectAtIndex:1];
                
                if ([strPeripheralForSaveUUID isEqualToString:strPeripheralForAddUUID]) {
                    aleradyAddedDevice = YES;
                    continue;
                }
            }
            
            if (!aleradyAddedDevice)
            {
                if(![arryForFoundBLEDevice containsObject:[NSString stringWithFormat:@"%@###%@", strPeripheralForAddName, strPeripheralForAddUUID]])
                {
                    [arryForFoundBLEDevice addObject:[NSString stringWithFormat:@"%@###%@", strPeripheralForAddName, strPeripheralForAddUUID]];
                }
                //swami
                NSLog(@"arryForFoundBLEDevice : %@",arryForFoundBLEDevice);
                [self.foundBLETableView reloadData];
            }
        }else
        {
            if(![arryForFoundBLEDevice containsObject:[NSString stringWithFormat:@"%@###%@", strPeripheralForAddName, strPeripheralForAddUUID]])
            {
                [arryForFoundBLEDevice addObject:[NSString stringWithFormat:@"%@###%@", strPeripheralForAddName, strPeripheralForAddUUID]];
            }
            
            [self.foundBLETableView reloadData];
        }
    }
    
    if ([arryForFoundBLEDevice count] > 0) {
        
        NSLog(@"Final arryForFoundBLEDevice : %@",arryForFoundBLEDevice);

        [spinner stopAnimating];
        
        self.scanBLEDeviceViewRadius.layer.cornerRadius = 0;
        self.scanBLEDeviceViewRadius.tag = 88;
        self.scanBLEDeviceViewRadius.layer.frame = self.scanBLEDeviceViewRadius.frame;
        self.scanBLEDeviceViewRadius.layer.borderColor = [UIColor grayColor].CGColor;
        //self.scanBLEDeviceViewRadius.layer.borderWidth = 0.5;
        self.scanBLEDeviceViewRadius.layer.borderWidth = 0;
        
        self.scanBLEDeviceViewRadius.userInteractionEnabled = YES;
        
        // fade in animation
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        viewForSaveBLETableViewRadius.alpha = 0;
        if ([arryForFoundBLEDevice count] > 0)
        {
            self.scanBLEDeviceView.alpha = 1;
            [self.foundBLETableView reloadData];
            
        }
        [UIView commitAnimations];
        
        isScaningBLE = NO;
        
        //Swami
        NSLog(@"need to add");
        [self AddButtonAction:nil];
        [self performSelector:@selector(pressBackButton:) withObject:self afterDelay:0.1];

    }
    
}



- (void) w65ResultResponse: (NSString*) response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self rootView ] doSomething:response];
    });
    
}


@end
