//
//  TDSettingContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDContentProvider.h"
#import "DataDefinition.h"


@interface TDSettingContentProvider : TDContentProvider
{
    sqlite3 *dbhandle;
    TDSettingData *workingCopy;
}

@property(nonatomic, retain) TDSettingData *workingCopy;

- (TDSettingData *) getSettingData;
- (void) updateSettingData:(TDSettingData *)settingData;
@end
