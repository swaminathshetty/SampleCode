//
//  BleSessionController.m
//  HKOSSwift
//
//  Created by Apple on 05/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "BleSessionController.h"
#import "TaidocBleConnectedList.h"

#define INPUT_BUFFER_SIZE 128

@implementation BleSessionController

@synthesize centralManager = _centralManager;
@synthesize discoveredPeripheral = _discoveredPeripheral;
@synthesize data = _data;
@synthesize discoveredCharacteristic = _discoveredCharacteristic;
@synthesize foundPeripherals;
@synthesize discoveryDelegate;
@synthesize settingData;
@synthesize peripheralDelegate;


- (void) commandTimeout: (NSTimer *)timer
{
    if (_writeData != nil && retryCount < 2)
    {
        TDLog(@"retry...");
        
        [self _writebleData];
        if (IS_IOS7) {
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }else{
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }
        retryCount++;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BleSessionTimeoutNotification object:self userInfo:nil];
        TDLog(@"retry failed!!!");
        commandTimer = nil;
    }
}

- (void) _writebleData {
    
    const void* sendBuffer = (unsigned char*)[_writeData bytes];
    NSUInteger sendLength =_writeData.length;
    if(sendLength==7)
    {
        sendLength=7;//for Test
    }
    if (self.discoveredCharacteristic != nil) {
        
        
        [self.discoveredPeripheral writeValue:[NSData dataWithBytes:sendBuffer length:sendLength] forCharacteristic:self.discoveredCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
}

- (void) _readbleData {
    
    // reset timer when the response is received
    if (commandTimer != nil)
    {
        [commandTimer invalidate];
        commandTimer = nil;
    }
    
    
    if (_readData == nil) {
        _readData = [[NSMutableData alloc] init];
    } else {
        [_readData setLength:0];
    }
    
    [self.discoveredPeripheral readValueForCharacteristic:self.discoveredCharacteristic];
    
}

#pragma mark Public Methods

+(BleSessionController *) sharedController
{
    static BleSessionController *sessionController = nil;
    if (sessionController == nil)
    {
        sessionController = [[BleSessionController alloc] init];
    }
    
    return sessionController;
}

- (void) dealloc
{
    [self closebleSession];
    [super dealloc];
}

- (BOOL) openSessionWithIdentifier: (NSString *)bleIdenfiertoOpen
{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.open_bleIdentifier = bleIdenfiertoOpen;
    if (self.open_bleIdentifier.length > 0) {
        usingBleIdentifier = YES;
    }
    
    self.data = [[NSMutableData alloc] init];
    
    self.discoveredPeripheral = nil;
    self.discoveredCharacteristic = nil;
    self.bleIdentifier = @"";
    self.foundPeripherals = [[NSMutableArray alloc] init];
    return (self.centralManager != nil);
}

- (BOOL) openbleSession
{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.data = [[NSMutableData alloc] init];
    
    self.discoveredPeripheral = nil;
    self.discoveredCharacteristic = nil;
    self.bleIdentifier = @"";
    self.open_bleIdentifier = @"";
    self.foundPeripherals = [[NSMutableArray alloc] init];
    return (self.centralManager != nil);
    
}

- (void) closebleSession
{
    
    if (self.centralManager != nil) {
        [self cleanup];
        if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
            [self.centralManager stopScan];
        }
        if (self.discoveredPeripheral != nil) {
            [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
        }
        [self.centralManager release];
        self.centralManager = nil;
        [_data release];
        _data = nil;
        [self.data release];
        self.data = nil;
        self.discoveredPeripheral = nil;
        self.discoveredCharacteristic = nil;
        self.bleIdentifier = @"";
        self.open_bleIdentifier = @"";
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    NSString *nameOfPeripheral=@"";
    nameOfPeripheral=peripheral.name;
    
    if (self.scanOnly) {
        [foundPeripherals removeAllObjects];
        
        if ([[peripheral.name uppercaseString] hasPrefix:TAIDOC_METER_NAME_TAIDOC] || [[peripheral.name uppercaseString] hasPrefix:@"GLUCORX"])
        {
            if (![foundPeripherals containsObject:peripheral]) {
                [foundPeripherals addObject:peripheral];
                if(discoveryDelegate!=nil)
                {
                    [discoveryDelegate discoveryDidRefresh];
                }
            }
        }
    }else{
        NSString* uuidString = [[peripheral identifier] UUIDString];
        
        if([TaidocBleConnectedList readBleUUIDHistoryConnected:(NSString*)uuidString])
        {
            //if (![peripheral isConnected])
            if(peripheral.state !=CBPeripheralStateConnected)
            {
                self.discoveredPeripheral = peripheral;
                self.meterName = peripheral.name;
                [self.centralManager connectPeripheral:peripheral options:nil];
            }
        }
        
    }
    
    
}

- (void) writebleData:(NSData *)data
{
    if (_writeData == nil)
        _writeData = [[NSMutableData alloc] init];
    else
        [_writeData setLength:0];
    
    [_writeData appendData:data];
    
    // start timeout timer if this is not a measure command
    if (((unsigned char*)([_writeData bytes]))[1] != 0x43)
    {
        retryCount = 0;
    }
    
    [self _writebleData];
}

- (NSData *) readbleData:(NSUInteger) bytesToRead
{
    NSData *data = nil;
    
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    
    return data;
}

- (id)init
{
    NSString *w65NotifyCharacteristicUUIDString =    @"FFF1";
    
    w65NotifyUUID   = [[CBUUID UUIDWithString:w65NotifyCharacteristicUUIDString] retain];
    
    self = [super init];
    if (self){
    }
    
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if (central.state == CBCentralManagerStatePoweredOff) {
        
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        
        [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
        
    }
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //NSLog(@"Failed to connect");
    [self cleanup];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    self.bleDeviceConnected = YES;
    
    [self.centralManager stopScan];
    
    [self.data setLength:0];
    
    peripheral.delegate = self;
    
    
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]]) {
            
            printf(characteristic);
            self.discoveredCharacteristic = characteristic;
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BleConnectedNotification object:self userInfo:nil];
            
        }
        else if([characteristic.UUID isEqual:w65NotifyUUID])
        {
            self.discoveredCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        
        
    }
}

