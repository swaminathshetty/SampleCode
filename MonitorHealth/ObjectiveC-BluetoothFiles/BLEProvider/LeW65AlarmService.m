//
//  LeW65AlarmService.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "LeW65AlarmService.h"


#import "bytelib.h"
#define TAIDOCBUS_CHARACTERISTIC_UUID @"00001524-1212-EFDE-1523-785FEABCD123"

#define KVN125_CHARACTERISTIC_UUID @"49535343-1E4D-4BD9-BA61-23C647249616" //notify



NSString *kTemperatureServiceUUIDString = @"1808";

NSString *kCurrentTemperatureCharacteristicUUIDString = @"2A1C";
NSString *kMinimumTemperatureCharacteristicUUIDString = @"C0C0C0C0-DEAD-F154-1319-740381000000";
NSString *kMaximumTemperatureCharacteristicUUIDString = @"EDEDEDED-DEAD-F154-1319-740381000000";
NSString *kAlarmCharacteristicUUIDString = @"AAAAAAAA-DEAD-F154-1319-740381000000";
NSString *lbsCharacteristicUUIDString =    @"1523";


NSString *w65ServiceUUIDString =    @"FFF0";
NSString *wLong65ServiceUUIDString =    @"FFF2";



NSString *kAlarmServiceEnteredBackgroundNotification = @"kAlarmServiceEnteredBackgroundNotification";
NSString *kAlarmServiceEnteredForegroundNotification = @"kAlarmServiceEnteredForegroundNotification";

@interface LeW65AlarmService() <CBPeripheralDelegate> {
    
@private
    CBPeripheral		*servicePeripheral;
    
    CBService			*temperatureAlarmService;
    
    CBCharacteristic    *tempCharacteristic;
    CBCharacteristic	*minTemperatureCharacteristic;
    CBCharacteristic    *maxTemperatureCharacteristic;
    CBCharacteristic    *alarmCharacteristic;
    CBCharacteristic    *racpCharacteristic;
    CBCharacteristic    *glucoseCharacteristic;
    CBCharacteristic    *lbsCharacteristic;
    
    
    // harry
    CBCharacteristic    *typeCharacteristic;
    
    
    CBUUID              *temperatureAlarmUUID;
    CBUUID              *minimumTemperatureUUID;
    CBUUID              *maximumTemperatureUUID;
    CBUUID              *currentTemperatureUUID;
    CBUUID              *lbsUUID;
    CBUUID              *w65NotifyUUID;
    CBUUID              *w65ServiceUUID;
    
    
    
    
    id<LeTemperatureAlarmProtocol>	peripheralDelegate;
    id<LeTemperatureAlarmProtocol>	peripheralResponseValueDelegate;
    
}


@end



@implementation LeW65AlarmService


@synthesize peripheral = servicePeripheral;
@synthesize glucoseReady;

#pragma mark -
#pragma mark Init
/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LeTemperatureAlarmProtocol>)controller
{
    self = [super init];
    if (self) {
        servicePeripheral = [peripheral retain];
        [servicePeripheral setDelegate:self];
        peripheralDelegate = controller;
        
        minimumTemperatureUUID	= [[CBUUID UUIDWithString:kMinimumTemperatureCharacteristicUUIDString] retain];
        maximumTemperatureUUID	= [[CBUUID UUIDWithString:kMaximumTemperatureCharacteristicUUIDString] retain];
        currentTemperatureUUID	= [[CBUUID UUIDWithString:kCurrentTemperatureCharacteristicUUIDString] retain];
        temperatureAlarmUUID	= [[CBUUID UUIDWithString:kAlarmCharacteristicUUIDString] retain];
        
        lbsUUID = [[CBUUID UUIDWithString:lbsCharacteristicUUIDString] retain];
        
        NSString *w65NotifyCharacteristicUUIDString =    @"FFF1";
        
        w65NotifyUUID   = [[CBUUID UUIDWithString:w65NotifyCharacteristicUUIDString] retain];
        w65ServiceUUID   = [[CBUUID UUIDWithString:w65ServiceUUIDString] retain];
        
        
    }
    
    
    
    return self;
}


