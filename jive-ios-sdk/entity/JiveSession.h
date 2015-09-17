//
//  JiveSession.h
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/17/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveEvent.h"

extern struct JiveSessionAttributes {
    __unsafe_unretained NSString *startDate;
    __unsafe_unretained NSString *endDate;
    __unsafe_unretained NSString *location;
} const JiveSessionAttributes;

@interface JiveSession : JiveEvent

@property(nonatomic, readonly, strong) NSDate *startDate;
@property(nonatomic, readonly, strong) NSDate *endDate;
@property(nonatomic, readonly, copy) NSString *location;

@end
