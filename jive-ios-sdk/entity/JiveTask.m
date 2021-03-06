//
//  JiveTask.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveTask.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveTypedObject_internal.h"


struct JiveTaskAttributes const JiveTaskAttributes = {
	.completed = @"completed",
	.dueDate = @"dueDate",
	.owner = @"owner",
    .parentTask = @"parentTask",
	.subTasks = @"subTasks",
};


@implementation JiveTask

@synthesize completed, dueDate, parentTask, subTasks, owner;

NSString * const JiveTaskType = @"task";

+ (void)load {
    if (self == [JiveTask class])
        [super registerClass:self forType:JiveTaskType];
}

- (NSString *)type {
    return JiveTaskType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:parentTask forKey:JiveTaskAttributes.parentTask];
    [dictionary setValue:completed forKey:JiveTaskAttributes.completed];
    [dictionary setValue:owner forKey:JiveTaskAttributes.owner];
    if (subTasks)
        [dictionary setValue:subTasks forKey:JiveTaskAttributes.subTasks];
    
    if (dueDate)
        [dictionary setValue:[dateFormatter stringFromDate:dueDate] forKey:JiveTaskAttributes.dueDate];
    
    return dictionary;
}

@end
