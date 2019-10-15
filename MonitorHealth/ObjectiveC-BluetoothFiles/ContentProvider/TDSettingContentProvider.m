//
//  TDSettingContentProvider.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDSettingContentProvider.h"
#import "TDUtility.h"

@implementation TDSettingContentProvider
@synthesize workingCopy;

static void ConvertKgToLb(sqlite3_context *ctx, int nArg, sqlite3_value **apArg)
{
    if(sqlite3_value_type(apArg[0]) == SQLITE_FLOAT)
    {
        float value = sqlite3_value_double(apArg[0]);
        value *= 2.20462;
        sqlite3_result_double(ctx, value);
    }
    else
    {
        sqlite3_result_error(ctx, "Invalid argument.", -1);
    }
}

static void ConvertLbToKg(sqlite3_context *ctx, int nArg, sqlite3_value **apArg)
{
    if(sqlite3_value_type(apArg[0]) == SQLITE_FLOAT)
    {
        float value = sqlite3_value_double(apArg[0]);
        value *= 0.45359;
        sqlite3_result_double(ctx, value);
    }
    else
    {
        sqlite3_result_error(ctx, "Invalid argument.", -1);
    }
}

- (id) initWithDatabaseName:(NSString *)name
{
    self = [super initWithDatabaseName:name];
    
    if (self)
    {
        // create functions here
        if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
        {
            ;
        }
    }
    
    return self;
}
- (TDSettingData *) getSettingData
{
    TDSettingData *data = [[[TDSettingData alloc] init] autorelease];
    
    //if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        NSString *sql = nil;
        sqlite3_stmt *compiledStatement = nil;
        
        
        sql = @"SELECT ConfStrValue FROM SysConfig WHERE ConfName=?";
        
        // device serial number
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"DEVICE_SERIAL_NUMBER" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.deviceSerialNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // lang
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"LANG" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.lang = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            }
        }
        sqlite3_finalize(compiledStatement);
        
        sql = @"SELECT ConfIntValue FROM SysConfig WHERE ConfName=?";
        
        
        // BGM_AC_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_AC_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmACSafeL = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_AC_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_AC_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmACSafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        // BGM_PC_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_PC_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmPCSafeL = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        // BGM_PC_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_PC_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmPCSafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_GEN_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_GEN_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmGENSafeL = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        // BGM_GEN_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BGM_GEN_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bgmGENSafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_SYS_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BPM_SYS_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bpmSYSSafeL = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        // BPM_SYS_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BPM_SYS_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bpmSYSSafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_DIA_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BPM_DIA_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bpmDIASafeL = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        // BPM_DIA_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"BPM_DIA_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.bpmDIASafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // WS_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"WS_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.wsSafeH = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
        sql = @"SELECT ConfFtValue FROM SysConfig WHERE ConfName=?";
        
        // tempH
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"TEMP_H" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.tempH = sqlite3_column_double(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        // tempL
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"TEMP_L" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.tempL = sqlite3_column_double(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        sql = @"SELECT ConfIntValue FROM SysConfig WHERE ConfName=?";
        
        // spo2
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [@"SPO2" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                data.spo2 = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        
        
    }
    
    self.workingCopy = data;
    
    return data;
}

- (void) updateSettingData:(TDSettingData *)settingData
{
    int result;
    if (workingCopy == nil)
    {
        self.workingCopy = [self getSettingData];
    }
    
    // add function cm to inch
    
    // add function kg to lb
    sqlite3_create_function(dbhandle, "ConvertKgToLb", 1, SQLITE_UTF8, 0, ConvertKgToLb, 0, 0);
    // add function lb to kg
    sqlite3_create_function(dbhandle, "ConvertLbToKg", 1, SQLITE_UTF8, 0, ConvertLbToKg, 0, 0);
    
    //if(sqlite3_open([databasePath UTF8String], &dbhandle) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sql = @"UPDATE SysConfig SET ConfStrValue=? WHERE ConfName=?";
        
        
        // DEVICE_SERIAL_NUMBER
        result = sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL);
        if( result == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [settingData.deviceSerialNumber UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [@"DEVICE_SERIAL_NUMBER" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        else
            NSLog(@"save DEVICE_SERIAL_NUMBER fail : #%i: %s", result, sqlite3_errmsg(dbhandle));
        sqlite3_finalize(compiledStatement);
        
        // lang
        result = sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL);
        if( result == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [settingData.lang UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [@"LANG" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        else
            NSLog(@"save lang fail : #%i: %s", result, sqlite3_errmsg(dbhandle));
        sqlite3_finalize(compiledStatement);
        
        sql = @"UPDATE SysConfig SET ConfIntValue=? WHERE ConfName=?";
        
        
        // BGM_AC_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmACSafeL);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_AC_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_AC_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmACSafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_AC_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_PC_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmPCSafeL);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_PC_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_PC_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmPCSafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_PC_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_GEN_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmGENSafeL);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_GEN_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BGM_GEN_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bgmGENSafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"BGM_GEN_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_SYS_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bpmSYSSafeL);
            sqlite3_bind_text( compiledStatement, 2, [@"BPM_SYS_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_SYS_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bpmSYSSafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"BPM_SYS_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_DIA_SAFE_L
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bpmDIASafeL);
            sqlite3_bind_text( compiledStatement, 2, [@"BPM_DIA_SAFE_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // BPM_DIA_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.bpmDIASafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"BPM_DIA_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // WS_SAFE_H
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.wsSafeH);
            sqlite3_bind_text( compiledStatement, 2, [@"WS_SAFE_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        
        sql = @"UPDATE SysConfig SET ConfFtValue=? WHERE ConfName=?";
        
        // tempH
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_double( compiledStatement, 1, settingData.tempH);
            sqlite3_bind_text( compiledStatement, 2, [@"TEMP_H" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        // tempL
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_double( compiledStatement, 1, settingData.tempL);
            sqlite3_bind_text( compiledStatement, 2, [@"TEMP_L" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
        sql = @"UPDATE SysConfig SET ConfIntValue=? WHERE ConfName=?";
        
        // spo2
        if(sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int( compiledStatement, 1, settingData.spo2);
            sqlite3_bind_text( compiledStatement, 2, [@"SPO2" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
        
    }
    
    
    // del function kg to lb
    sqlite3_create_function(dbhandle, "ConvertKgToLb", 1, SQLITE_UTF8, 0, 0, 0, 0);
    // del function lb to kg
    sqlite3_create_function(dbhandle, "ConvertLbToKg", 1, SQLITE_UTF8, 0, 0, 0, 0);
    
}


- (void) dealloc
{	
    [workingCopy release];
    sqlite3_close(dbhandle);
    [super dealloc];
}

@end
