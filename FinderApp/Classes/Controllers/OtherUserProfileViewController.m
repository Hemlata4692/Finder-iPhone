//
//  OtherUserProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "OtherUserProfileViewController.h"
#import "WebViewController.h"

@interface OtherUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *otherUserProfileScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIImageView *otherUserProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *otherUserNameLabel;
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
@end

@implementation OtherUserProfileViewController
@synthesize otherUserProfileScrollView;
@synthesize mainContainerView;
@synthesize profileBackground;
@synthesize otherUserProfileImage;
@synthesize otherUserNameLabel;
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

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.navigationItem.title=@"User Profile";
    [self addShadow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addShadow
{
    [otherUserProfileImage setCornerRadius:otherUserProfileImage.frame.size.width/2];
    [otherUserProfileImage setViewBorder:otherUserProfileImage color:[UIColor whiteColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [professionView addShadow:professionView color:[UIColor lightGrayColor]];
    [interestedInView addShadow:interestedInView color:[UIColor lightGrayColor]];
}


#pragma mark - end

#pragma mark - IBActions
- (IBAction)sendRequestButtonAction:(id)sender {
    
}

- (IBAction)acceptrequestButtonAction:(id)sender {
}

- (IBAction)cancelRequestButtonAction:(id)sender {
}
#pragma mark - end
@end
