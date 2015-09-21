//
//  JiveSession.m
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/17/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveSession.h"
#import "JiveTypedObject_internal.h"

#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JiveSessionAttributes const JiveSessionAttributes = {
    .startDate = @"startDate",
    .endDate = @"endDate",
    .location = @"location",
    .attendance = @"attendance",
};

@implementation JiveSession

@synthesize startDate, endDate, location, attendance;

static NSString * const JiveEventType = @"event";

+ (void)load {
    if (self == [JiveSession class])
        [super registerClass:self forType:JiveEventType];
}

- (NSString *)type {
    return JiveEventType;
}

@end
