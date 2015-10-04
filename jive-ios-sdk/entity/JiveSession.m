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

struct JiveSessionResourceTags {
    __unsafe_unretained NSString *yesAttendees;
    __unsafe_unretained NSString *maybeAttendees;
    __unsafe_unretained NSString *noAttendees;
    __unsafe_unretained NSString *invitees;
} const JiveSessionResourceTags;

struct JiveSessionResourceTags const JiveSessionResourceTags = {
    .yesAttendees = @"yesAttendees",
    .maybeAttendees = @"maybeAttendees",
    .noAttendees = @"noAttendees",
    .invitees = @"invitees",
};

struct JiveSessionAttributes const JiveSessionAttributes = {
    .startDate = @"startDate",
    .endDate = @"endDate",
    .location = @"location",
    .attendance = @"attendance",
    .authors = @"authors",
    .city = @"city"
};

@implementation JiveSession

@synthesize startDate, endDate, location, attendance, authors, city;

static NSString * const JiveEventType = @"event";

+ (void)load {
    if (self == [JiveSession class])
        [super registerClass:self forType:JiveEventType];
}

- (NSString *)type {
    return JiveEventType;
}


- (Class)arrayMappingFor:(NSString*)propertyName {
    if ([JiveSessionAttributes.authors isEqualToString:propertyName]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSURL *)yesAttendeesRef {
    return [self resourceForTag:JiveSessionResourceTags.yesAttendees].ref;
}

- (NSURL *)maybeAttendeesRef {
    return [self resourceForTag:JiveSessionResourceTags.maybeAttendees].ref;
}

- (NSURL *)noAttendeesRef {
    return [self resourceForTag:JiveSessionResourceTags.noAttendees].ref;
}

- (NSURL *)inviteesRef {
    return [self resourceForTag:JiveSessionResourceTags.invitees].ref;
}

@end
