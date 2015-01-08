//
//  JiveTypedObject.h
//  
//
//  Created by Orson Bushnell on 2/25/13.
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

#import "JiveObject.h"

extern struct JiveTypedObjectAttributes {
    __unsafe_unretained NSString *type;
} const JiveTypedObjectAttributes;

//! \class JiveTypedObject
//! An iOS specific class with no REST api equivalent.
@interface JiveTypedObject : JiveObject

//! The object type of this object. This field is required when creating new content.
@property(nonatomic, readonly) NSString* type;

- (NSURL *)selfRef;
- (BOOL)canDelete;
- (BOOL)isUpdateable;

@end
