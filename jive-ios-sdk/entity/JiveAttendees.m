//
//  JiveAttendees.m
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/19/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveAttendees.h"
#import "JiveTypedObject_internal.h"

struct JiveAttendeesAttributes const JiveAttendeesAttributes = {
    .users = @"users",
    .moreAvailable = @"moreAvailable",
};

@implementation JiveAttendees

@synthesize users, moreAvailable;

- (Class)arrayMappingFor:(NSString*)propertyName {
    if ([JiveAttendeesAttributes.users isEqualToString:propertyName]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

@end
