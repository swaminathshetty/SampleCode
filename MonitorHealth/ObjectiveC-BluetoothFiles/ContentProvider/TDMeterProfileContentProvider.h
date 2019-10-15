//
//  TDMeterProfileContentProvider.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDContentProvider.h"
#import "DataDefinition.h"

@interface TDMeterProfileContentProvider : TDContentProvider {
    
}

- (TDMeterProfile *) getMeterProfile:(NSString*) deviceType deviceID:(NSString *) deviceId userNO:(int) userNO;
- (void) updateMeterProfile : (TDMeterProfile *) meterProfile;

@end
