//
//  TDContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDContentProvider.h"

@implementation TDContentProvider
@synthesize databaseName, databasePath;

- (id) initWithDatabaseName:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        self.databaseName = name;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.databasePath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    }
    
    return self;
}

- (void) dealloc
{
    [databaseName release];
    [databasePath release];
    
    [super dealloc];
}

@end
