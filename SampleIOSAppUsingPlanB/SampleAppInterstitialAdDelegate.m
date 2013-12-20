//
//  SampleAppInterstitialAdDelegate.m
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/20/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import "SampleAppInterstitialAdDelegate.h"

@interface SampleAppInterstitialAdDelegate()

@property (nonatomic, weak) SampleAppLaunchViewController *adDisplayingViewController;

@end



@implementation SampleAppInterstitialAdDelegate

-(instancetype)initWithPointerToAdDisplayingViewController:(SampleAppLaunchViewController *)displayingViewController{
    self = [super init];
    if (self){
        _adDisplayingViewController = displayingViewController;
    }
    return self;
}


- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd{
    
}


- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd{
    self.adDisplayingViewController.interstitialAdReadyToDisplay = YES;
}


- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd{
    
}


- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave{
    return YES;
}


- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd{
    self.adDisplayingViewController.interstitialAdReadyToDisplay = NO;
    [self.adDisplayingViewController performSegueWithIdentifier:@"LAUNCH_TO_MAIN" sender:self.adDisplayingViewController];
}


- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error{
    [self logWithMessage:@"Interstitial ad did fail with error" andError:error];
}


// Logging convenience method
-(void)logWithMessage:(NSString *)message andError:(NSError *)error{
    NSLog(@"%@ : %@\n%@ : %@", NSStringFromClass([self class]), message,
          [error localizedDescription],
          [error localizedFailureReason]);
}


@end
