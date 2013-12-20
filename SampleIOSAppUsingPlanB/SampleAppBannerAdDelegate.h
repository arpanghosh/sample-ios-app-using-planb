//
//  SampleAppBannerAdDelegate.h
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/19/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

#import "SampleAppViewController.h"


@interface SampleAppBannerAdDelegate : NSObject <ADBannerViewDelegate>

// Designated initializer
-(instancetype)initWithPointerToAdDisplayingViewController:(UIViewController *)viewController;

@end
