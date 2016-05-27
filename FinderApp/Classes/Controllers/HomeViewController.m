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
@property (nonatomic,retain) NSString * conferenceId;
@end

@implementation HomeViewController
@synthesize homeScrollView,mainContainerView,conferenceTitleLabel,conferenceImageView,conferenceDateHeading,conferenceDateImageView,conferenceDate,conferenceOrganiserHeading;
@synthesize conferenceDescription,descriptionHeadingLabel,conferenceVenueHeading,conferenceOrganiserImageView,conferenceOrganiserName,conferenceVenue,bottomContainerView;
@synthesize conferenceId;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Conference Details";
    
    conferenceDetailArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [myDelegate showIndicator];
    [self performSelector:@selector(getConferenceDetail) withObject:nil afterDelay:.1];
    
}

#pragma mark - end

#pragma mark - Webservice
-(void)getConferenceDetail
{
    conferenceId=[UserDefaultManager getValue:@"conferenceId"];
    [[ConferenceService sharedManager] getConferenceDetail:conferenceId success:^(id conferenceArray) {
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
    conferenceDescription.translatesAutoresizingMaskIntoConstraints = YES;
    mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
    
    conferenceTitleLabel.text = [[conferenceDetailArray objectAtIndex:0]conferenceName];
    conferenceOrganiserName.text=[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName];
    //    size = CGSizeMake(mainContainerView.frame.size.width-38,50);
    //    textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceVenue] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    //    conferenceVenue.numberOfLines = 0;
    //    conferenceVenue.frame = CGRectMake(28, conferenceVenue.frame.origin.y+conferenceVenue.frame.size.height, mainContainerView.frame.size.width-38, textRect.size.height);
    //      conferenceVenue.layer.borderWidth=0.5f;
    //      conferenceVenue.layer.borderColor=[UIColor whiteColor].CGColor;
    conferenceVenue.text=[[conferenceDetailArray objectAtIndex:0]conferenceVenue];
    
    conferenceDate.text=[[conferenceDetailArray objectAtIndex:0]conferenceDate];
    size = CGSizeMake(mainContainerView.frame.size.width-16,999);
    textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceDescription] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    conferenceDescription.numberOfLines = 0;
    conferenceDescription.frame = CGRectMake(8, descriptionHeadingLabel.frame.origin.y+descriptionHeadingLabel.frame.size.height+5, mainContainerView.frame.size.width-16, textRect.size.height);
    conferenceDescription.text=[[conferenceDetailArray objectAtIndex:0]conferenceDescription];
    
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
    
    float dynamicHeight=conferenceImageView.frame.origin.y+conferenceImageView.frame.size.height+8+descriptionHeadingLabel.frame.size.height+2+conferenceDescription.frame.size.height+8+bottomContainerView.frame.size.height+20;
    mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
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
