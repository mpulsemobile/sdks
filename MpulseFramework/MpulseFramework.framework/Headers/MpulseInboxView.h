//
//  MpulseInboxView.h
//  MpulseFramework
//
//  Created by mPulse Team on 05/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MpulseInboxView : UIView
@property(nonatomic,weak) id _Nullable delegate;
/**
 @method loadInbox
 @discussion This is the designated to load mpulse secure message inbox view for app member Id configured in MpulseHandler
 */
-(void)loadInbox;

@end

@protocol MpulseInboxViewDelegate
@optional
-(void) inboxViewDidStartLoading; //Called when inbox starts loading on loadInbox method
-(void) inboxViewDidFinishLoading; //Called when inbox ends loading on loadInbox method
-(void) inboxViewDidFailLoadingWithError:(NSError *_Nonnull)error; //Called when some error occurs in inbox loading on loadInbox method
@end

