//
//  TDTPDataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"

#define TDTP_TYPE_SYS 0
#define TDTP_TYPE_DIA      1
#define TDTP_TYPE_PULSE      2

@interface TDTPDataContentProvider : TDContentProvider

- (void) addTPData: (TDTPData *) data;
- (int) checkDataRepeat: (int)MDateTime Data1: (double)value1;

@end
