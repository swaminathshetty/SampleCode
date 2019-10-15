//
//  TDGlucoseDataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"


#define TDGLUCOSE_TYPE_GEN 0
#define TDGLUCOSE_TYPE_AC      1
#define TDGLUCOSE_TYPE_PC      2
#define TDGLUCOSE_TYPE_AVERAGE 4 // special type for chart
#define TDGLUCOSE_TYPE_BAC     12
#define TDGLUCOSE_TYPE_BPC     23
#define TDGLUCOSE_TYPE_LAC     14
#define TDGLUCOSE_TYPE_LPC     25
#define TDGLUCOSE_TYPE_DAC     16
#define TDGLUCOSE_TYPE_DPC     27

@interface TDGlucoseDataContentProvider : TDContentProvider
{
    
}
- (void) addGlucoseData: (TDGlucoseData *) data;
- (int) checkDataRepeat: (int)MDateTime Data1: (double)value1;

@end
