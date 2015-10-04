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
    __unsafe_unretained NSString *moreAvailable;
} const JiveAttendeesAttributes;

@interface JiveAttendees : JiveObject

@property(nonatomic, readonly, strong) NSArray *users;
@property (nonatomic, readonly) BOOL moreAvailable;

@end
