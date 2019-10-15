//
//  TDBPDataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"


#define TDBP_TYPE_SYS 0
#define TDBP_TYPE_DIA      1
#define TDBP_TYPE_PULSE      2

@interface TDBPDataContentProvider : TDContentProvider
- (void) addBPData: (TDBPData *) data;
- (int) checkDataRepeat: (int)MDateTime Data1: (double)value1 Data2: (double)value2 Data3: (double)value3;

@end
