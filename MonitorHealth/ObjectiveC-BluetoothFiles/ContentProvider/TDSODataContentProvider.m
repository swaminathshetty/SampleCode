//
//  TDSODataContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDSODataContentProvider.h"

@implementation TDSODataContentProvider

- (void) addSOData: (TDSOData *) data;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // read test
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        
        sql = @"INSERT INTO MData(MType, Value1, Value3, Value4, RawData, MDateTime, RecStatus, MeterId, userNO) VALUES(7, ?, ?, 0, '', ?, ?, ?, ?)";
        
        
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            //add avg and ihb
            
            sqlite3_bind_double(compiledStatement, 1, data.spo2Value);
            sqlite3_bind_double( compiledStatement, 2, data.pulse);
            sqlite3_bind_int( compiledStatement, 3, data.inputDate);
            sqlite3_bind_int( compiledStatement, 4, data.upload);
            sqlite3_bind_int( compiledStatement, 5, data.meterUID);
            
            sqlite3_bind_int( compiledStatement, 6, data.userNO);
            
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


- (int) checkDataRepeat: (int)MDateTime Data1:(double)value1 Data3:(double)value3
{
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    int count = 0;
    
    
    sql = [NSString stringWithFormat:@"SELECT COUNT(_id) FROM MData WHERE MType = 7 MDateTime = ? AND Value1 = ? AND Value3 = ?"];
    
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, MDateTime);
            sqlite3_bind_double( compiledStatement, 2, value1);
            sqlite3_bind_double( compiledStatement, 3, value3);
            
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
