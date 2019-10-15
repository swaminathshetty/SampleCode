//
//  DatabaseCreation.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseCreation : NSObject

+(NSString *)creationOfDatabase;

+(NSString *)deleteDatabaseElements;
+(NSString *)deleteSysConfigDB;
+(NSString *)deleteMeterProfileDB;

@end
