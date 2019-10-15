//
//  EASessionController.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "EASessionController.h"

#define INPUT_BUFFER_SIZE 128

NSString *EADSessionDataReceivedNotification = @"EADSessionDataReceivedNotification";
NSString *EADSessionTimeoutNotification = @"EADSessionTimeoutNotification";

@implementation EASessionController

@synthesize accessory = _accessory;
@synthesize protocolString = _protocolString;


- (void) commandTimeout: (NSTimer *)timer
{
    if (_writeData != nil && retryCount < 2)
    {
        TDLog(@"retry...");
        
        [self _writeData];
        if (IS_IOS7) {
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }else{
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }
        
        retryCount++;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionTimeoutNotification object:self userInfo:nil];
        TDLog(@"retry failed!!!");
        commandTimer = nil;
    }
}


- (void) _writeData {
    int totalBytesWritten = 0;
    NSUInteger totalBytesToSend = _writeData.length;
    const void* sendBuffer = [_writeData bytes];
    while (([[_session outputStream] hasSpaceAvailable]) && (totalBytesToSend > totalBytesWritten)) {
        
        NSInteger bytesWritten = [[_session outputStream] write: (sendBuffer + totalBytesWritten) maxLength:(totalBytesToSend - totalBytesWritten)];
        
        if (bytesWritten == -1)
        {
            
            break;
        }
        else if (bytesWritten > 0)
        {
            totalBytesWritten += bytesWritten;
        }
    }
    
}

- (void) _readData {
    
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
    
    uint8_t buf[INPUT_BUFFER_SIZE];
    NSInteger bytesRead;
    
    while ([[_session inputStream] hasBytesAvailable]) {
        bytesRead = [[_session inputStream] read:buf maxLength:INPUT_BUFFER_SIZE];
        [_readData appendBytes:(const void *)buf length:bytesRead];
        
    }
    
    // notification for command responsed received
    [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionDataReceivedNotification object:self userInfo:nil];
}

#pragma mark Public Methods

+(EASessionController *) sharedController
{
    static EASessionController *sessionController = nil;
    if (sessionController == nil)
    {
        sessionController = [[EASessionController alloc] init];
    }
    
    return sessionController;
}

- (void) dealloc
{
    [self closeSession];
    [self setupControllerForAccessory:nil withProtocolString:nil];
    [super dealloc];
}

- (void) setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString
{
    
    if(accessory!=nil)
        _accessory =accessory;
    if(protocolString!=nil)
        _protocolString =protocolString;
}

- (BOOL) openSession
{
    if (!_session)
    {
        [_accessory setDelegate:self];
        _session = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocolString];
        
        if (_session)
        {
            [[_session inputStream] setDelegate:self];
            [[_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [[_session inputStream] open];
            
            [[_session outputStream] setDelegate:self];
            [[_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [[_session outputStream] open];
        }
    }
    /*
     else
     {
     UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"EASessionController" message:@"session already opened!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
     [_alert show];
     [_alert release];
     
     return NO;
     }
     */
    
    return (_session != nil);
}

- (void) closeSession
{
    if (_session == nil)
        return;
    
    [[_session inputStream] close];
    [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session inputStream] setDelegate:nil];
    
    [[_session outputStream] close];
    [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session outputStream] setDelegate:nil];
    
    [_session release];
    _session = nil;
    
    [_writeData release];
    _writeData = nil;
    
    [_readData release];
    _readData = nil;
}

#ifdef TD_SIMULATOR

- (void) testResult: (NSTimer *)timer
{
    unsigned char responseBuffer21[8] = {0x51, 0x21, 0x0, 0x0, 0x42, 0x0, 0xA5, 0x59 };
    [_readData setLength:0];
    [_readData appendBytes: responseBuffer21 length:8];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionDataReceivedNotification object:self userInfo:nil];
}

- (void) delayResponse: (NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionDataReceivedNotification object:self userInfo:nil];
}

#endif

- (void) writeData:(NSData *)data
{
    
#ifndef TD_SIMULATOR
    
    if (_writeData == nil)
        _writeData = [[NSMutableData alloc] init];
    else
        [_writeData setLength:0];
    
    
    [_writeData appendData:data];
    
    
    // start timeout timer if this is not a measure command
    if (((unsigned char*)([_writeData bytes]))[1] != 0x42)
    {
        retryCount = 0;
        if (IS_IOS7) {
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }else{
            commandTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(commandTimeout:) userInfo:nil repeats:NO];
        }
    }
    
    [self _writeData];
    //}
    
#else
    
    if (_readData == nil) {
        _readData = [[NSMutableData alloc] init];
    } else {
        [_readData setLength:0];
    }
    
    unsigned char* commandBuffer = (unsigned char*)[data bytes];
    unsigned char responseBuffer31[8] = {0x51, 0x31, 0x0, 0x0, 0x41, 0x0, 0xA5, 0x68 };
    unsigned char responseBuffer28[8] = {0x51, 0x28, 0x0, 0x0, 0x0, 0x0, 0xA5, 0x1E};
    unsigned char responseBuffer27[8] = {0x51, 0x27, 0x0, 0x0, 0x0, 0x0, 0xA5, 0x1D};
    unsigned char responseBuffer24[8] = {0x51, 0x24, 0x32, 0x41, 0x1, 0x0, 0xA5, 0x8E};
    unsigned char responseBuffer21[8] = {0x51, 0x21, 0x0, 0x0, 0x41, 0x0, 0xA5, 0x58};
    unsigned char responseBuffer44[8] = {0x51, 0x44, 0xED, 0x0, 0x44, 0x9, 0xA5, 0x74};
    unsigned char responseBuffer42[8] = {0x51, 0x42, 0x1A, 0x0, 0x0, 0x0, 0xA5, 0x52};
    unsigned char responseBuffer26[8] = {0x51, 0x26, 0x00, 0x00, 0x6, 0x0, 0xA5, 0x22};
    
    
    switch (commandBuffer[1])
    {
        case 0x31:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer31 length:8];
            break;
            
        case 0x28:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer28 length:8];
            
            break;
            
        case 0x27:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer27 length:8];
            
            break;
            
        case 0x24:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer24 length:8];
            break;
            
        case 0x21:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer21 length:8];
            break;
            
        case 0x44:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer44 length:8];
            break;
            
        case 0x42:
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer42 length:8];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(testResult:) userInfo:nil repeats:NO];
            break;
            
        case 0x26:
        {
            static int round = 0;
            round += 1;
            responseBuffer26[2] = round;
            responseBuffer26[7] += round;
            [_readData setLength:0];
            [_readData appendBytes: responseBuffer26 length:8];
            break;
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delayResponse:) userInfo:nil repeats:NO];
#endif
    
}


- (NSData *) readData:(NSUInteger) bytesToRead
{
    NSData *data = nil;
    
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    
    return data;
}

- (NSUInteger) readBytesAvailable
{
    return [_readData length];
}

- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:  //case 0
            break;
        case NSStreamEventOpenCompleted:  //case 1
            break;
        case NSStreamEventHasBytesAvailable:  //case 2
            [self _readData];
            break;
        case NSStreamEventHasSpaceAvailable:  // case 3
            break;
        case NSStreamEventErrorOccurred:  //case 4
            break;
        case NSStreamEventEndEncountered:  //case 5
            break;
        default:
            break;
            
    }
}

- (id)init
{
    self = [super init];
    if (self){
    }
    
    return self;
}

@end
