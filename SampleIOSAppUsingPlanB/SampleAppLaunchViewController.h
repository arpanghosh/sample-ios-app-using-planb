//
//  SampleAppLaunchViewController.h
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/19/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>  

#import "SampleAppViewController.h"
#import "SampleAppInterstitialAdDelegate.h"

@interface SampleAppLaunchViewController : UIViewController

@property (nonatomic) BOOL interstitialAdReadyToDisplay;

@end
