//
//  SampleAppViewController.m
//  SampleIOSAppUsingPlanB
//
//  Created by Arpan Ghosh on 12/17/13.
//  Copyright (c) 2013 Plan B. All rights reserved.
//

#import "SampleAppViewController.h"


@interface SampleAppViewController ()

@property (nonatomic, strong) SampleAppRandomYelpRecommender *recommender;

@property (weak, nonatomic) IBOutlet UIImageView *recommendationBusinessImage;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessName;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessCategory;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessReviewCount;
@property (weak, nonatomic) IBOutlet UIImageView *recommendationBusinessRatingImage;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessSnippet;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessDistance;
@property (weak, nonatomic) IBOutlet UILabel *recommendationBusinessStreetAddress;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingRecommendation;
@property (weak, nonatomic) IBOutlet UILabel *loadingRecommendationMessage;
@property (weak, nonatomic) IBOutlet UILabel *recommendationError;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIButton *cancelTutorialView;
@property (weak, nonatomic) SampleAppViewControllerMainView *mainView;

@property (strong, nonatomic) UITapGestureRecognizer *imageTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *snippetTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *addressTapGestureRecognizer;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) SampleAppYelpRecommendation *randomRecommendation;

@property (nonatomic) BOOL isFirstAppLaunch;

@end


@implementation SampleAppViewController

// Methods to handle a user's tap for loading the Yelp page for the business
/*******************************************************************************************************************/

-(UITapGestureRecognizer *)imageTapGestureRecognizer{
    if (!_imageTapGestureRecognizer){
        _imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBusinessPageinYelp)];
        _imageTapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return _imageTapGestureRecognizer;
}


-(UITapGestureRecognizer *)snippetTapGestureRecognizer{
    if (!_snippetTapGestureRecognizer){
        _snippetTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBusinessPageinYelp)];
        _snippetTapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return _snippetTapGestureRecognizer;
}


-(void)openBusinessPageinYelp{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp:"]]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:[NSString stringWithFormat:@"yelp:///biz/%@", self.randomRecommendation.businessID]]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.randomRecommendation.yelpURL]];
    }
}

/******************************************************************************************************************/




// Methods to handle a user's tap for loading the Maps app to display the business' location
/******************************************************************************************************************/

-(UITapGestureRecognizer *)addressTapGestureRecognizer{
    if (!_addressTapGestureRecognizer){
        _addressTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToAddressTap)];
        _addressTapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return _addressTapGestureRecognizer;
}


-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


-(void)respondToAddressTap{
    [self.geocoder geocodeAddressString:self.randomRecommendation.fullAddress
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          if (error) {
                              [self logWithMessage:@"Geocoder failed with error" andError:error];
                          }else{
                              if(placemarks && placemarks.count > 0)
                              {
                                  MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]]];
                                  item.name = self.randomRecommendation.name;
                                  [item openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking}];
                              }
                          }
    }];
}

/*************************************************************************************************************************/





// SampleAppRandomYelpRecommender related methods
/**************************************************************************************************************/

-(SampleAppRandomYelpRecommender *)recommender{
    if (!_recommender) {
        _recommender = [SampleAppRandomYelpRecommender getRecommender];
        _recommender.delegate = self;
    }
    return _recommender;
}


- (void)didGenerateARandomRecommendation:(SampleAppYelpRecommendation *)randomRecommendation{
    self.randomRecommendation = randomRecommendation;
    if (self.randomRecommendation) {
        if (self.isFirstAppLaunch) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tutorialView setHidden:NO];
            });
        }
        [self updateViewWithValidRecommendation];
    }else{
        [self updateViewInCaseOfNoRecommendation];
    }
}


- (void)didFailToGenerateRandomRecommendationWithError:(NSError *)error{
    [self updateViewInCaseOfNoRecommendation];
    [self logWithMessage:@"Failed to fetch random Yelp recommendation with error" andError:error];
}

/*************************************************************************************************************/




// Methods for drawing the UI
/************************************************************************************************************/


-(void)updateViewWhileFetchingRecommendation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearViewElements];
        [self.loadingRecommendation startAnimating];
        self.loadingRecommendationMessage.hidden = NO;
    });
}


