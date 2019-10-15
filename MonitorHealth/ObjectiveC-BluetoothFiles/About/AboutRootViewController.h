//
//  AboutRootViewController.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarRootViewController1.h"

@interface AboutRootViewController : UIViewController
@property (nonatomic, retain) TabBarRootViewController1 *rootView;
@property (retain, nonatomic) IBOutlet UILabel *versionString;

@end
