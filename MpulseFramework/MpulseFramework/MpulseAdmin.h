//
//  MpulseAdmin.h
//  MpulseFramework
//
//  Created by Rahul Verma on 06/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpulseControlPanel.h"
#import "Member.h"
#import "Event.h"

@interface MpulseAdmin : NSObject

-(id _Nonnull)initWithAccessToken:(NSString *_Nonnull)accessToken;

-(void)createNewMember:(Member* _Nonnull)member inList:(NSString* _Nullable)listID completionHandler: (void (^_Nonnull)(MpulseAudienceResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;

-(void)updateMemberWithID:(NSString *_Nullable)memberID details:(Member *_Nonnull)member andList:(NSString*_Nullable)listID completionHandler: (void (^_Nonnull)(MpulseAudienceResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;

-(void)sendEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulseEventUploadResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

@end
