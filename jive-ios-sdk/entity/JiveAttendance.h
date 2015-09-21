//
//  JiveAttendance.h
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/19/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JiveAttendees.h"

extern struct JiveAttendanceAttributes {
    __unsafe_unretained NSString *yesAttendees;
    __unsafe_unretained NSString *noAttendees;
    __unsafe_unretained NSString *maybeAttendees;
    __unsafe_unretained NSString *unansweredInvitees;
} const JiveAttendanceAttributes;

@interface JiveAttendance : JiveObject

@property (nonatomic, readonly, strong) JiveAttendees *yesAttendees;
@property (nonatomic, readonly, strong) JiveAttendees *noAttendees;
@property (nonatomic, readonly, strong) JiveAttendees *maybeAttendees;
@property (nonatomic, readonly, strong) JiveAttendees *unansweredInvitees;

@end
