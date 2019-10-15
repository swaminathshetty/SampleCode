//
//  AboutRootViewController.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "AboutRootViewController.h"

@interface AboutRootViewController ()

@end

@implementation AboutRootViewController


@synthesize rootView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // set version string  //2017042101 Kenneth Chan, move here
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSArray *strSplit;
    strSplit = [strVersion componentsSeparatedByString:@"."];
    NSLog(@"strSplit : %@",strSplit);
    NSLog(@"Index 0: %@",[formatter stringFromNumber:[NSNumber numberWithInt:[[strSplit objectAtIndex:0] intValue]]]);
    NSLog(@"Index 1: %@",[formatter stringFromNumber:[NSNumber numberWithInt:[[strSplit objectAtIndex:1] intValue]]]);

    NSString *sVersion=[NSString stringWithFormat: @"v%@ (%@)", [NSString stringWithFormat:@"%@.%@",[formatter stringFromNumber:[NSNumber numberWithInt:[[strSplit objectAtIndex:0] intValue]]], [formatter stringFromNumber:[NSNumber numberWithInt:[[strSplit objectAtIndex:1] intValue]]]], [formatter stringFromNumber:[NSNumber numberWithInt:[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] intValue]]]];
    
    //20161128 Kenneth Chan, modify from ForaCare to TaiDoc Technology Corp for copyright
    [self.versionString setText:[NSString stringWithFormat:@"Copyright %@ TaiDoc Technology Corp. All Rights Reserved.", [formatter stringFromNumber:[NSNumber numberWithInt:2018]]]];
    
    [self.versionString setText : [[self.versionString text] stringByAppendingFormat:@" %@",sVersion]];
    [formatter release];
}


- (IBAction)pressBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    
    //swami

    /*[self.rootView.tabBarView setSelectedItem:self.rootView.tbiData];
    [self.rootView switchView:0];*/
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    [_versionString release];
    [super dealloc];
}
@end
