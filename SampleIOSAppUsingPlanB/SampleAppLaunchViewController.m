//
//  SampleAppLaunchViewController.m
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/19/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import "SampleAppLaunchViewController.h"


@interface SampleAppLaunchViewController ()

@property (nonatomic, strong) ADInterstitialAd *interstitialAd;
@property (nonatomic, strong) SampleAppInterstitialAdDelegate *interstitialAdDelegate;

@end


@implementation SampleAppLaunchViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        if (self.interstitialAdReadyToDisplay) {
            /* Deprecated but still using because there is no other way to
             present an interstitial ad modally unless you want to completely
             automate iAds by using the UIViewController iAd additions*/
            [self.interstitialAd presentFromViewController:self];
        }else{
            [self performSegueWithIdentifier:@"LAUNCH_TO_MAIN" sender:self];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self becomeFirstResponder];
    [self initializeInterstitialAdStuff];
}


-(void) initializeInterstitialAdStuff{
    self.interstitialAd = [[ADInterstitialAd alloc] init];
    self.interstitialAdDelegate =
    [[SampleAppInterstitialAdDelegate alloc] initWithPointerToAdDisplayingViewController:self];
    self.interstitialAd.delegate = self.interstitialAdDelegate;
}


-(void)logWithMessage:(NSString *)message andError:(NSError *)error{
    NSLog(@"%@ : %@\n%@ : %@", NSStringFromClass([self class]), message,
          [error localizedDescription],
          [error localizedFailureReason]);
}


@end
