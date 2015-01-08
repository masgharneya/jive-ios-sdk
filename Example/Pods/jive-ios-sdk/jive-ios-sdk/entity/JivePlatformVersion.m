//
//  JivePlatformVersion.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
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

#import "JivePlatformVersion.h"
#import "JiveObject_internal.h"
#import "JiveCoreVersion.h"

struct JivePlatformVersionAttributes const JivePlatformVersionAttributes = {
	.major = @"major",
	.minor = @"minor",
	.maintenance = @"maintenance",
	.build = @"build",
	.releaseID = @"releaseID",
	.coreURI = @"coreURI",
    .ssoEnabled = @"ssoEnabled",
    .sdk = @"sdk",
    .instanceURL = @"instanceURL"
};

static NSString * const JiveVersionKey = @"jiveVersion";
static NSString * const JiveCoreVersionsKey = @"jiveCoreVersions";

typedef NS_ENUM(NSInteger, JiveVersionString) {
    JiveVersionStringVersionComponents = 0,
    JiveVersionStringReleaseID
};

typedef NS_ENUM(NSInteger, JiveVersionComponents) {
    JiveVersionComponentsMajor = 0,
    JiveVersionComponentsMinor,
    JiveVersionComponentsMaintenance,
    JiveVersionComponentsBuild
};

struct JVSemanticVersion {
    NSUInteger majorVersion;
    NSUInteger minorVersion;
    NSUInteger maintenanceVersion;
    NSUInteger buildVersion;
};
typedef struct JVSemanticVersion JVSemanticVersion;

static inline JVSemanticVersion JVSemanticVersionMake(NSUInteger majorVersion,
                                                      NSUInteger minorVersion,
                                                      NSUInteger maintenanceVersion,
                                                      NSUInteger buildVersion) {
    JVSemanticVersion semanticVersion;
    semanticVersion.majorVersion = majorVersion;
    semanticVersion.minorVersion = minorVersion;
    semanticVersion.maintenanceVersion = maintenanceVersion;
    semanticVersion.buildVersion = buildVersion;
    return semanticVersion;
}

struct Jive8ReleaseIDs const Jive8ReleaseIDs = {
    .cloud1 = @"8c1",
    .cloud2 = @"8c2",
    .cloud3 = @"8c3",
    .cloud4 = @"8c4",
};


@implementation JivePlatformVersion

@synthesize ssoEnabled, instanceURL, ssoForOAuthGrantEnabled, jiveEdition;

- (void)parseVersion:(NSString *)versionString {
    NSArray *components = [versionString componentsSeparatedByString:@" "];
    
    if ([components count] == 2)
        [self setValue:components[JiveVersionStringReleaseID] forKey:JivePlatformVersionAttributes.releaseID];
    
    components = [components[JiveVersionStringVersionComponents] componentsSeparatedByString:@"."];
    [self setValue:@([components[JiveVersionComponentsMajor] integerValue])
            forKey:JivePlatformVersionAttributes.major];
    [self setValue:@([components[JiveVersionComponentsMinor] integerValue])
            forKey:JivePlatformVersionAttributes.minor];
    if ([components count] > JiveVersionComponentsMaintenance) {
        [self setValue:@([components[JiveVersionComponentsMaintenance] integerValue])
                forKey:JivePlatformVersionAttributes.maintenance];
        if ([components count] > JiveVersionComponentsBuild)
            [self setValue:@([components[JiveVersionComponentsBuild] integerValue])
                    forKey:JivePlatformVersionAttributes.build];
    }
}

+ (JivePlatformVersion*) objectFromJSON:(NSDictionary*)JSON withInstance:(Jive *)instance {
    JivePlatformVersion *version = [JivePlatformVersion new];
    NSInteger requiredElementsFound = 0;
    
    for (NSString *key in JSON) {
        if ([JiveVersionKey isEqualToString:key]) {
            [version parseVersion:JSON[key]];
            ++requiredElementsFound;
        }
        else if ([JiveCoreVersionsKey isEqualToString:key]) {
            NSArray *coreURIs = [JiveCoreVersion objectsFromJSONList:JSON[key]
                                                          withInstance:instance];
            
            [version setValue:coreURIs forKey:JivePlatformVersionAttributes.coreURI];
            ++requiredElementsFound;
        }
        else
            if ([key isEqualToString:@"instanceURL"]) {
                NSString *instanceURL = JSON[key];
                if (![instanceURL hasSuffix:@"/"]) {
                    [version deserializeKey:key fromJSON:@{key:[instanceURL stringByAppendingString:@"/"]} fromInstance:instance];
                } else {
                    [version deserializeKey:key fromJSON:JSON fromInstance:instance];
                }
            } else {
                [version deserializeKey:key fromJSON:JSON fromInstance:instance];
            }
    }
    
    return requiredElementsFound == 2 ? version : nil;
}

