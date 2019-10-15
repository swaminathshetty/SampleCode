//
//  TDDataContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDDataContentProvider.h"

@implementation TDDataContentProvider


- (NSMutableArray *) getDataLimitCounts:(int)iStart andCounts:(int) iCount whichType:(int)type
{
    NSMutableArray *arrLogs = [[[NSMutableArray alloc] initWithCapacity:15] autorelease];
    
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    
    
    if (type == 0) {
        sql = [NSString stringWithFormat:@"SELECT MType, _id, Value1, Value2, Value3, Value4, Value5, RawData, MDateTime, RecStatus FROM MData ORDER BY MDateTime Desc Limit %d, %d", iStart, iCount];
    }else{
        sql = [NSString stringWithFormat:@"SELECT MType, _id, Value1, Value2, Value3, Value4, Value5, RawData, MDateTime, RecStatus FROM MData WHERE MType = %d ORDER BY MDateTime Desc Limit %d, %d", type, iStart, iCount];
    }
    
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                TDRecordData *data = [[TDRecordData alloc] init];
                
                data.mType = sqlite3_column_int(compiledStatement, 0);
                data.indexID = sqlite3_column_int(compiledStatement, 1);
                data.value1 = sqlite3_column_double(compiledStatement, 2);
                data.value2 = sqlite3_column_double(compiledStatement, 3);
                data.value3 = sqlite3_column_double(compiledStatement, 4);
                data.value4 = sqlite3_column_double(compiledStatement, 5);
                int value5 = sqlite3_column_int(compiledStatement, 6); //ihb (1) + avg (2)
                
                
                data.value5 = value5 %10;//avg
                int ihb = (value5 /10);
                
                data.value6=ihb;
                
                data.rawData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                data.timePeriod = sqlite3_column_int(compiledStatement, 8);
                data.uploadStatus = sqlite3_column_int(compiledStatement, 9);
                
                [arrLogs addObject:data];
                
                [data release];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(dbhandle);
    }
    
    return arrLogs;
}

- (NSInteger) getDataCounts:(int)type
{
    sqlite3 *dbhandle = nil;
    NSString *sql = nil;
    NSInteger count = 0;
    
    
    if (type == 0) {
        sql = [NSString stringWithFormat:@"SELECT COUNT(_id) FROM MData"];
    }else{
        sql = [NSString stringWithFormat:@"SELECT COUNT(_id) FROM MData WHERE MType = %d", type];
    }
    
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
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
