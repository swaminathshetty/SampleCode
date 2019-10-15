//
//  DatabaseCreation.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "DatabaseCreation.h"
#import <sqlite3.h>// Import the SQLite database framework

@implementation DatabaseCreation

+(NSString *)creationOfDatabase
{
    
    //Set default UI language to english
    // remove what was previously stored in NSUserDefaults (otherwise the previously selected language will be still the first one in the list and your app won't be localized in the language selected in settings)
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize]; // make the change immediate
    
    // reorder the languages so English is always the default fallback
    NSMutableArray *mutableLanguages = [[NSLocale preferredLanguages] mutableCopy];
    NSInteger enIndex = NSNotFound;
    for (NSString *lang in mutableLanguages) { if ([lang isEqualToString:@"en"]) { enIndex = [mutableLanguages indexOfObject:lang]; break; } }
    @try {
        if ((enIndex != 0) && (enIndex != 1)) { [mutableLanguages exchangeObjectAtIndex:1 withObjectAtIndex:enIndex]; }
    } @catch (NSException *exception) {
        
    }
    // save the changes
    [[NSUserDefaults standardUserDefaults] setObject:mutableLanguages forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize]; // to make the change immediate
    //////

    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"TDLink.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success)
        
        return @"Success";
    
    // The writable database does not exist, so copy the default to the appropriate location.

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDLink.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];

    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        return @"Fail";
    }
    else{
        return @"Success";
    }

}

+(NSString *)deleteDatabaseElements{
    
    // read test
    sqlite3 *dbhandle = nil;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath =[documentsDir stringByAppendingPathComponent:@"TDLink.db"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    sqlite3_stmt *selectstmt;
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDLink.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        success = NO;
        return @"Fail";

    }
    
    if (sqlite3_open([dbPath UTF8String], &dbhandle) == SQLITE_OK) {
        //*************** insert value in database******************************\\
        
        NSString  *sql = [NSString stringWithFormat:@"delete from MData"];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(dbhandle,insert_stmt, -1, &selectstmt, NULL);
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            NSLog(@"MData Delete successfully");
            success = YES;
        }
        else
        {
            NSLog(@"MData Delete not successfully");
            success = NO;
            
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(dbhandle);
    }
    
    if (success) {
        return @"Success";
    }
    else
    {
        return @"Fail";
    }

}
+(NSString *)deleteSysConfigDB{
    // read test
    sqlite3 *dbhandle = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath =[documentsDir stringByAppendingPathComponent:@"TDLink.db"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    sqlite3_stmt *selectstmt;
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDLink.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        success = NO;
        return @"Fail";
        
    }
    
    if (sqlite3_open([dbPath UTF8String], &dbhandle) == SQLITE_OK) {
        //*************** insert value in database******************************\\
        
        NSString  *sql = [NSString stringWithFormat:@"delete from SysConfig"];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(dbhandle,insert_stmt, -1, &selectstmt, NULL);
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            NSLog(@"SysConfig Delete successfully");
            success = YES;
        }
        else
        {
            NSLog(@"SysConfig Delete not successfully");
            success = NO;
            
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(dbhandle);
    }
    
    if (success) {
        return @"Success";
    }
    else
    {
        return @"Fail";
    }

}
+(NSString *)deleteMeterProfileDB{
    // read test
    sqlite3 *dbhandle = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath =[documentsDir stringByAppendingPathComponent:@"TDLink.db"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    sqlite3_stmt *selectstmt;
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDLink.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        success = NO;
        return @"Fail";
        
    }
    
    if (sqlite3_open([dbPath UTF8String], &dbhandle) == SQLITE_OK) {
        //*************** insert value in database******************************\\
        
        NSString  *sql = [NSString stringWithFormat:@"delete from MeterProfile"];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(dbhandle,insert_stmt, -1, &selectstmt, NULL);
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            NSLog(@"MData Delete successfully");
            success = YES;
        }
        else
        {
            NSLog(@"MData Delete not successfully");
            success = NO;
            
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(dbhandle);
    }
    
    if (success) {
        return @"Success";
    }
    else
    {
        return @"Fail";
    }

}
@end
