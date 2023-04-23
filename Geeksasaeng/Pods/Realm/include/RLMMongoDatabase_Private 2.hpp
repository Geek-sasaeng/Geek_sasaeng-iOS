////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Realm/RLMMongoClient.h>

RLM_HEADER_AUDIT_BEGIN(nullability)

@class RLMUser;

<<<<<<<< HEAD:Geeksasaeng/Pods/Realm/include/RLMMongoCollection_Private.h
@interface RLMMongoCollection ()
========
@interface RLMMongoDatabase ()

@property (nonatomic, strong) RLMUser *user;
@property (nonatomic, strong) NSString *serviceName;

>>>>>>>> 0aa1b9ac171d3b37f4aa2b3182fbc8c0edbc1cfd:Geeksasaeng/Pods/Realm/include/RLMMongoDatabase_Private 2.hpp
- (instancetype)initWithUser:(RLMUser *)user
                 serviceName:(NSString *)serviceName
                databaseName:(NSString *)databaseName;

- (RLMChangeStream *)watchWithMatchFilter:(nullable id<RLMBSON>)matchFilter
                                 idFilter:(nullable id<RLMBSON>)idFilter
                                 delegate:(id<RLMChangeEventDelegate>)delegate
                                scheduler:(void (^)(dispatch_block_t))scheduler;
@end

RLM_HEADER_AUDIT_END(nullability)