int count=0;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        //NSLog(@"Error");
        return;
    }
    
    
    if ([[characteristic UUID] isEqual:w65NotifyUUID])
    {
        
        NSRange range;
        NSData* responseData;
        NSString* responseString=@"";
        
        
        range.location = 0;
        range.length =  [[characteristic value] length] ;
        
        responseData = [[characteristic value] subdataWithRange:range];
        
        Byte *testByte = (Byte *)[responseData bytes];
        for(int i=0;i<[responseData length];i++)
        {
            NSString* tmpString=   [NSString stringWithFormat:@"%0X", testByte[i]];
            if([tmpString length]==1)
                tmpString=[NSString stringWithFormat:@"0%@", tmpString];
            responseString=[NSString stringWithFormat:@"%@%@", responseString, tmpString];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [peripheralDelegate w65ResultResponse: responseString];
        });
        
        
        return ;
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]]) {
        
        count = count+1;
        
        NSLog(@"-------------> %d",count);
        
        NSLog(@"%@",self.data);
        
        if (self.data == nil) {
            self.data = [[NSMutableData alloc] init];
        } else {
            [self.data setLength:0];
        }
        
        [self.data appendData:characteristic.value];
        
        printf(characteristic);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BleSessionDataReceivedNotification object:self userInfo:nil];
    }
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        
    } else {
        // Notification has stopped
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self cleanup];
    self.discoveredPeripheral = nil;
    self.centralManager = nil;
    
    if (self.bleDeviceConnected) {
        self.bleDeviceConnected = NO;
    }
    
    
    
    if (self.scanOnly) {
        if(discoveryDelegate!=nil)
        {
            [discoveryDelegate discoveryDidRefresh];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BleDisconnectedNotification object:self userInfo:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
    }
}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    CBPeripheral    *peripheral;
    
   //  Add to list.
    for (peripheral in peripherals) {
        [central connectPeripheral:peripheral options:nil];
    }
}


- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    [central connectPeripheral:peripheral options:nil];
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
    
}

@end
