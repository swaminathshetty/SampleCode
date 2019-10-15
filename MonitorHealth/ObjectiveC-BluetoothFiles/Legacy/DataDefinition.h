//
//  DataDefinition.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern BOOL isImportingOBJC;

#define BLE


#define PROTOCOL_STRING_BG_BLUTOOTH  @"com.taidoc.taidocbus"
#define PROTOCOL_STRING_BG_EXT  @"com.taidoc.taidocbus.ext"
#define PROTOCOL_STRING_MP_BLUTOOTH  @"com.foracare.taidocbus.mp"

#define TAIDOCBUS_SERVICE_UUID @"00001523-1212-EFDE-1523-785FEABCD123"
#define TAIDOCBUS_CHARACTERISTIC_UUID @"00001524-1212-EFDE-1523-785FEABCD123"
#define KVN125_CHARACTERISTIC_UUID @"49535343-1E4D-4BD9-BA61-23C647249616" //notify



//------------------------------------------------------------------------------------------------------------------------------------

#define TAIDOC_METER_NAME_FORA_BP8  @"TAIDOC TD3140"


#define TAIDOC_METER_NAME_TAIDOC @"TAIDOC"
//#define TAIDOC_METER_NAME_TAIDOC @"GLUCORX"


#define PROTOCOL_STRING_TAIDOC_BG  @"com.taidoc.taidocbus.bg"
#define PROTOCOL_STRING_TAIDOC_BP  @"com.taidoc.taidocbus.bp"
#define PROTOCOL_STRING_TAIDOC_WS  @"com.taidoc.taidocbus.ws"
#define PROTOCOL_STRING_TAIDOC_MP  @"com.taidoc.taidocbus.mp"



#define GLUCOSE_VALUE_MAX 450.0
#define GLUCOSE_VALUE_MIN   0

#define GLUCOSE_VALUE_MAX_HI 600.0
#define GLUCOSE_VALUE_MIN_LOW   20.0

#define GLUCOSE_VALUE_MAX_HI_DISPLAY  @"HI"
#define GLUCOSE_VALUE_MIN_LOW_DISPLAY @"LO"

#define BP_VALUE_MAX 300.0
#define BP_VALUE_MIN   0

#define TP_VALUE_MAX 41.0
//#define TP_VALUE_MIN   0
#define TP_VALUE_MIN   35.0

#define TP_VALUE_MAX_F 106
#define TP_VALUE_MIN_F 94

#define TP_VALUE_MAX_HI_DISPLAY  @"HI"
#define TP_VALUE_MIN_LOW_DISPLAY @"LO"

#define SO_VALUE_MAX 100.0
#define SO_VALUE_MIN   70

#define SO_VALUE_MAX_HI_DISPLAY  @"HI"
#define SO_VALUE_MIN_LOW_DISPLAY @"LO"

#define WG_VALUE_MAX 180
#define WG_VALUE_MIN   0

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
//#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define IS_IPHONE_5 ( IS_HEIGHT_GTE_568 )

#define IS_IOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?YES:NO)
#define IS_IOS7_ADD  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?20:0)

#define IS_IOS6_DELETE  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0?20:0)

//BOOL isImportingOBJC;
typedef union
{
    NSInteger intValue;
    CGFloat floatValue;
} TDGlucoseValue;

typedef enum
{
    Female=0,
    Male=1,
    NotDefined=2
} WSGenderType;

@interface TDRecordData : NSObject
{

    int indexID;
    int mType;
    CGFloat value1;
    CGFloat value2;
    CGFloat value3;
    CGFloat value4;
    CGFloat value5;//avg
    CGFloat value6;//ihb
    int meterUID;
    NSString *rawData;
    int timePeriod;
    int uploadStatus;
    int AVG;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int mType;
@property(nonatomic, readwrite) CGFloat value1;
@property(nonatomic, readwrite) CGFloat value2;
@property(nonatomic, readwrite) CGFloat value3;
@property(nonatomic, readwrite) CGFloat value4;
@property(nonatomic, readwrite) CGFloat value5;
@property(nonatomic, readwrite) CGFloat value6;
@property(nonatomic, readwrite) int meterUID;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) int timePeriod;
@property(nonatomic, readwrite) int uploadStatus;
@property(nonatomic, readwrite) int AVG;

@end

@interface TDGlucoseData : NSObject
{
    int indexID;
    int inputDate;
    NSString *rawData;
    int type;
    int machineOrgType;
    int timePeriod;
    CGFloat value;
    int upload;
    int meterUID;
    BOOL DontSave;
    int userNO;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int inputDate;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) int type;
@property(nonatomic, readwrite) int machineOrgType;
@property(nonatomic, readwrite) int timePeriod;
@property(nonatomic, readwrite) CGFloat value;
@property(nonatomic, readwrite) int upload;
@property(nonatomic, readwrite) int meterUID;
@property(nonatomic, readwrite) BOOL DontSave;
@property(nonatomic, readwrite) int userNO;

@end

@interface TDBPData : NSObject
{
    int indexID;
    int inputDate;
    NSString *rawData;
    CGFloat systolic;  //value1
    CGFloat diastolic;  //value2
    CGFloat pulse;  //value3
    int upload;
    int meterUID;
    int type; //value4
    int ihb;  //value5
    int avg;  //value5
    int userNO;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int inputDate;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) CGFloat systolic;
@property(nonatomic, readwrite) CGFloat diastolic;
@property(nonatomic, readwrite) CGFloat pulse;
@property(nonatomic, readwrite) int upload;
@property(nonatomic, readwrite) int meterUID;
@property(nonatomic, readwrite) int type;
@property(nonatomic, readwrite) int ihb;
@property(nonatomic, readwrite) int avg;
@property(nonatomic, readwrite) int userNO;

