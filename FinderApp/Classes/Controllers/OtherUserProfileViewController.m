//
//  OtherUserProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "OtherUserProfileViewController.h"
#import "WebViewController.h"
#import "ProfileService.h"
#import "ProfileDataModel.h"
#import "MatchesService.h"
#import "MyProfileViewController.h"

@interface OtherUserProfileViewController ()
{
    NSMutableArray *otherUserProfileDataArray;
    NSArray *interestsArray;
    CGSize size;
    CGRect textRect;
    int count;
}
@property (weak, nonatomic) IBOutlet UIScrollView *otherUserProfileScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIImageView *otherUserProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *otherUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherUserDesignation;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *aboutCompanyView;
@property (weak, nonatomic) IBOutlet UILabel *companyDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressHeadingLabel;
@property (weak, nonatomic) IBOutlet UIView *companyAddressView;
@property (weak, nonatomic) IBOutlet UILabel *comapnyAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *professionView;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UIView *interestedInView;
@property (weak, nonatomic) IBOutlet UILabel *interestedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelRequestButton;
@property (weak, nonatomic) IBOutlet UICollectionView *interestAreaCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *aboutCompanyHeading;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberHeading;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (nonatomic,retain) NSString * acceptRequest;
@end

@implementation OtherUserProfileViewController
@synthesize otherUserProfileScrollView;
@synthesize mainContainerView;
@synthesize profileBackground;
@synthesize otherUserProfileImage;
@synthesize otherUserNameLabel;
@synthesize otherUserDesignation;
@synthesize companyNameLabel;
@synthesize mobileNumberView;
@synthesize mobileNumberLabel;
@synthesize aboutCompanyView;
@synthesize companyDescriptionLabel;
@synthesize addressHeadingLabel;
@synthesize companyAddressView;
@synthesize comapnyAddressLabel;
@synthesize bottomView;
@synthesize professionView;
@synthesize professionLabel;
@synthesize interestedInView;
@synthesize interestedInLabel;
@synthesize interestAreaCollectionView;
@synthesize sendRequestButton;
@synthesize acceptRequestButton;
@synthesize cancelRequestButton;
@synthesize otherUserId;
@synthesize aboutCompanyHeading;
@synthesize mobileNumberHeading;
@synthesize isRequestArrived;
@synthesize isRequestSent;
@synthesize seperatorLabel;
@synthesize acceptRequest;
@synthesize viewType;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"User Profile";
    [self addShadow];
    otherUserProfileDataArray=[[NSMutableArray alloc]init];
    interestsArray=[[NSArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getOtherUserProfile) withObject:nil afterDelay:.1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addShadow {
    [otherUserProfileImage setCornerRadius:otherUserProfileImage.frame.size.width/2];
    [otherUserProfileImage setViewBorder:otherUserProfileImage color:[UIColor whiteColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [professionView addShadow:professionView color:[UIColor lightGrayColor]];
    [interestedInView addShadow:interestedInView color:[UIColor lightGrayColor]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([isRequestArrived isEqualToString:@"T"]) {
        sendRequestButton.hidden=YES;
        acceptRequestButton.hidden=NO;
        cancelRequestButton.hidden=NO;
        seperatorLabel.hidden=NO;
    }
    else if ([isRequestSent isEqualToString:@"T"]) {
        sendRequestButton.hidden=NO;
        [sendRequestButton setTitle:@"Cancel Request" forState:UIControlStateNormal];
        isRequestSent=@"F";
        acceptRequestButton.hidden=YES;
        cancelRequestButton.hidden=YES;
        seperatorLabel.hidden=YES;
    }
    else {
        isRequestSent=@"T";
        sendRequestButton.hidden=NO;
        acceptRequestButton.hidden=YES;
        cancelRequestButton.hidden=YES;
        seperatorLabel.hidden=YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)sendRequestButtonAction:(id)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(sendCancelMatchesRequest) withObject:nil afterDelay:.1];
}
- (IBAction)acceptrequestButtonAction:(id)sender {
    
    acceptRequest=@"T";
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
}
- (IBAction)cancelRequestButtonAction:(id)sender {
    acceptRequest=@"F";
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getOtherUserProfile {
    
    [[ProfileService sharedManager] getOtherUserProfile:otherUserId success:^(id profileDataArray) {
        [myDelegate stopIndicator];
        if ([viewType isEqualToString:@"Matches"]) {
            [self updateReviewStatus];
        }
        otherUserProfileDataArray=[profileDataArray mutableCopy];
        [self displayUserProfileData];
    }
                                                failure:^(NSError *error)
     {
     }] ;
}
- (void)updateReviewStatus {
    [[MatchesService sharedManager] updateReviewStatus:otherUserId reviewStatus:@"T" success:^(id responseObject) {
        [myDelegate stopIndicator];
    }
                                               failure:^(NSError *error)
     {
     }] ;
}
//send/cancel match request
- (void)sendCancelMatchesRequest {
    [[MatchesService sharedManager] sendCancelMatchRequest:otherUserId sendRequest:isRequestSent success:^(id responseObject) {
        [myDelegate stopIndicator];
        if ([isRequestSent isEqualToString:@"T"]) {
            [sendRequestButton setTitle:@"Request Sent" forState:UIControlStateNormal];
            
        }
        else{
            [sendRequestButton setTitle:@"Send Request" forState:UIControlStateNormal];
            isRequestSent=@"T";
        }
    }
                                                   failure:^(NSError *error)
     {
     }] ;
}
- (void)acceptDeclineRequest {
    
    [[MatchesService sharedManager] acceptDeclineRequest:otherUserId acceptRequest:acceptRequest success:^(id responseObject) {
        [myDelegate stopIndicator];
        if ([acceptRequest isEqualToString:@"T"]) {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            profileView.viewName=@"User Profile";
            profileView.viewType=@"pop";
            profileView.otherUserID=otherUserId;
            [self.navigationController pushViewController:profileView animated:NO];
        }
        else {
            acceptRequestButton.hidden=YES;
            cancelRequestButton.hidden=YES;
            seperatorLabel.hidden=YES;
            sendRequestButton.hidden=NO;
            [sendRequestButton setTitle:@"Send Request" forState:UIControlStateNormal];
            isRequestSent=@"T";
        }
    }
                                                 failure:^(NSError *error)
     {
     }] ;
}
- (void)displayUserProfileData {
    
    companyDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    aboutCompanyView.translatesAutoresizingMaskIntoConstraints = YES;
    mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
    companyAddressView.translatesAutoresizingMaskIntoConstraints=YES;
    comapnyAddressLabel.translatesAutoresizingMaskIntoConstraints=YES;
    interestAreaCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    bottomView.translatesAutoresizingMaskIntoConstraints=YES;
    __weak UIImageView *weakRef = otherUserProfileImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[otherUserProfileDataArray objectAtIndex:0]userImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [otherUserProfileImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    otherUserNameLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userName];
    if ([[[otherUserProfileDataArray objectAtIndex:0]userDesignation] isEqualToString:@""]) {
        otherUserDesignation.text=@"NA";
    }
    else {
        otherUserDesignation.text=[[otherUserProfileDataArray objectAtIndex:0]userDesignation];
    }
    if ([[[otherUserProfileDataArray objectAtIndex:0]userMobileNumber] isEqualToString:@""]) {
        mobileNumberLabel.text=@"NA";
    }
    else {
        mobileNumberLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userMobileNumber];
    }
    if ([[[otherUserProfileDataArray objectAtIndex:0]userCompanyName] isEqualToString:@""]) {
        companyNameLabel.text=@"NA";
    }
    else {
        companyNameLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userCompanyName];
    }
    NSString *aboutComapny;
    if ([[[otherUserProfileDataArray objectAtIndex:0]aboutUserCompany] isEqualToString:@""]) {
        aboutComapny=@"NA";
    }
    else {
        aboutComapny=[[otherUserProfileDataArray objectAtIndex:0]aboutUserCompany];
    }
    if ([viewType isEqualToString:@"Matches"]) {
        mobileNumberHeading.translatesAutoresizingMaskIntoConstraints = YES;
        mobileNumberView.translatesAutoresizingMaskIntoConstraints = YES;
        aboutCompanyHeading.translatesAutoresizingMaskIntoConstraints = YES;
        mobileNumberHeading.frame=CGRectMake(8, profileBackground.frame.origin.y+profileBackground.frame.size.height+5, mainContainerView.frame.size.width-16,0);
        mobileNumberView.frame=CGRectMake(8, mobileNumberHeading.frame.origin.y+mobileNumberHeading.frame.size.height+5, mainContainerView.frame.size.width-16,0);
        aboutCompanyHeading.frame=CGRectMake(15, mobileNumberView.frame.origin.y+mobileNumberView.frame.size.height+5, mainContainerView.frame.size.width-16, 21);
        size = CGSizeMake(mainContainerView.frame.size.width-16,999);
        textRect=[self setDynamicHeight:size textString:aboutComapny fontSize:[UIFont fontWithName:@"Roboto-Regular" size:15]];
        companyDescriptionLabel.numberOfLines = 0;
        aboutCompanyView.frame=CGRectMake(8, aboutCompanyHeading.frame.origin.y+aboutCompanyHeading.frame.size.height+5, mainContainerView.frame.size.width-16, textRect.size.height+10);
        companyDescriptionLabel.frame = CGRectMake(8, 3, aboutCompanyView.frame.size.width-10, textRect.size.height);
        companyDescriptionLabel.text=aboutComapny;
        [companyDescriptionLabel setLabelBorder:companyDescriptionLabel color:[UIColor whiteColor]];
        NSString *companyAddress;
        if ([[[otherUserProfileDataArray objectAtIndex:0]userComapnyAddress] isEqualToString:@""]) {
            companyAddress=@"NA";
        }
        else {
            companyAddress=[[otherUserProfileDataArray objectAtIndex:0]userComapnyAddress];
        }
        size = CGSizeMake(mainContainerView.frame.size.width-16,300);
        textRect=[self setDynamicHeight:size textString:companyAddress fontSize:[UIFont fontWithName:@"Roboto-Regular" size:14]];
        comapnyAddressLabel.numberOfLines = 0;
        companyAddressView.frame=CGRectMake(8, aboutCompanyView.frame.origin.y+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+8, mainContainerView.frame.size.width-16, textRect.size.height+10);
        comapnyAddressLabel.frame = CGRectMake(8, 3, companyAddressView.frame.size.width-10, textRect.size.height);
        [comapnyAddressLabel setLabelBorder:comapnyAddressLabel color:[UIColor whiteColor]];
        comapnyAddressLabel.text=companyAddress;
        
        if ([[[otherUserProfileDataArray objectAtIndex:0]userProfession] isEqualToString:@""]) {
            professionLabel.text=@"NA";
        }
        else {
            professionLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userProfession];
        }
        if ([[[otherUserProfileDataArray objectAtIndex:0]userInterestedIn] isEqualToString:@""]) {
            interestedInLabel.text=@"NA";
        }
        else {
            interestedInLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userInterestedIn];
        }
        interestsArray=[[[otherUserProfileDataArray objectAtIndex:0]userInterests] componentsSeparatedByString:@","];
        count=(int)interestsArray.count;
        if ((interestsArray.count%2)!=0) {
            count=count*42;
            interestAreaCollectionView.frame=CGRectMake(4, interestAreaCollectionView.frame.origin.y, bottomView.frame.size.width-8, count);
        }
        else {
            count=(count-1)*42;
            interestAreaCollectionView.frame=CGRectMake(4, interestAreaCollectionView.frame.origin.y, bottomView.frame.size.width-8, count);
        }
        [interestAreaCollectionView reloadData];
        float bottomHeight=professionView.frame.origin.y+professionView.frame.size.height+2+interestedInView.frame.size.height+22+count+30;
        bottomView.frame=CGRectMake(8, profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutCompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+5, mainContainerView.frame.size.width-16,bottomHeight);
        float dynamicHeight=profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutCompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+8+bottomView.frame.size.height+20;
        mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
        otherUserProfileScrollView.contentSize = CGSizeMake(0,mainContainerView.frame.size.height+64);
    }
    else
    {
        size = CGSizeMake(mainContainerView.frame.size.width-16,999);
        textRect=[self setDynamicHeight:size textString:aboutComapny fontSize:[UIFont fontWithName:@"Roboto-Regular" size:15]];
        companyDescriptionLabel.numberOfLines = 0;
        aboutCompanyView.frame=CGRectMake(8, aboutCompanyHeading.frame.origin.y+aboutCompanyHeading.frame.size.height+5, mainContainerView.frame.size.width-16, textRect.size.height+10);
        companyDescriptionLabel.frame = CGRectMake(8, 3, aboutCompanyView.frame.size.width-10, textRect.size.height);
        companyDescriptionLabel.text=aboutComapny;
        [companyDescriptionLabel setLabelBorder:companyDescriptionLabel color:[UIColor whiteColor]];
        
        NSString *companyAddress;
        if ([[[otherUserProfileDataArray objectAtIndex:0]userComapnyAddress] isEqualToString:@""]) {
            companyAddress=@"NA";
        }
        else {
            companyAddress=[[otherUserProfileDataArray objectAtIndex:0]userComapnyAddress];
        }
        size = CGSizeMake(mainContainerView.frame.size.width-16,300);
        textRect=[self setDynamicHeight:size textString:companyAddress fontSize:[UIFont fontWithName:@"Roboto-Regular" size:15]];
        comapnyAddressLabel.numberOfLines = 0;
        companyAddressView.frame=CGRectMake(8, aboutCompanyView.frame.origin.y+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+8, mainContainerView.frame.size.width-16, textRect.size.height+10);
        comapnyAddressLabel.frame = CGRectMake(8, 3, companyAddressView.frame.size.width-10, textRect.size.height);
        [comapnyAddressLabel setLabelBorder:comapnyAddressLabel color:[UIColor whiteColor]];
        comapnyAddressLabel.text=companyAddress;
        
        if ([[[otherUserProfileDataArray objectAtIndex:0]userProfession] isEqualToString:@""]) {
            professionLabel.text=@"NA";
        }
        else {
            professionLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userProfession];
        }
        if ([[[otherUserProfileDataArray objectAtIndex:0]userInterestedIn] isEqualToString:@""]) {
            interestedInLabel.text=@"NA";
        }
        else {
            interestedInLabel.text=[[otherUserProfileDataArray objectAtIndex:0]userInterestedIn];
        }
        interestsArray=[[[otherUserProfileDataArray objectAtIndex:0]userInterests] componentsSeparatedByString:@","];
        count=(int)interestsArray.count;
        
        if ((interestsArray.count%2)!=0) {
            count=count*42;
            interestAreaCollectionView.frame=CGRectMake(4, interestAreaCollectionView.frame.origin.y, bottomView.frame.size.width-8, count);
        }
        else{
            count=(count-1)*42;
            interestAreaCollectionView.frame=CGRectMake(4, interestAreaCollectionView.frame.origin.y, bottomView.frame.size.width-8, count);
        }
        [interestAreaCollectionView reloadData];
        float bottomHeight=professionView.frame.origin.y+professionView.frame.size.height+2+interestedInView.frame.size.height+22+count+30;
        bottomView.frame=CGRectMake(8, profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutCompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+25, mainContainerView.frame.size.width-16,bottomHeight);
        
        float dynamicHeight=profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutCompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+8+bottomView.frame.size.height+20;
        mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
        otherUserProfileScrollView.contentSize = CGSizeMake(0,mainContainerView.frame.size.height+64);
    }
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

#pragma mark - Collection view delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return interestsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *interestCell = [collectionView1
                                          dequeueReusableCellWithReuseIdentifier:@"interestCell"
                                          forIndexPath:indexPath];
    UILabel *interestLabel=(UILabel *)[interestCell viewWithTag:1];
    UIImageView *tickImage=(UIImageView *)[interestCell viewWithTag:2];
    if ([[interestsArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
        interestLabel.text=@"NA";
        tickImage.hidden=YES;
    }
    else {
        interestLabel.text=[interestsArray objectAtIndex:indexPath.row];
        tickImage.hidden=NO;
    }
    
    return interestCell;
}
#pragma mark - end

@end
