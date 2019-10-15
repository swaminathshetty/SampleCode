//
//  TDTPDataContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDTPDataContentProvider.h"

@implementation TDTPDataContentProvider
- (void) addTPData: (TDTPData *) data;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // read test
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        
        sql = @"INSERT INTO MData(MType, Value1, Value4, RawData, MDateTime, RecStatus, MeterId, userNO) VALUES(60, ?, 0, '', ?, ?, ?, ?)";
        
        
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            //add avg and ihb
            
            sqlite3_bind_double(compiledStatement, 1, data.value);
            sqlite3_bind_int( compiledStatement, 2, data.inputDate);
            sqlite3_bind_int( compiledStatement, 3, data.upload);
            sqlite3_bind_int( compiledStatement, 4, data.meterUID);
            
            sqlite3_bind_int( compiledStatement, 5, data.userNO);
            
            sqlite3_step(compiledStatement);
        }
        
        sqlite3_finalize(compiledStatement);
    }
#ifdef TD_DEBUG_DB
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"sqlite3_open Failed"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
#endif
    sqlite3_close(dbhandle);
    
    [pool release];
}


- (int) checkDataRepeat: (int)MDateTime Data1:(double)value1
{
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    int count = 0;
    
    
    sql = [NSString stringWithFormat:@"SELECT COUNT(_id) FROM MData WHERE MType = 60 MDateTime = ? AND Value1 = ?"];
    
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, MDateTime);
            sqlite3_bind_double( compiledStatement, 2, value1);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                count = sqlite3_column_int(compiledStatement, 0);
            }
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(dbhandle);
    }
    
    return count;
}


@end
