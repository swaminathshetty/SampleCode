//
//  TDUtility.m
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDUtility.h"
#import "TDSettingContentProvider.h"

@implementation TDUtility

+ (CGFloat) convertMmolToMgdl: (CGFloat) mmolValue
{
    return mmolValue * 18.0;
}

+ (CGFloat) convertMgdlToMmol: (CGFloat) mgdlValue
{
    return mgdlValue / 18.0;
}

+ (CGFloat) convertmmHgTokpa: (CGFloat) mmHgValue
{
    return mmHgValue / 7.5;
}

+ (CGFloat) convertkpaTommHg: (CGFloat) kpaValue
{
    return kpaValue * 7.5;
}

+(NSString*) convertNsdateToNSString:(NSDate*) tempDate format:(NSString *) strformat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:strformat];
    NSString *strDate = [dateFormatter stringFromDate:tempDate];
    [dateFormatter release];
    return strDate;
}


+ (uint8_t) calculateCheckSum :(NSData *)cmd Length:(int)size
{
    uint8_t checkSum = 0;
    int i = 0;
    unsigned char *pCmd = (unsigned char *) [cmd bytes];
    
    for (i = 0; i < size; i++)
    {
        checkSum += pCmd[i];
    }
    
    return checkSum;
}



+(double) FLOOR:(double) dReturn
{
    double dreturn=0;
    dreturn = floorf(dReturn);//小數無條件捨去//
    return dreturn;
}



+(NSDate*) convertNsdateFromIntegerYear:(int)iYear Month:(int)iMonth Day:(int)iDay
{
    NSString *strTemp ;
    strTemp = [NSString stringWithFormat:@"%d-%0d-%0d %0d:%0d:%0d",iYear,iMonth,iDay,0,0,0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strTemp];
    [dateFormatter release];
    return date;
}

+(NSDate*) convertNsdateFromIntegerYear:(int)iYear Month:(int)iMonth Day:(int)iDay Hour:(int)iHour Minute:(int)iMinute Second:(int)iSecond
{
    
    NSString *strTemp ;
    strTemp = [NSString stringWithFormat:@"%d-%0d-%0d %0d:%0d:%0d",iYear,iMonth,iDay,iHour,iMinute,iSecond];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [NSDate date];
    date= [dateFormatter dateFromString:strTemp];
    [dateFormatter release];
    return date;
}



+(double) convertKgToLb:(double) dkg
{
    double dLb = 0;
    dLb = (dkg*10*22+5)/100;
    
    dLb = floor((dLb*10));
    dLb = dLb/10;
    return dLb;
}

+(double) convertLbToKg:(double) dLb
{
    double dKg = 0;
    dKg = dLb*0.45359237;
    
    dKg = round((dKg*10));
    dKg = dKg/10;
    return dKg;
}

@end
