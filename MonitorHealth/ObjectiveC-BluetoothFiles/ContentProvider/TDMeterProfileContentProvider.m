//
//  TDMeterProfileContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDMeterProfileContentProvider.h"
#import "TDUtility.h"


@implementation TDMeterProfileContentProvider

- (TDMeterProfile *) getMeterProfile:(NSString*) deviceType deviceID:(NSString *) deviceId userNO:(int)userNO
{
    TDMeterProfile *meterProfile = nil;
    
    sqlite3 *dbhandle = nil;
    
    
    if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        NSString *sql = nil;
        
        
        sql = @"SELECT _id, DeviceType, DeviceId, DeviceMac, LastImport From MeterProfile where DeviceId = ? and DeviceType = ? and userNO = ?";
        
        
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [deviceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [deviceType UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int( compiledStatement, 3, userNO);
            int result = sqlite3_step(compiledStatement);
            
            if (result == SQLITE_ROW)
            {
                // todo: autorelease this make app crash after unplugged
                meterProfile = [[TDMeterProfile alloc] init];
                
                meterProfile._id = sqlite3_column_int(compiledStatement, 0);
                meterProfile.deviceType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                meterProfile.deviceId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                meterProfile.deviceMacAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                meterProfile.lastImport = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(dbhandle);
    }
    
    return meterProfile;
}



- (void) updateMeterProfile : (TDMeterProfile *) meterProfile
{
    
    NSString *lastedUpdateDate=[TDUtility convertNsdateToNSString:[NSDate date] format:@"yyyyMMddHHmmss"];
    meterProfile.deviceMacAddress=lastedUpdateDate;
    
    NSLog( @"%@",lastedUpdateDate);
    
    sqlite3 *dbhandle = nil;
    
    
    int openResult = sqlite3_open([databasePath UTF8String], &dbhandle);
    if( openResult == SQLITE_OK)
    {
        if (meterProfile._id != 0)
        {
            
            NSString *sql = nil;
            
            sql = @"UPDATE MeterProfile SET LastImport = ? ,DeviceMac = ? , userNo = ? where _id = ?";
            
            
            sqlite3_stmt *compiledStatement = nil;
            
            if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text( compiledStatement, 1, [meterProfile.lastImport UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text( compiledStatement, 2, [meterProfile.deviceMacAddress UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_int ( compiledStatement, 3, meterProfile.userNO);
                sqlite3_bind_int ( compiledStatement, 4, meterProfile._id);
                sqlite3_step(compiledStatement);
                sqlite3_finalize(compiledStatement);
            }
        }
        else
        {
            
            NSString *sql2 = nil;
            
            
            sql2 = @"INSERT INTO MeterProfile (DeviceType, DeviceId, DeviceMac, LastImport, userNO) Values (?, ?, ?, ?, ?)";
            
            
            sqlite3_stmt *compiledStatement2 = nil;
            int result = sqlite3_prepare_v2(dbhandle, [sql2 UTF8String], -1, &compiledStatement2, NULL);
            if( result == SQLITE_OK)
            {
                sqlite3_bind_text( compiledStatement2, 1, [meterProfile.deviceType UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text( compiledStatement2, 2, [meterProfile.deviceId UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text( compiledStatement2, 3, [meterProfile.deviceMacAddress UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text( compiledStatement2, 4, [meterProfile.lastImport UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int ( compiledStatement2, 5, meterProfile.userNO);
                sqlite3_step(compiledStatement2);
                //sqlite3_finalize(compiledStatement2);
                
            }
            else
                NSLog(@"updateMeterProfile fail : Prepare-error #%i: %s", result, sqlite3_errmsg(dbhandle));
            sqlite3_finalize(compiledStatement2);
            
            
            
        }
        sqlite3_close(dbhandle);
    }
    else
        NSLog(@"updateMeterProfile open fail : Prepare-error #%i: %s", openResult, sqlite3_errmsg(dbhandle));
    
}


@end
