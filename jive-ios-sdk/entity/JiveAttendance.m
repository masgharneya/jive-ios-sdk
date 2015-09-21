//
//  JiveAttendance.m
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/19/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveAttendance.h"
#import "JiveTypedObject_internal.h"

struct JiveAttendanceAttributes const JiveAttendanceAttributes = {
    .yesAttendees = @"yesAttendees",
    .noAttendees = @"noAttendees",
    .maybeAttendees = @"maybeAttendees",
    .unansweredInvitees = @"unansweredInvitees",
};

@implementation JiveAttendance

@synthesize yesAttendees, noAttendees, maybeAttendees, unansweredInvitees;

@end
