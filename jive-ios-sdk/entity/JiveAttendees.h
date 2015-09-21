//
//  JiveAttendees.h
//  jive-ios-sdk
//
//  Created by Mohammad Asgharneya on 9/19/15.
//  Copyright © 2015 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"

extern struct JiveAttendeesAttributes {
    __unsafe_unretained NSString *users;
} const JiveAttendeesAttributes;

@interface JiveAttendees : JiveObject

@property(nonatomic, readonly, strong) NSArray *users;

@end
