//
//  MeterEventArgs.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfoEventArgs : NSObject {
    NSInteger userNumber;
    NSString *projectNo;
    NSString *subModel;
}

@property (nonatomic, readwrite) NSInteger userNumber;
@property (nonatomic, retain) NSString *projectNo;
@property (nonatomic, retain) NSString *subModel;

@end
