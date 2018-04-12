//
//  mPulseInboxView.h
//  mPulseFramework
//
//  Created by Heena Dhawan on 05/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MpulseInboxViewDelegate
@optional
// list of optional methods
-(void) inboxDidStartLoading;
-(void) inboxDidFinishLoading;
-(void) inboxDidFailLoadingWithError:(NSError *_Nonnull)error;
@end

@interface MpulseInboxView : UIView
@property(nonatomic,strong) id _Nullable delegate;
-(void)loadInbox;
+(void)getMessageCountForAppMemberId:(NSString* _Nonnull)appMemberId completionHandler:(void (^_Nonnull)(NSDictionary * _Nullable jsonData, NSError * _Nullable error))completionHandler;
@end

