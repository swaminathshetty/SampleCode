//
//  BleSessionController.h
//  HKOSSwift
//
//  Created by Apple on 05/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDDebug.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataDefinition.h"
#import "LeW65AlarmService.h"


@protocol LeTemperatureAlarmProtocol;

/****************************************************************************/
/*                            UI protocols                                    */
/****************************************************************************/
@protocol BLEDiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;

@end

extern NSString *BleSessionDataReceivedNotification;
extern NSString *BleSessionTimeoutNotification;
extern NSString *BleSessionMeterConnectedNotification;
extern NSString *BleDisconnectedNotification;
extern NSString *BleConnectedNotification;


@interface BleSessionController : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate> {
    NSMutableData *_writeData;
    NSMutableData *_readData;
    
    int retryCount;
    NSTimer *commandTimer;
    BOOL usingBleIdentifier;
    BOOL isBleConnected;
    CBUUID *w65NotifyUUID;
    
}

+ (BleSessionController *) sharedController;
- (BOOL) openSessionWithIdentifier: (NSString *)bleIdenfiertoOpen;
- (BOOL) openbleSession;
- (void) closebleSession;

- (void) writebleData: (NSData *) data;
- (NSData *) readbleData: (NSUInteger) bytesToRead;
- (void) _writebleData;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *discoveredCharacteristic;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString *bleIdentifier;
@property (strong, nonatomic) NSString *open_bleIdentifier;
@property (strong, nonatomic) NSString *meterName;

@property (retain, nonatomic) NSMutableArray *foundPeripherals;
@property (nonatomic, retain) TDSettingData *settingData;
@property (nonatomic, readwrite) BOOL scanOnly;
@property (nonatomic, readwrite) BOOL bleDeviceConnected;


/****************************************************************************/
/*                                UI controls                                    */
/****************************************************************************/
@property (nonatomic, assign) id<BLEDiscoveryDelegate>           discoveryDelegate;
@property (nonatomic, assign) id<LeTemperatureAlarmProtocol>    peripheralDelegate;

@end

