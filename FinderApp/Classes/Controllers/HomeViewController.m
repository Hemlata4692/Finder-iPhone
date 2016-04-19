//
//  HomeViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "HomeViewController.h"
#import "ConferenceService.h"
#import "ConferenceDataModel.h"

@interface HomeViewController ()
{
    NSMutableArray *conferenceDetailArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *conferenceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conferenceImageView;
@property (weak, nonatomic) IBOutlet UILabel *conferenceDescription;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conferenceOrganiserHeading;
@property (weak, nonatomic) IBOutlet UILabel *conferenceVenueHeading;
@property (weak, nonatomic) IBOutlet UIImageView *conferenceOrganiserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *conferenceVenueImageView;
@property (weak, nonatomic) IBOutlet UILabel *conferenceOrganiserName;
@property (weak, nonatomic) IBOutlet UILabel *conferenceVenue;
@property (weak, nonatomic) IBOutlet UILabel *conferenceDateHeading;
@property (weak, nonatomic) IBOutlet UIImageView *conferenceDateImageView;
@property (weak, nonatomic) IBOutlet UILabel *conferenceDate;

@end

@implementation HomeViewController
@synthesize homeScrollView,mainContainerView,conferenceTitleLabel,conferenceImageView,conferenceDateHeading,conferenceDateImageView,conferenceDate;
@synthesize conferenceDescription,descriptionHeadingLabel,conferenceVenueHeading,conferenceOrganiserImageView,conferenceOrganiserName,conferenceVenue;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"HOME";

    [self setTabBarImages];
    conferenceDetailArray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getConferenceDetail) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Set tabbar images
-(void)setTabBarImages
{
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    [[[self tabBarController] tabBar] setBackgroundColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:45/255.0 green:113/255.0 blue:166/255.0 alpha:1.0] } forState:UIControlStateSelected];
    
    tabBar.clipsToBounds=YES;
    [tabBarItem1 setImage:[[UIImage imageNamed:@"email_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"lock_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"email_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"lock_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setTitlePositionAdjustment:UIOffsetMake(-7, -5)];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"email_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"lock_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"email_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"lock_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setTitlePositionAdjustment:UIOffsetMake(8, -5)];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabBarItem5 setImage:[[UIImage imageNamed:@"email_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"lock_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setTitlePositionAdjustment:UIOffsetMake(2, -5)];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}

#pragma mark - end

#pragma mark - Webservice
-(void)getConferenceDetail
{
    [[ConferenceService sharedManager] getConferenceDetail:^(id conferenceArray) {
        [myDelegate stopIndicator];
        conferenceDetailArray=[conferenceArray mutableCopy];
        [self displayConferenceDetail];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
    
}

-(void)displayConferenceDetail
{
    __weak UIImageView *weakRef = conferenceImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[conferenceDetailArray objectAtIndex:0]conferenceImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [conferenceImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFit;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    conferenceTitleLabel.text=[[conferenceDetailArray objectAtIndex:0]conferenceName];
    conferenceDescription.text=[[conferenceDetailArray objectAtIndex:0]conferenceDescription];
    conferenceOrganiserName.text=[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName];
    conferenceVenue.text=[[conferenceDetailArray objectAtIndex:0]conferenceVenue];
    conferenceDate.text=[[conferenceDetailArray objectAtIndex:0]conferenceDate];
}
#pragma mark - end
@end
