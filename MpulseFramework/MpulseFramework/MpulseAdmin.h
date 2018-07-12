//
//  MpulseAdmin.h
//  MpulseFramework
//
//  Created by Rahul Verma on 06/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpulseHandler.h"
#import "Member.h"

@interface MpulseAdmin : NSObject

-(id _Nonnull)init;

-(void)createNewMember:(Member* _Nonnull)member inLists:(NSArray* _Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;

-(void)updateMemberWithID:(NSString *_Nonnull)memberID details:(Member *_Nonnull)member andLists:(NSArray*_Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;

-(void)sendEvent:(NSString *_Nonnull)event toMembers:(NSArray *_Nullable)memberIDs inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

@end