@end

@interface TDTPData : NSObject
{
    int indexID;
    int inputDate;
    NSString *rawData;
    CGFloat value;
    int upload;
    int meterUID;
    int userNO;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int inputDate;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) CGFloat value;
@property(nonatomic, readwrite) int upload;
@property(nonatomic, readwrite) int meterUID;
@property(nonatomic, readwrite) int userNO;

@end

@interface TDSOData : NSObject
{
    int indexID;
    int inputDate;
    NSString *rawData;
    CGFloat spo2Value;  //value1
    CGFloat pulse;  //value3
    int upload;
    int meterUID;
    int userNO;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int inputDate;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) CGFloat spo2Value;
@property(nonatomic, readwrite) CGFloat pulse;
@property(nonatomic, readwrite) int upload;
@property(nonatomic, readwrite) int meterUID;
@property(nonatomic, readwrite) int userNO;

@end


@interface TDSettingData : NSObject
{
    
    NSString *lang;
    NSString *deviceSerialNumber;
    
    int bgmACSafeL;
    int bgmACSafeH;
    int bgmPCSafeL;
    int bgmPCSafeH;
    int bgmGENSafeL;
    int bgmGENSafeH;
    int bpmSYSSafeL;
    int bpmSYSSafeH;
    int bpmDIASafeL;
    int bpmDIASafeH;
    int wsSafeH;
    
    float tempH;
    float tempL;
    int spo2;
    
}


@property (nonatomic, retain) NSString *lang;
@property (nonatomic, retain) NSString *deviceSerialNumber;

@property(nonatomic, readwrite) int bgmACSafeL;
@property(nonatomic, readwrite) int bgmACSafeH;
@property(nonatomic, readwrite) int bgmPCSafeL;
@property(nonatomic, readwrite) int bgmPCSafeH;
@property(nonatomic, readwrite) int bgmGENSafeL;
@property(nonatomic, readwrite) int bgmGENSafeH;
@property(nonatomic, readwrite) int bpmSYSSafeL;
@property(nonatomic, readwrite) int bpmSYSSafeH;
@property(nonatomic, readwrite) int bpmDIASafeL;
@property(nonatomic, readwrite) int bpmDIASafeH;
@property(nonatomic, readwrite) int wsSafeH;

@property (nonatomic, readwrite) float tempH;
@property (nonatomic, readwrite) float tempL;
@property (nonatomic, readwrite) int spo2;



@end
@interface TDMeterProfile:NSObject
{
    int _id;
    NSString *deviceType;
    NSString *deviceId;
    NSString *deviceMacAddress;
    NSString *lastImport;
    int userNO;
}

//@property (nonatomic) int _id;
//@property (nonatomic, retain) NSString *deviceType;
//@property (nonatomic, retain) NSString *deviceId;
//@property (nonatomic, retain) NSString *deviceMacAddress;
//@property (nonatomic, retain) NSString *lastImport;
//@property (nonatomic, readwrite) int userNO;

@property  int _id;
@property  NSString *deviceType;
@property  NSString *deviceId;
@property  NSString *deviceMacAddress;
@property  NSString *lastImport;
@property  int userNO;


@end

@interface TD_Check_Glu_HI_LOW :NSObject
{
    
}
+(NSString*)  Get_GluValue_DISPLAY:(CGFloat)iGluvalue valueType:(TDSettingData*)pSettingData;

@end

@interface TD_check_Tmp_HI_LOW : NSObject
{
    
}
+(NSString*) Get_TmpValue_HI_LO_DISPLAY:(CGFloat)iTmpvalue valueType:(TDSettingData*)pSettingData;

@end



@interface TDWSResult :NSObject
{
    
    int  iYerar;
    int iMonth;
    int iDay;
    int iHour;
    int iMinute;
    int iCode;
    WSGenderType pWSGenderType;
    int iHeight;
    int iAge;
    double dWeight;
    double dMachineBmi;
    double dCaledBmi;
    NSDate* CreateDate;
    //add w65 data
    double dBodyFat;
    double dBodyWater;
    double dMuscle;
    double dBone;
    double dBMR;
    int iMeterUserNo;
}
@property(nonatomic, readwrite) int  iYerar;
@property(nonatomic, readwrite) int iMonth;
@property(nonatomic, readwrite) int iDay;
@property(nonatomic, readwrite) int iHour;
@property(nonatomic, readwrite) int iMinute;
@property(nonatomic, readwrite) int iCode;
@property(nonatomic, readwrite) WSGenderType pWSGenderType;
@property(nonatomic, readwrite) int iHeight;
@property(nonatomic, readwrite) int iAge;
@property(nonatomic, readwrite) double dWeight;
@property(nonatomic, readwrite) double dMachineBmi;
@property(nonatomic, readwrite) double dCaledBmi;
@property(nonatomic, retain) NSDate* CreateDate;

//add w65 data
@property(nonatomic, readwrite) double dBodyFat;
@property(nonatomic, readwrite) double dBodyWater;
@property(nonatomic, readwrite) double dMuscle;
@property(nonatomic, readwrite) double dBone;
@property(nonatomic, readwrite) double dBMR;
@property(nonatomic, readwrite) int  iMeterUserNo;

@end



@interface TDWSData : TDWSResult
{
    int indexID;
    int inputDate;
    NSString *rawData;
    int upload;
    int meterUID;
}

@property(nonatomic, readwrite) int indexID;
@property(nonatomic, readwrite) int inputDate;
@property(nonatomic, retain) NSString *rawData;
@property(nonatomic, readwrite) int upload;
@property(nonatomic, readwrite) int meterUID;

@end
