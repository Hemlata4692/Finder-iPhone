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
    CGSize size;
    CGRect textRect;
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
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@end

@implementation HomeViewController
@synthesize homeScrollView,mainContainerView,conferenceTitleLabel,conferenceImageView,conferenceDateHeading,conferenceDateImageView,conferenceDate,conferenceOrganiserHeading;
@synthesize conferenceDescription,descriptionHeadingLabel,conferenceVenueHeading,conferenceOrganiserImageView,conferenceOrganiserName,conferenceVenue,bottomContainerView;
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
    [super viewWillAppear:YES];
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
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:237.0/255.0 green:120.0/255.0 blue:0.0/255.0 alpha:1.0] } forState:UIControlStateSelected];
    
    tabBar.clipsToBounds=YES;
    [tabBarItem1 setImage:[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"home_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setTitlePositionAdjustment:UIOffsetMake(0, -6)];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"matches.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"matches_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setTitlePositionAdjustment:UIOffsetMake(-7, -6)];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"message.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"message_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setTitlePositionAdjustment:UIOffsetMake(0, -6)];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"calendar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setTitlePositionAdjustment:UIOffsetMake(8, -6)];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    
    [tabBarItem5 setImage:[[UIImage imageNamed:@"more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"more_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setTitlePositionAdjustment:UIOffsetMake(2, -6)];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
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
//Display data
-(void)displayConferenceDetail
{
    conferenceTitleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    conferenceDescription.translatesAutoresizingMaskIntoConstraints = YES;
    conferenceVenue.translatesAutoresizingMaskIntoConstraints = YES;
    conferenceOrganiserName.translatesAutoresizingMaskIntoConstraints=YES;
    mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
   
    size = CGSizeMake(conferenceTitleLabel.frame.size.width,100);
     textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceName] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:16]];
    conferenceTitleLabel.numberOfLines = 0;
    conferenceTitleLabel.frame = CGRectMake(8, conferenceTitleLabel.frame.origin.y, mainContainerView.frame.size.width-16, textRect.size.height);
    conferenceTitleLabel.text = [[conferenceDetailArray objectAtIndex:0]conferenceName];
   
 
    size = CGSizeMake(mainContainerView.frame.size.width-16,250);
   textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceDescription] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    conferenceDescription.numberOfLines = 0;
    conferenceDescription.frame = CGRectMake(8, descriptionHeadingLabel.frame.origin.y+descriptionHeadingLabel.frame.size.height, mainContainerView.frame.size.width-16, textRect.size.height);
    conferenceDescription.text=[[conferenceDetailArray objectAtIndex:0]conferenceDescription];
    conferenceDescription.layer.borderWidth=0.5f;
    conferenceDescription.layer.borderColor=[UIColor whiteColor].CGColor;
    
    size = CGSizeMake(conferenceOrganiserName.frame.size.width,60);
    textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    conferenceOrganiserName.numberOfLines = 2;
    conferenceOrganiserName.frame = CGRectMake(conferenceOrganiserName.frame.origin.x, conferenceOrganiserHeading.frame.origin.y+conferenceOrganiserHeading.frame.size.height+5, conferenceOrganiserName.frame.size.width, textRect.size.height);
    conferenceOrganiserName.text=[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName];
   
    size = CGSizeMake(conferenceVenue.frame.size.width,60);
    textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceVenue] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    conferenceVenue.numberOfLines = 0;
    conferenceVenue.frame = CGRectMake(conferenceVenue.frame.origin.x, conferenceVenueHeading.frame.origin.y+conferenceVenueHeading.frame.size.height+5, conferenceVenue.frame.size.width, textRect.size.height);
    conferenceVenue.text=[[conferenceDetailArray objectAtIndex:0]conferenceVenue];
    
    conferenceDate.text=[[conferenceDetailArray objectAtIndex:0]conferenceDate];
    
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
    float dynamicHeight=conferenceTitleLabel.frame.origin.y+conferenceTitleLabel.frame.size.height+7+conferenceImageView.frame.size.height+7+descriptionHeadingLabel.frame.size.height+2+conferenceDescription.frame.size.height+7+bottomContainerView.frame.size.height+30;
   
    
    mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
   // [homeScrollView setContentOffset:CGPointMake(0, 50) animated:NO];
    homeScrollView.contentSize = CGSizeMake(0,mainContainerView.frame.size.height+64);
}
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString fontSize:(UIFont *)fontSize
{
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:fontSize}
                         context:nil];
    return textHeight;
}
#pragma mark - end


@end
