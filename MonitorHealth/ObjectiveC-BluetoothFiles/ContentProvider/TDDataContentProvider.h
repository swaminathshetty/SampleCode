//
//  TDDataContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "TDContentProvider.h"
#import "DataDefinition.h"
#import "TDUtility.h"

@interface TDDataContentProvider : TDContentProvider

- (NSMutableArray *) getDataLimitCounts:(int)iStart andCounts:(int) iCount whichType:(int)type;
- (NSInteger) getDataCounts:(int)type;

@end