- (NSString *)sdk {
    return // The following include is generated by the build server
#include "JiveiOSSDKVersion.h"
    ;
}

#pragma mark - Version checks

/** Version checks rely on the semantic version of the platform. */

- (BOOL)supportsFeatureAvailableWithSemanticVersion:(JVSemanticVersion)version {
    return [self supportsFeatureAvailableWithMajorVersion:version.majorVersion
                                                minorVersion:version.minorVersion
                                          maintenanceVersion:version.maintenanceVersion
                                                buildVersion:version.buildVersion];
}

- (BOOL)supportsFeatureAvailableWithMajorVersion:(NSUInteger)majorVersion
                                       minorVersion:(NSUInteger)minorVersion
                                 maintenanceVersion:(NSUInteger)maintenanceVersion
                                       buildVersion:(NSUInteger)buildVersion {
    BOOL supported = YES;
    
    // confirm the semantic version is supported
    if (majorVersion > [self.major unsignedIntegerValue]) {
        supported = NO;
    } else if (majorVersion == [self.major unsignedIntegerValue]) {
        if (minorVersion > [self.minor unsignedIntegerValue]) {
            supported = NO;
        } else if (minorVersion == [self.minor unsignedIntegerValue]) {
            if (maintenanceVersion > [self.maintenance unsignedIntegerValue]) {
                supported = NO;
            }
            else if (maintenanceVersion == [self.maintenance unsignedIntegerValue]) {
                if (buildVersion > [self.build unsignedIntegerValue]) {
                    supported = NO;
                }
            }
        }
    }
    return supported;
}

- (BOOL)verifyReleaseIDs:(NSSet *)releaseIDs {
    // confirm any release ID is supported if available
    if ([self.releaseID length] > 0 && [releaseIDs count] && ![releaseIDs containsObject:self.releaseID]) {
        return NO;
    }
    return YES;
}

#pragma mark - Release ID Sets

+ (NSSet *)cloud1SupportedReleaseIDs {
    return [[self cloud2SupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud1];
}

+ (NSSet *)cloud1UnsupportedReleaseIDs {
    return [NSSet setWithObject:Jive8ReleaseIDs.cloud1];
}

+ (NSSet *)cloud2SupportedReleaseIDs {
    return [[self cloud3SupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud2];
}

+ (NSSet *)cloud2UnsupportedReleaseIDs {
    return [[self cloud1UnsupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud2];
}

+ (NSSet *)cloud3SupportedReleaseIDs {
    return [[self cloud4SupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud3];
}

+ (NSSet *)cloud3UnsupportedReleaseIDs {
    return [[self cloud2UnsupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud3];
}

+ (NSSet *)cloud4SupportedReleaseIDs {
    return [NSSet setWithObject:Jive8ReleaseIDs.cloud4];
}

+ (NSSet *)cloud4UnsupportedReleaseIDs {
    return [[self cloud3UnsupportedReleaseIDs] setByAddingObject:Jive8ReleaseIDs.cloud4];
}

#pragma mark - Public API

- (BOOL)allowsSSOForOAuth {
    return [self.ssoForOAuthGrantEnabled boolValue];
}

- (BOOL)supportsDraftPostCreation {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsDraftPostContentFilter {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsExplicitSSO {
    // https://jira.jivesoftware.com/browse/JIVE-21305
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 2, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsFollowing {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 4, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsStatusUpdateInPlace {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsBookmarkInboxEntries {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsCorrectAndHelpfulReplies {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsStructuredOutcomes {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsExplicitCorrectAnswerAPI {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsUnmarkAsCorrectAnswer {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsDiscussionLikesInActivityObjects {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsInboxTypeFiltering {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsCommentAndReplyPermissions {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportedIPhoneVersion {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsOAuth {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];    
}

- (BOOL)supportsOAuthSessionGrant {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 1, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsFeatureModuleVideoProperty {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 1, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsContentEditingAPI {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsLikeCountInStreams {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsNativeAppAllowed {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(6, 0, 3, 2);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsCollapsingStreams {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(7, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsOriginParam {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(8, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];
}

- (BOOL)supportsPollOptionImages {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(8, 0, 0, 0);
    return [self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion];    
}

- (BOOL)removedPushNotificationActivatedFlag {
    JVSemanticVersion supportedJiveVersion = JVSemanticVersionMake(8, 0, 0, 0);
    return ([self supportsFeatureAvailableWithSemanticVersion:supportedJiveVersion]
            && (!self.releaseID
                || ![self verifyReleaseIDs:[JivePlatformVersion cloud3UnsupportedReleaseIDs]]));
}

@end
