//
//  SampleAppInterstitialAdDelegate.h
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/20/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

#import "SampleAppLaunchViewController.h"

@interface SampleAppInterstitialAdDelegate : NSObject <ADInterstitialAdDelegate>

// Designated initializer
-(instancetype)initWithPointerToAdDisplayingViewController:(UIViewController *)displayingViewController;

@end
