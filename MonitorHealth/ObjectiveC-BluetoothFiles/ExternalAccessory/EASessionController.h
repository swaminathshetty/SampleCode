//
//  EASessionController.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ExternalAccessory/ExternalAccessory.h>
#import "TDDebug.h"
#import "TDSettingContentProvider.h"

extern NSString *EADSessionDataReceivedNotification;
extern NSString *EADSessionTimeoutNotification;

@interface EASessionController : NSObject <EAAccessoryDelegate, NSStreamDelegate> {
    EAAccessory *_accessory;
    EASession *_session;
    NSString *_protocolString;
    
    NSMutableData *_writeData;
    NSMutableData *_readData;
    NSMutableData *_readDataForTemp;
    
    int retryCount;
    NSTimer *commandTimer;
}

+ (EASessionController *) sharedController;

- (void) setupControllerForAccessory: (EAAccessory *)accessory withProtocolString: (NSString *) protocolString;

- (BOOL) openSession;
- (void) closeSession;
- (void) writeData: (NSData *) data;
- (NSUInteger) readBytesAvailable;
- (NSData *) readData: (NSUInteger) bytesToRead;
- (void) _writeData;
- (void) _readData;

@property (nonatomic, readonly) EAAccessory *accessory;
@property (nonatomic, readonly) NSString *protocolString;

@end
