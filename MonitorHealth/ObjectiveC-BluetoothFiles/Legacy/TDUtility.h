//
//  TDUtility.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataDefinition.h"

typedef enum
{
    hourSegment=0,
    daySegment=1
} ChartSpreadSegment;

@interface TDUtility : NSObject
{
    
}
+ (CGFloat) convertMmolToMgdl: (CGFloat) mmolValue;
+ (CGFloat) convertMgdlToMmol: (CGFloat) mgdlValue;
+ (CGFloat) convertmmHgTokpa: (CGFloat) mmHgValue;
+ (CGFloat) convertkpaTommHg: (CGFloat) kpaValue;
+(double) convertKgToLb:(double) dkg;
+(double) convertLbToKg:(double) dLb;
+(NSString*) convertNsdateToNSString:(NSDate*) tempDate format:(NSString *) strformat;

+ (uint8_t) calculateCheckSum :(NSData *)cmd Length:(int)size;

+(double) FLOOR:(double) dReturn;
+(NSDate*) convertNsdateFromIntegerYear:(int)iYear Month:(int)iMonth Day:(int)iDay;
+(NSDate*) convertNsdateFromIntegerYear:(int)iYear Month:(int)iMonth Day:(int)iDay Hour:(int)iHour Minute:(int)iMinute Second:(int)iSecond;


@end