- (void) dealloc {
    if (servicePeripheral) {
        //[servicePeripheral setDelegate:[LeDiscovery sharedInstance]];
        [servicePeripheral release];
        servicePeripheral = nil;
        
        [minimumTemperatureUUID release];
        [maximumTemperatureUUID release];
        [currentTemperatureUUID release];
        [temperatureAlarmUUID release];
        
    }
    [super dealloc];
}


- (void) reset
{
    if (servicePeripheral) {
        [servicePeripheral release];
        servicePeripheral = nil;
    }
}



#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
    CBUUID	*serviceUUID	= [CBUUID UUIDWithString:w65ServiceUUIDString];
    
    NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    
    [servicePeripheral discoverServices:serviceArray];
    //[servicePeripheral discoverServices:nil];//20130506 改成搜尋所有的SERVICE//
}



- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray		*services	= nil;
    
    services = [peripheral services];
    [services count];
    
    int iServiceCount=0;
    
    for (CBService *service in services) {
        iServiceCount++;
        //if ([[service UUID] isEqual:[CBUUID UUIDWithString:kTemperatureServiceUUIDString]]) {
        NSString *stringUUID=@"";
        stringUUID=[NSString stringWithFormat: @"%@", [service UUID]];
        //if([stringUUID isEqual:@"Unknown (<00001523 1212efde 1523785f eabcd123>)"])
        //if([stringUUID isEqual:@"Unknown (<fff0>)"])
        if([[service UUID] isEqual:w65ServiceUUID])
        {
            temperatureAlarmService = service;
            if (temperatureAlarmService) {
                [peripheral discoverCharacteristics:nil forService:temperatureAlarmService];
            }
            else
            {
                //[peripheral discoverCharacteristics:nil forService:service];
                
            }
            //break;
        }
        
        
        
    }
    //}
    
    
    
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSArray		*characteristics	= [service characteristics];
    CBCharacteristic *characteristic;
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (service != temperatureAlarmService) {
        NSLog(@"Wrong Service.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    int iTestCount=0;
    iTestCount=(int)[characteristics count];
    for (characteristic in characteristics) {
        
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]])
        {
            //lbsCharacteristic
            lbsCharacteristic = [characteristic retain];
            [peripheralDelegate didTaidocGlucoseService:lbsCharacteristic];
            
        }
        
        
        else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"2a18"]]) {
            NSLog(@"discovered Glucose Measurement characteristic");
            glucoseCharacteristic = [characteristic retain];
            //[peripheralDelegate didTaidocGlucoseService];
            [peripheralDelegate didTaidocGlucoseService:self];
            
        } else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"2a51"]]) {
            NSLog(@"discovered Glucose Feature characteristic");
            
        } else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"2a52"]]) {
            NSLog(@"discovered Record Access Control Point characteristic");
            racpCharacteristic= [characteristic retain];//real
            
        } else {
            NSLog(@"discovered unknown characteristic: %@", [characteristic UUID]);
            
        }
        
        
        
        
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
    
}



#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/
- (void) writeLowAlarmTemperature:(int)low
{
    NSData  *data	= nil;
    int16_t value	= (int16_t)low;
    
    if (!servicePeripheral) {
        NSLog(@"Not connected to a peripheral");
        return ;
    }
    
    if (!minTemperatureCharacteristic) {
        NSLog(@"No valid minTemp characteristic");
        return;
    }
    
    data = [NSData dataWithBytes:&value length:sizeof (value)];
    [servicePeripheral writeValue:data forCharacteristic:minTemperatureCharacteristic type:CBCharacteristicWriteWithResponse];
}


- (void) writeHighAlarmTemperature:(int)high
{
    NSData  *data	= nil;
    int16_t value	= (int16_t)high;
    
    if (!servicePeripheral) {
        NSLog(@"Not connected to a peripheral");
    }
    
    if (!maxTemperatureCharacteristic) {
        NSLog(@"No valid minTemp characteristic");
        return;
    }
    
    data = [NSData dataWithBytes:&value length:sizeof (value)];
    [servicePeripheral writeValue:data forCharacteristic:maxTemperatureCharacteristic type:CBCharacteristicWriteWithResponse];
}


