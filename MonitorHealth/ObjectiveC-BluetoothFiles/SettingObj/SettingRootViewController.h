//
//  SettingRootViewController.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarRootViewController1.h"

@interface SettingRootViewController : UIViewController
{
    
}
@property (nonatomic, retain) TabBarRootViewController1 *rootView;
@property (nonatomic, retain) TDSettingData *settingData;
@property (nonatomic, readwrite) BOOL settingDataedited;
@property (strong, nonatomic) IBOutlet UIButton *btnBle;

- (void) saveSettingData;

@end
