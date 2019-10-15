//
//  TDContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> // Import the SQLite database framework

@interface TDContentProvider : NSObject
{
    NSString *databaseName;
    NSString *databasePath;
}

@property (nonatomic, retain) NSString *databaseName;
@property (nonatomic, retain) NSString *databasePath;

- (id) initWithDatabaseName:(NSString *)name ;

@end