/** If we're connected, we don't want to be getting temperature change notifications while we're in the background.
 We will want alarm notifications, so we don't turn those off.
 */
- (void)enteredBackground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kTemperatureServiceUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kCurrentTemperatureCharacteristicUUIDString]] ) {
                    
                    // And STOP getting notifications from it
                    [servicePeripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
    }
}

/** Coming back from the background, we want to register for notifications again for the temperature changes */
- (void)enteredForeground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kTemperatureServiceUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kCurrentTemperatureCharacteristicUUIDString]] ) {
                    
                    // And START getting notifications from it
                    [servicePeripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (CGFloat) minimumTemperature
{
    CGFloat result  = NAN;
    int16_t value	= 0;
    
    if (minTemperatureCharacteristic) {
        [[minTemperatureCharacteristic value] getBytes:&value length:sizeof (value)];
        result = (CGFloat)value / 10.0f;
    }
    return result;
}


- (CGFloat) maximumTemperature
{
    CGFloat result  = NAN;
    int16_t	value	= 0;
    
    if (maxTemperatureCharacteristic) {
        [[maxTemperatureCharacteristic value] getBytes:&value length:sizeof (value)];
        result = (CGFloat)value / 10.0f;
    }
    return result;
}


- (CGFloat) temperature
{
    CGFloat result  = NAN;
    NSData* dataBuffer;
    unsigned char *byteBuffer;
    
    ByteStreamReader byteReader;
    double doubleValue;
    int error;
    
    if (glucoseReady && glucoseCharacteristic) {
        
        dataBuffer = [glucoseCharacteristic value];
        byteBuffer = (unsigned char*)[dataBuffer bytes];
        
        //result = byteBuffer[10] + byteBuffer[11] * 256;
        
        byteReader.buffer = byteBuffer + 10;
        byteReader.buffer_cur = byteBuffer + 10;
        byteReader.unread_bytes = 2;
        
        doubleValue = read_sfloat(&byteReader, &error);
    }
    
    return result;
}

//???
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error;
{
    
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    uint8_t alarmValue  = 0;
    
    
    NSLog(@"reading update of %@\n", [characteristic UUID]);
    
    
    
    
    if ([[characteristic UUID] isEqual:w65NotifyUUID])
    {
        NSLog(@"W65 Notify!\n");
        //-------
        NSRange range;
        NSData* responseData;
        NSString* responseString=@"";
        
        //range.location = 2;
        range.location = 0;
        range.length =  [[characteristic value] length] ;
        
        responseData = [[characteristic value] subdataWithRange:range];
        //responseString = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
        Byte *testByte = (Byte *)[responseData bytes];
        for(int i=0;i<[responseData length];i++)
        {
            NSString* tmpString=   [NSString stringWithFormat:@"%0X", testByte[i]];
            if([tmpString length]==1)
                tmpString=[NSString stringWithFormat:@"0%@", tmpString];
            responseString=[NSString stringWithFormat:@"%@%@", responseString, tmpString];
            
        }
        
        //[peripheralDelegate w65ResultResponse: responseString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [peripheralDelegate w65ResultResponse: responseString];
        });
        
        
        return ;
    }
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong peripheral\n");
        return ;
    }
    
    if ([error code] != 0) {
        NSLog(@"Error in update: %@\n", error);
        return ;
    }
    
    /* Temperature change */
    if ([[characteristic UUID] isEqual:currentTemperatureUUID]) {
        [peripheralDelegate alarmServiceDidChangeTemperature:(LeTemperatureAlarmService*)self];
        NSLog(@"temperature...\n");
        return;
    }
    
    /* Alarm change */
    if ([[characteristic UUID] isEqual:temperatureAlarmUUID]) {
        
        /* get the value for the alarm */
        [[alarmCharacteristic value] getBytes:&alarmValue length:sizeof (alarmValue)];
        
        NSLog(@"alarm!  0x%x", alarmValue);
        if (alarmValue & 0x01) {
            /* Alarm is firing */
            if (alarmValue & 0x02) {
                [peripheralDelegate alarmService:(LeTemperatureAlarmService*)self didSoundAlarmOfType:kAlarmLow];
            } else {
                [peripheralDelegate alarmService:(LeTemperatureAlarmService*)self didSoundAlarmOfType:kAlarmHigh];
            }
        } else {
            [peripheralDelegate alarmServiceDidStopAlarm:(LeTemperatureAlarmService*)self];
        }
        
        return;
    }
    
    /* Upper or lower bounds changed */
    if ([characteristic.UUID isEqual:minimumTemperatureUUID] || [characteristic.UUID isEqual:maximumTemperatureUUID]) {
        [peripheralDelegate alarmServiceDidChangeTemperatureBounds:(LeTemperatureAlarmService*)self];
    }
    
    if ([characteristic.UUID isEqual: [CBUUID UUIDWithString:@"2a18"]])
    {
        glucoseReady = YES;
        
        NSData* value;
        
        if (glucoseCharacteristic) {
            [peripheralDelegate alarmServiceDidChangeTemperature:(LeTemperatureAlarmService*)self];
            
            // debug output
            value = [glucoseCharacteristic value];
            NSLog(@"glucose: %@", value);
        }
    }
    //else if ([characteristic.UUID isEqual: [CBUUID UUIDWithString:@"2a52"]])
    else if ([characteristic.UUID isEqual: [CBUUID UUIDWithString:TAIDOCBUS_CHARACTERISTIC_UUID]])
        
    {
        //if ([[characteristic value] length] == 10) {
        if ([[characteristic value] length] == 8) {
            
            NSRange range;
            NSData* responseData;
            NSString* responseString=@"";
            
            //range.location = 2;
            range.location = 0;
            range.length = 8;
            responseData = [[characteristic value] subdataWithRange:range];
            //responseString = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
            Byte *testByte = (Byte *)[responseData bytes];
            for(int i=0;i<[responseData length];i++)
            {
                NSString* tmpString=   [NSString stringWithFormat:@"%X", testByte[i]];
                if([tmpString length]==1)
                    tmpString=[NSString stringWithFormat:@"0%@", tmpString];
                responseString=[NSString stringWithFormat:@"%@%@", responseString, tmpString];
            }
            
            //responseString = [NSString stringWithFormat:@"%@", responseData];
            
            NSLog(@"taidoc bus: %@", responseData);
            
            [peripheralDelegate w65ResultResponse: responseString];
            
        } else {
            NSLog(@"racp response: %@", [characteristic value]);
        }
    }
    
    
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

// harry
- (void) read
{
    glucoseReady = NO;
    [servicePeripheral readValueForCharacteristic:glucoseCharacteristic];
}

- (void) write
{
    // write command to glucose meter
    int lenToSend = 2;
    unsigned char bytesToSend[2];
    
    bytesToSend[0] = 0x04;
    bytesToSend[1] = 0x01;
    //    bytesToSend[2] = 0x00;
    
    NSData *data = [NSData dataWithBytes:bytesToSend length:lenToSend];
    [servicePeripheral writeValue:data forCharacteristic:racpCharacteristic type:CBCharacteristicWriteWithResponse];
    
}

- (void) write: (const char*) buffer
{
    //int lenToSend = 10;
    //unsigned char bytesToSend[10];
    
    int lenToSend = 8;
    unsigned char bytesToSend[8];
    
    //bytesToSend[0] = 0x51;
    //bytesToSend[1] = 0x00;
    
    memcpy(bytesToSend , buffer, 8);
    
    
    NSData *data = [NSData dataWithBytes:bytesToSend length:lenToSend];
    [servicePeripheral writeValue:data forCharacteristic:lbsCharacteristic type:CBCharacteristicWriteWithResponse];
}



@end
