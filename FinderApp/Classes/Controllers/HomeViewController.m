//
//  HomeViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "HomeViewController.h"
#import "ConferenceService.h"
#import "ConferenceDataModel.h"
#import "MJGeocodingServices.h"
#import "MapViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import <CoreText/CoreText.h>

@interface HomeViewController ()<MJGeocoderDelegate,MFMailComposeViewControllerDelegate>
{
    NSMutableArray *conferenceDetailArray;
    CGSize size;
    CGRect textRect;
    MJGeocoder *forwardGeocoder;
    NSString *latitude;
    NSString *longitude;
    
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
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (nonatomic,retain) NSString * conferenceId;
@property (weak, nonatomic) IBOutlet UIButton *viewMapButton;
@property (weak, nonatomic) IBOutlet UIButton *finderRepresentativeButton;

@end

@implementation HomeViewController
@synthesize homeScrollView,mainContainerView,conferenceTitleLabel,conferenceImageView,conferenceDateHeading,conferenceDateImageView,conferenceDate,conferenceOrganiserHeading;
@synthesize conferenceDescription,descriptionHeadingLabel,conferenceVenueHeading,conferenceOrganiserImageView,conferenceOrganiserName,conferenceVenue,bottomContainerView;
@synthesize conferenceId,viewMapButton;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Conference Details";
    conferenceDetailArray=[[NSMutableArray alloc]init];
    [viewMapButton setViewBorder:viewMapButton color:[UIColor colorWithRed:79.0/255.0 green:206.0/255.0 blue:195.0/255.0 alpha:1.0]];
    [myDelegate showIndicator];
    [self performSelector:@selector(getConferenceDetail) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - end

#pragma mark - Webservice
-(void)getConferenceDetail{
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
-(void)displayConferenceDetail{
    conferenceDescription.translatesAutoresizingMaskIntoConstraints = YES;
    mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
 
    conferenceTitleLabel.text = [[conferenceDetailArray objectAtIndex:0]conferenceName];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName]];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    conferenceOrganiserName.attributedText = attString;
    // conferenceOrganiserName.text=[[conferenceDetailArray objectAtIndex:0]conferenceOrganiserName];
 
    conferenceVenue.text=[[conferenceDetailArray objectAtIndex:0]conferenceVenue];
    conferenceDate.text=[[conferenceDetailArray objectAtIndex:0]conferenceDate];
    size = CGSizeMake(mainContainerView.frame.size.width-16,999);
    textRect=[self setDynamicHeight:size textString:[[conferenceDetailArray objectAtIndex:0]conferenceDescription] fontSize:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    conferenceDescription.numberOfLines = 0;
    conferenceDescription.frame = CGRectMake(8, descriptionHeadingLabel.frame.origin.y+descriptionHeadingLabel.frame.size.height+5, mainContainerView.frame.size.width-16, textRect.size.height);
    conferenceDescription.text=[[conferenceDetailArray objectAtIndex:0]conferenceDescription];
    __weak UIImageView *weakRef = conferenceImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[conferenceDetailArray objectAtIndex:0]conferenceImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [conferenceImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    float dynamicHeight=conferenceImageView.frame.origin.y+conferenceImageView.frame.size.height+8+descriptionHeadingLabel.frame.size.height+2+conferenceDescription.frame.size.height+8+bottomContainerView.frame.size.height+20;
    mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
    homeScrollView.contentSize = CGSizeMake(0,mainContainerView.frame.size.height+64);
    
    
}
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString fontSize:(UIFont *)fontSize{
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:fontSize}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - MJGeocoderDelegate
//Getting the location of store added
- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSArray * displayedResults = [locations mutableCopy] ;
    Address *address = [displayedResults objectAtIndex:0];
    latitude=address.latitude;
    longitude=address.longitude ;
    NSLog(@"lat lon are %f %f,",[latitude floatValue],[longitude floatValue]);
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapView =[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    mapView.latitude=latitude;
    mapView.longitude=longitude;
    [self.navigationController pushViewController:mapView animated:YES];
    //[myDelegate StopIndicator];
}

- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error
{
    if([error code] == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have entered an invalid location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)finderReprestativeEmailAction:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"Finder App";
        NSArray *toRecipents = [NSArray arrayWithObject:[[conferenceDetailArray objectAtIndex:0]representativeEmail]];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setToRecipients:toRecipents];
        [self presentViewController: mc animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"Email account is not configured in your device."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}
- (IBAction)mapButtonAction:(id)sender
{
    if(!forwardGeocoder)
    {
        forwardGeocoder = [[MJGeocoder alloc] init];
        forwardGeocoder.delegate = self;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *string=[NSString stringWithFormat:@"%@",conferenceVenue.text];
    [forwardGeocoder findLocationsWithAddress:string title:nil];
}

#pragma mark - end
#pragma mark - MFMailcomposeviewcontroller delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [self.view makeToast:@"Your email was sent."];
            break;
        case MFMailComposeResultFailed:
            [self.view makeToast:@"Your email was not sent."];
            break;
        default:
            [self.view makeToast:@"Your email was not sent."];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

@end
