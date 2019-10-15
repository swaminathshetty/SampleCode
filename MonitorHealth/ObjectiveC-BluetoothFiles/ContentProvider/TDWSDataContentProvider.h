//
//  TDWSDataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"

#define TDBP_TYPE_AVERAGE 1
#define TDWS_TYPE_WEIGHT 0
#define TDWS_TYPE_AVERAGE 4 // special type for chart

#define DECREASE_WEIGHT 0
#define INCREASE_WEIGHT 1


@interface TDWSDataContentProvider : TDContentProvider

- (void) addWSData: (TDWSData *) data;
- (int) checkDataRepeat: (int)MDateTime Data1: (double)value1 Data3: (double)value3;
@end
