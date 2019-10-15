//
//  SettingBleDialog.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingBleDialogProtocol <NSObject>

- (void) onSettingBleDialogButtonClick:(NSInteger) eventButtonIndex;
@end

@interface SettingBleDialog : UIViewController
{
    UIButton *buttonIndex1;
    UIButton *buttonIndex2;
    UIButton *buttonIndex3;
    UILabel *dialogTitle;
}

@property (retain, nonatomic) IBOutlet UIButton *buttonIndex1;
@property (retain, nonatomic) IBOutlet UIButton *buttonIndex2;
@property (retain, nonatomic) IBOutlet UIButton *buttonIndex3;
@property (retain, nonatomic) IBOutlet UILabel *dialogTitle;
@property (nonatomic, assign)  id <SettingBleDialogProtocol> delegate;

- (IBAction) buttonIndex1click:(id)sender;
- (IBAction) buttonIndex2click:(id)sender;
- (IBAction) buttonIndex3click:(id)sender;
-(void)settitleLabe:(NSString*) labelText;

@end
