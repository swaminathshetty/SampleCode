//
//  TaidocBleConnectedList.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TaidocBleConnectedList.h"

NSString *BleSessionDataReceivedNotification = @"BleSessionDataReceivedNotification";
NSString *BleSessionTimeoutNotification = @"BleSessionTimeoutNotification";
NSString *BleSessionMeterConnectedNotification = @"BleSessionMeterConnectedNotification";
NSString *BleDisconnectedNotification = @"BleDisconnectedNotification";
NSString *BleConnectedNotification = @"BleConnectedNotification";

@implementation TaidocBleConnectedList

+(Boolean)readBleUUIDExist:(NSString*) serachBleUUID
{
    NSString *value;
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/taidocBLEConnected.plist"];
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    value = [plistDict objectForKey:serachBleUUID];
    [plistDict release];
    
    return value==nil?false:true;
}

//存檔
+ (void)writeBleUUIDToMemory:(NSString*) stringOfUUID stringOfDeviceName: (NSString*) stringOfDeviceName
{
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/taidocBLEConnected.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    
    //[plistDict setValue:stringOfUUID forKey:stringOfUUID];
    [plistDict setValue:stringOfDeviceName forKey:stringOfUUID];
    
    //save file
    if ([plistDict writeToFile:filePath atomically: YES]) {
        NSLog(@"writePlist success");
    } else {
        NSLog(@"writePlist fail");
    }
    [plistDict release];
}




+ (Boolean)readBleUUIDHistoryConnected:(NSString*) uuidOfBle
{
    @try
    {
        return [TaidocBleConnectedList readBleUUIDExist:uuidOfBle];
    }
    @catch (NSException *exception)
    {
    }
    
    return false;
}

// 清空已存檔
+ (void)clearMemoryConnectedList
{
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/taidocBLEConnected.plist"];
    
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [plistDict removeAllObjects];
        
        //save file
        if ([plistDict writeToFile:filePath atomically: YES]) {
            NSLog(@"writePlist success");
        } else {
            NSLog(@"writePlist fail");
        }
        [plistDict release];
    }
}




+(NSArray*)readBleSavedUUID
{
    NSString *value;
    NSMutableArray *arrayDeviceUUID = [[NSMutableArray alloc]init];
    
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/taidocBLEConnected.plist"];
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else
    {
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    NSEnumerator *enumerator = [plistDict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        value =((NSString*)key);
        [arrayDeviceUUID addObject:value];
    }
    
    return arrayDeviceUUID;
}

+(NSArray*)readBleSavedUUIDAndDeviceName
{
    NSString *value;
    NSMutableArray *arrayDeviceUUID = [[NSMutableArray alloc]init];
    
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/taidocBLEConnected.plist"];
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    NSEnumerator *enumerator = [plistDict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        
        value =  [NSString stringWithFormat:@"%@###%@",[plistDict objectForKey:key] ,((NSString*)key)];
        
        [arrayDeviceUUID addObject:value];
    }
    
    return arrayDeviceUUID;
}


@end
