//
//  TDSODataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"


#define TDSO_TYPE_SYS 0
#define TDSO_TYPE_DIA      1
#define TDSO_TYPE_PULSE      2

@interface TDSODataContentProvider : TDContentProvider

- (void) addSOData: (TDSOData *) data;
- (int) checkDataRepeat: (int)MDateTime Data1: (double)value1 Data3: (double)value3;

@end
