//
//  MyProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 08/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MyProfileViewController.h"
#import "EditProfileViewController.h"
#import "ProfileService.h"
#import "ProfileDataModel.h"

@interface MyProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *userProfileDataArray;
    NSArray *interestsArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myProfileScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *aboutCompanyView;
@property (weak, nonatomic) IBOutlet UILabel *companyDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressHeadingLabel;
@property (weak, nonatomic) IBOutlet UIView *companyAddressView;
@property (weak, nonatomic) IBOutlet UILabel *comapnyAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIView *professionView;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UIView *interestedInView;
@property (weak, nonatomic) IBOutlet UILabel *interestedInLabel;
@property (weak, nonatomic) IBOutlet UIView *otherUserView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UICollectionView *interestAreaCollectionView;
@end

@implementation MyProfileViewController
@synthesize myProfileScrollView;
@synthesize mainContainerView;
@synthesize profileBackground;
@synthesize userProfileImage;
@synthesize userNameLabel;
@synthesize companyNameLabel;
@synthesize mobileNumberView;
@synthesize mobileNumberLabel;
@synthesize aboutCompanyView;
@synthesize companyDescriptionLabel;
@synthesize addressHeadingLabel;
@synthesize companyAddressView;
@synthesize comapnyAddressLabel;
@synthesize bottomView;
@synthesize linkedInButton;
@synthesize professionView;
@synthesize professionLabel;
@synthesize interestedInView;
@synthesize interestedInLabel;
@synthesize interestAreaCollectionView;
@synthesize viewName;
@synthesize otherUserView;
@synthesize editProfileButton;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addShadow];
    userProfileDataArray=[[NSMutableArray alloc]init];
    interestsArray=[[NSArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserProfile) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([viewName isEqualToString:@"My Profile"]) {
        self.navigationItem.title=@"My Profile";
        otherUserView.hidden=YES;
        linkedInButton.hidden=NO;
        editProfileButton.hidden=NO;
    }
    else {
        self.navigationItem.title=@"User Profile";
        otherUserView.hidden=NO;
        linkedInButton.hidden=YES;
        editProfileButton.hidden=YES;
    }
}

-(void)addShadow
{
    [userProfileImage setCornerRadius:userProfileImage.frame.size.width/2];
    [userProfileImage setViewBorder:userProfileImage color:[UIColor whiteColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [professionView addShadow:professionView color:[UIColor lightGrayColor]];
    [interestedInView addShadow:interestedInView color:[UIColor lightGrayColor]];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)editProfileButtonAction:(id)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController *editProfile =[storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    editProfile.profileArray=[userProfileDataArray mutableCopy];
    [self.navigationController pushViewController:editProfile animated:YES];
}

- (IBAction)linkedInButtonAction:(id)sender {
}

- (IBAction)otherUserLinkedInButtonAction:(id)sender {
}

- (IBAction)otherUserEmailButtonAction:(id)sender {
}

- (IBAction)addUserContactButtonAction:(id)sender {
}
#pragma mark - end

#pragma mark - Webservices
-(void)getUserProfile
{
    [[ProfileService sharedManager] getUserProfile:^(id profileDataArray) {
        [myDelegate stopIndicator];
        userProfileDataArray=[profileDataArray mutableCopy];
        [self displayUserProfileData];
    }
                                            failure:^(NSError *error)
     {
         
     }] ;

}
-(void)displayUserProfileData {
    __weak UIImageView *weakRef = userProfileImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[userProfileDataArray objectAtIndex:0]userImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userProfileImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    userNameLabel.text=[NSString stringWithFormat:@"%@ (%@)",[[userProfileDataArray objectAtIndex:0]userName],[[userProfileDataArray objectAtIndex:0]userDesignation]];
    mobileNumberLabel.text=[[userProfileDataArray objectAtIndex:0]userMobileNumber];
    companyNameLabel.text=[[userProfileDataArray objectAtIndex:0]userCompanyName];
    companyDescriptionLabel.text=[[userProfileDataArray objectAtIndex:0]aboutUserCompany];
    comapnyAddressLabel.text=[[userProfileDataArray objectAtIndex:0]userComapnyAddress];
    professionLabel.text=[[userProfileDataArray objectAtIndex:0]userProfession];
    interestedInLabel.text=[[userProfileDataArray objectAtIndex:0]userInterestedIn];
    interestsArray=[[[userProfileDataArray objectAtIndex:0]userInterests] componentsSeparatedByString:@","];
    [interestAreaCollectionView reloadData];
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
    interestLabel.text=[interestsArray objectAtIndex:indexPath.row];
    return interestCell;
}
#pragma mark - end
@end
