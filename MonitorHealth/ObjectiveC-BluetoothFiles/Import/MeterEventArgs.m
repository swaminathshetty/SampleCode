//
//  MeterEventArgs.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "MeterEventArgs.h"

@implementation ProjectInfoEventArgs

@synthesize userNumber;
@synthesize projectNo;
@synthesize subModel;

- (void) dealloc
{
    
    [projectNo release];
    [subModel release];
    [super dealloc];
}

@end
