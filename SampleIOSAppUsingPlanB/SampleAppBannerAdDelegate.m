//
//  SampleAppBannerAdDelegate.m
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/19/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import "SampleAppBannerAdDelegate.h"

@interface SampleAppBannerAdDelegate()

@property (weak, nonatomic) SampleAppViewController *adDisplayingViewController;

@end



@implementation SampleAppBannerAdDelegate

-(instancetype)initWithPointerToAdDisplayingViewController:(SampleAppViewController *)viewController{
    self = [super init];
    if (self){
        _adDisplayingViewController = viewController;
    }
    return self;
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self logWithMessage:@"Banner failed to receive ad with error" andError:error];
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    self.adDisplayingViewController.shakeDetectionActive = YES;
}


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    if (!willLeave) {
        self.adDisplayingViewController.shakeDetectionActive = NO;
    }
    return YES;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
}


- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    
}


// Logging convenience method
-(void)logWithMessage:(NSString *)message andError:(NSError *)error{
    NSLog(@"%@ : %@\n%@ : %@", NSStringFromClass([self class]), message,
          [error localizedDescription],
          [error localizedFailureReason]);
}


@end
