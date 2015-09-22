//
//  JiveSession.h
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/17/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveEvent.h"
#import "JiveAttendance.h"

extern struct JiveSessionAttributes {
    __unsafe_unretained NSString *startDate;
    __unsafe_unretained NSString *endDate;
    __unsafe_unretained NSString *location;
    __unsafe_unretained NSString *attendance;
    __unsafe_unretained NSString *authors;
} const JiveSessionAttributes;

@interface JiveSession : JiveEvent

@property(nonatomic, readonly, strong) NSDate *startDate;
@property(nonatomic, readonly, strong) NSDate *endDate;
@property(nonatomic, readonly, copy) NSString *location;

@property (nonatomic, readonly, strong) JiveAttendance *attendance;

@property (nonatomic, readonly, strong) NSArray *authors;

@end
