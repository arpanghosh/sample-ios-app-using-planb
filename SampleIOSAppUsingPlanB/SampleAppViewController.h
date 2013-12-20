//
//  SampleAppViewController.h
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/17/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>

#import "SampleAppRandomYelpRecommender.h"
#import "SampleAppBannerAdDelegate.h"


@interface SampleAppViewController : UIViewController <SampleAppRandomYelpRecommenderDelegate>

@property (nonatomic) BOOL shakeDetectionActive;

@end
