//
//  SettingBleDialog.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "SettingBleDialog.h"

@interface SettingBleDialog ()

@end

@implementation SettingBleDialog

@synthesize buttonIndex1;
@synthesize buttonIndex2;
@synthesize buttonIndex3;
@synthesize dialogTitle;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (IBAction) buttonIndex1click:(id)sender
{
    if(delegate!=nil)
    {
        [delegate onSettingBleDialogButtonClick:1];
    }
    
    [[self view] removeFromSuperview];
    
}
- (IBAction) buttonIndex2click:(id)sender
{
    if(delegate!=nil)
    {
        [delegate onSettingBleDialogButtonClick:2];
    }
    [[self view] removeFromSuperview];
    
}
- (IBAction) buttonIndex3click:(id)sender
{
    if(delegate!=nil)
    {
        [delegate onSettingBleDialogButtonClick:3];
    }
    [[self view] removeFromSuperview];
    
}

-(void)settitleLabe:(NSString*) labelText;
{
    [self.dialogTitle setText:labelText];
    [dialogTitle setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
}

@end