-(void)updateViewInCaseOfNoRecommendation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearViewElements];
        self.recommendationError.hidden = NO;
    });
}


-(void)updateViewWithValidRecommendation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearViewElements];
        
        self.recommendationBusinessName.text = self.randomRecommendation.name;
        self.recommendationBusinessName.hidden = NO;
        
        self.recommendationBusinessCategory.text = self.randomRecommendation.categories;
        self.recommendationBusinessCategory.hidden = NO;
        
        self.recommendationBusinessReviewCount.text =
        [NSString stringWithFormat:@"%d reviews",self.randomRecommendation.reviewCount];
        self.recommendationBusinessReviewCount.hidden = NO;
        
        self.recommendationBusinessSnippet.text =
        [NSString stringWithFormat:@"\"%@\"", self.randomRecommendation.snippet];
        self.recommendationBusinessSnippet.hidden = NO;
        
        self.recommendationBusinessDistance.text =
        [NSString stringWithFormat:@"%.2f miles", self.randomRecommendation.distanceInMiles];
        self.recommendationBusinessDistance.hidden = NO;
        
        self.recommendationBusinessStreetAddress.text = self.randomRecommendation.streetAddress;
        self.recommendationBusinessStreetAddress.hidden = NO;
        
        [self.randomRecommendation downloadBusinessImageIfRequiredAndDisplayInImageView:self.recommendationBusinessImage];
        [self.randomRecommendation downloadRatingImageIfRequiredAndDisplayInImageView:self.recommendationBusinessRatingImage];
    });
}


-(void)clearViewElements{
    self.recommendationBusinessName.hidden = YES;
    self.recommendationBusinessCategory.hidden = YES;
    self.recommendationBusinessReviewCount.hidden = YES;
    self.recommendationBusinessSnippet.hidden = YES;
    self.recommendationBusinessDistance.hidden = YES;
    self.recommendationBusinessStreetAddress.hidden = YES;
    self.recommendationBusinessImage.hidden = YES;
    self.recommendationBusinessRatingImage.hidden = YES;
    self.recommendationError.hidden = YES;
    self.loadingRecommendationMessage.hidden = YES;
    [self.loadingRecommendation stopAnimating];
}

/**************************************************************************************************************/





// Methods to handle the device's 'shake' motion
/**************************************************************************************************************/

-(void)shakeDetected{
    [self updateViewWhileFetchingRecommendation];
    [self.recommender fetchRandomRecommendation];
}


-(SampleAppViewControllerMainView *)mainView{
    return (SampleAppViewControllerMainView *)self.view;
}


/*************************************************************************************************************/




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}


-(void)viewWillAppear:(BOOL)animated{
    self.mainView.delegate = self;
    [self.mainView becomeFirstResponder];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.mainView resignFirstResponder];
}


// Initialize everything for this ViewController
-(void)initialize{
    self.isFirstAppLaunch = [self firstAppLaunch];
    
    [self initializeGestureRecognizers];
    [self initializeUIElements];
    
    //Fetch the first recommendation
    [self updateViewWhileFetchingRecommendation];
    [self.recommender fetchRandomRecommendation];
}


-(void)initializeUIElements{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recommendationBusinessReviewCount.layer.cornerRadius = 4;
        self.recommendationBusinessStreetAddress.layer.cornerRadius = 4;
        self.recommendationBusinessDistance.layer.cornerRadius = 4;
        
        [self.tutorialView setHidden:YES];
    });
}


-(void) initializeGestureRecognizers{
    [self.recommendationBusinessImage addGestureRecognizer:self.imageTapGestureRecognizer];
    [self.recommendationBusinessSnippet addGestureRecognizer:self.snippetTapGestureRecognizer];
    [self.recommendationBusinessStreetAddress addGestureRecognizer:self.addressTapGestureRecognizer];
}


-(BOOL)firstAppLaunch{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){ return NO; }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}


- (IBAction)tutorialViewCancelled {
    self.isFirstAppLaunch = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tutorialView removeFromSuperview];
    });
}


// Logging convenience method
-(void)logWithMessage:(NSString *)message andError:(NSError *)error{
    NSLog(@"%@ : %@\n%@ : %@", NSStringFromClass([self class]), message,
          [error localizedDescription],
          [error localizedFailureReason]);
}


@end
