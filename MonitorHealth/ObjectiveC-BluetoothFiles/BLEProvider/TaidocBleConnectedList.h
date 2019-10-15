//
//  TaidocBleConnectedList.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface  TaidocBleConnectedList : NSObject
{
    
}
+ (void) writeBleUUIDToMemory: (NSString *) stringOfUUID stringOfDeviceName: (NSString *) stringOfDeviceName;
+ (Boolean) readBleUUIDHistoryConnected: (NSString *) uuidOfBle;
+ (void) clearMemoryConnectedList;
+ (NSArray *) readBleSavedUUID;
+ (NSArray *) readBleSavedUUIDAndDeviceName;


@end
