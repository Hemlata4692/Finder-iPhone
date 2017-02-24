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
#import "WebViewController.h"
#import "MatchesService.h"
#import "MatchesViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MyProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate>
{
    NSMutableArray *userProfileDataArray;
    NSArray *interestsArray, *interestedInArray;
    CGSize size;
    CGRect textRect;
    int count;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myProfileScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDesignationLabel;
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
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberHeading;
@property (weak, nonatomic) IBOutlet UILabel *aboutcompanyHeading;
@property (weak, nonatomic) IBOutlet UICollectionView *interestAreaCollectionView;
@end

@implementation MyProfileViewController
@synthesize myProfileScrollView;
@synthesize mainContainerView;
@synthesize profileBackground;
@synthesize userProfileImage;
@synthesize userNameLabel;
@synthesize userDesignationLabel;
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
@synthesize aboutcompanyHeading;
@synthesize mobileNumberHeading;
@synthesize otherUserID;
@synthesize myProfileData;
@synthesize viewType;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addShadow];
    userProfileDataArray=[[NSMutableArray alloc]init];
    interestsArray=[[NSArray alloc]init];
    interestedInArray=[[NSArray alloc]init];
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
        [myDelegate showIndicator];
        [self performSelector:@selector(getOtherUserProfile) withObject:nil afterDelay:.1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [UserDefaultManager setValue:nil key:@"firstTimeUser"];
    if ([viewName isEqualToString:@"My Profile"]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getUserProfile) withObject:nil afterDelay:.1];
    }
    if ([viewType isEqualToString:@"pop"]) {
        [self addLeftBarButtonWithImage1:[UIImage imageNamed:@"back"]];
    }
}

//Add view shadow
- (void)addShadow {
    [userProfileImage setCornerRadius:userProfileImage.frame.size.width/2];
    [userProfileImage setViewBorder:userProfileImage color:[UIColor whiteColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [professionView addShadow:professionView color:[UIColor lightGrayColor]];
    [interestedInView addShadow:interestedInView color:[UIColor lightGrayColor]];
}
- (void)dealloc {
    interestsArray=nil;
}
#pragma mark - end

#pragma mark - Add back button
- (void)addLeftBarButtonWithImage1:(UIImage *)backButton{
    CGRect framing = CGRectMake(0, 0, backButton.size.width, backButton.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:framing];
    [button setBackgroundImage:backButton forState:UIControlStateNormal];
    UIBarButtonItem*  barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
    
}
//back button action
- (void)backAction :(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[MatchesViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
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
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    loadWebPage.linkedInLink=[[userProfileDataArray objectAtIndex:0]userLinkedInLink];
    loadWebPage.navigationTitle=@"LinkedIn";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}

- (IBAction)otherUserLinkedInButtonAction:(id)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *loadWebPage =[storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    loadWebPage.linkedInLink=[[userProfileDataArray objectAtIndex:0]userLinkedInLink];
    loadWebPage.navigationTitle=@"LinkedIn";
    [self.navigationController pushViewController:loadWebPage animated:YES];
}

- (IBAction)otherUserEmailButtonAction:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"Finder App";
        NSArray *toRecipents = [NSArray arrayWithObject:[[userProfileDataArray objectAtIndex:0]userEmail]];
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

- (IBAction)addUserContactButtonAction:(id)sender {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                if ([[[userProfileDataArray objectAtIndex:0]vCard] isEqualToString:@""]) {
                    [self addContactToAddressBook];
                }
                else {
                    [self addVcfFile];
                }
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        if ([[[userProfileDataArray objectAtIndex:0]vCard] isEqualToString:@""]) {
            [self addContactToAddressBook];
        }
        else {
            [self addVcfFile];
        }
    }
    else {
        [self.view makeToast:@"Contact cannot be added access denied previously."];
    }
}

- (void)addVcfFile {
    //from vcf file
    CFErrorRef error = NULL;
    NSURL *vCardURL= [NSURL URLWithString:[[userProfileDataArray objectAtIndex:0]vCard]];
    CFDataRef vCardData = (__bridge CFDataRef)[NSData dataWithContentsOfURL:vCardURL];
    ABAddressBookRef book = ABAddressBookCreate();
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    ABRecordRef person = NULL;
    for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
        person = CFArrayGetValueAtIndex(vCardPeople, index);
        ABAddressBookAddRecord(book, person, &error);
    }
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( book );
    CFIndex nPeople = ABAddressBookGetPersonCount( book );
    NSString *aNSString;
    NSString *userName;
    for ( int i = 0; i < nPeople; i++ ) {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        aNSString = (__bridge NSString *)firstName;
        
        CFStringRef appUserName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        userName = (__bridge NSString *)appUserName;
    }
    if ([aNSString isEqualToString:userName]) {
        [self.view makeToast:@"The contact already exists!"];
    }
    else {
        ABAddressBookSave(book, &error);
        CFRelease(vCardPeople);
        CFRelease(defaultSource);
        CFRelease(book);
        [self.view makeToast:@"Contact added successfully."];
    }
    if (error != NULL) {
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        CFRelease(errorDesc);
    }
}

- (void)addContactToAddressBook {
    CFErrorRef error = NULL;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    NSData *dataRef = UIImagePNGRepresentation(userProfileImage.image);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)([[userProfileDataArray objectAtIndex:0]userName]), &error);
    ABMutableMultiValueRef multiPhone =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(mobileNumberLabel.text), kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef) ([[userProfileDataArray objectAtIndex:0]userEmail]), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, emailMultiValue, nil);
    CFRelease(emailMultiValue);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(companyNameLabel.text), &error);
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    addressDictionary[(NSString *) kABPersonAddressStreetKey] = comapnyAddressLabel.text;
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef) addressDictionary, kABWorkLabel,NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress, &error);
    CFRelease(multiAddress);
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( iPhoneAddressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( iPhoneAddressBook );
    NSString *aNSString;
    NSString *userName;
    for ( int i = 0; i < nPeople; i++ ) {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        aNSString = (__bridge NSString *)firstName;
        
        CFStringRef appUserName = ABRecordCopyValue(newPerson, kABPersonFirstNameProperty);
        userName = (__bridge NSString *)appUserName;
    }
    if ([aNSString isEqualToString:userName]) {
        [self.view makeToast:@"The contact already exists!"];
    }
    else {
        ABAddressBookSave(iPhoneAddressBook, &error);
        [self.view makeToast:@"Contact added successfully."];
        CFRelease(newPerson);
        CFRelease(iPhoneAddressBook);
    }
    if (error != NULL)
    {
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        CFRelease(errorDesc);
    }
}
#pragma mark - end

#pragma mark - Webservices
- (void)getUserProfile {
    [[ProfileService sharedManager] getUserProfile:^(id profileDataArray) {
        [myDelegate stopIndicator];
        userProfileDataArray=[profileDataArray mutableCopy];
        [self displayUserProfileData];
    }
                                           failure:^(NSError *error)
     {
     }] ;
}

- (void)getOtherUserProfile {
    [[ProfileService sharedManager] getOtherUserProfile:otherUserID success:^(id profileDataArray) {
        [myDelegate stopIndicator];
        if ([viewType isEqualToString:@"Matches"]) {
            [self updateReviewStatus];
        }
        userProfileDataArray=[profileDataArray mutableCopy];
        [self displayUserProfileData];
    }
                                                failure:^(NSError *error)
     {
     }] ;
}

- (void)updateReviewStatus {
    [[MatchesService sharedManager] updateReviewStatus:otherUserID reviewStatus:@"T" success:^(id responseObject) {
        [myDelegate stopIndicator];
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
    userNameLabel.text=[NSString stringWithFormat:@"%@ %@",[[userProfileDataArray objectAtIndex:0]userName],[[userProfileDataArray objectAtIndex:0]userSurname]];
   [UserDefaultManager setValue:[[userProfileDataArray objectAtIndex:0]userEmail] key:@"userEmail"];
    if ([[[userProfileDataArray objectAtIndex:0]userDesignation] isEqualToString:@""]) {
        userDesignationLabel.text=@"NA";
    }
    else {
        userDesignationLabel.text=[[userProfileDataArray objectAtIndex:0]userDesignation];
    }
    if ([[[userProfileDataArray objectAtIndex:0]userLinkedInLink] isEqualToString:@""]) {
        linkedInButton.hidden=YES;
    }
    else {
        linkedInButton.hidden=NO;
    }
    if ([[[userProfileDataArray objectAtIndex:0]userMobileNumber] isEqualToString:@""]) {
        mobileNumberLabel.text=@"NA";
    }
    else {
        mobileNumberLabel.text=[[userProfileDataArray objectAtIndex:0]userMobileNumber];
    }
    if ([[[userProfileDataArray objectAtIndex:0]userCompanyName] isEqualToString:@""]) {
        companyNameLabel.text=@"NA";
    }
    else {
        companyNameLabel.text=[[userProfileDataArray objectAtIndex:0]userCompanyName];
    }
    NSString *aboutComapny;
    if ([[[userProfileDataArray objectAtIndex:0]aboutUserCompany] isEqualToString:@""]) {
        aboutComapny=@"NA";
    }
    else {
        aboutComapny=[[userProfileDataArray objectAtIndex:0]aboutUserCompany];
    }
    size = CGSizeMake(mainContainerView.frame.size.width-16,999);
    textRect=[self setDynamicHeight:size textString:aboutComapny fontSize:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    companyDescriptionLabel.numberOfLines = 0;
    aboutCompanyView.frame=CGRectMake(8, aboutcompanyHeading.frame.origin.y+aboutcompanyHeading.frame.size.height+5, mainContainerView.frame.size.width-16, textRect.size.height+10);
    companyDescriptionLabel.frame = CGRectMake(8, 3, aboutCompanyView.frame.size.width-10, textRect.size.height);
    companyDescriptionLabel.text=aboutComapny;
    [companyDescriptionLabel setLabelBorder:companyDescriptionLabel color:[UIColor whiteColor]];
    NSString *companyAddress;
    if ([[[userProfileDataArray objectAtIndex:0]userComapnyAddress] isEqualToString:@""]) {
        companyAddress=@"NA";
    }
    else {
        companyAddress=[[userProfileDataArray objectAtIndex:0]userComapnyAddress];
    }
    size = CGSizeMake(mainContainerView.frame.size.width-16,300);
    textRect=[self setDynamicHeight:size textString:companyAddress fontSize:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    comapnyAddressLabel.numberOfLines = 0;
    companyAddressView.frame=CGRectMake(8, aboutCompanyView.frame.origin.y+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+8, mainContainerView.frame.size.width-16, textRect.size.height+10);
    comapnyAddressLabel.frame = CGRectMake(8, 3, companyAddressView.frame.size.width-10, textRect.size.height);
    [comapnyAddressLabel setLabelBorder:comapnyAddressLabel color:[UIColor whiteColor]];
    comapnyAddressLabel.text=companyAddress;
    if ([[[userProfileDataArray objectAtIndex:0]userProfession] isEqualToString:@""]) {
        professionLabel.text=@"NA";
    }
    else {
        professionLabel.text=[[userProfileDataArray objectAtIndex:0]userProfession];
    }
    interestedInArray=[[[userProfileDataArray objectAtIndex:0]userInterestedIn] componentsSeparatedByString:@","];
    if ([[[userProfileDataArray objectAtIndex:0]userInterestedIn] isEqualToString:@""]) {
        interestedInLabel.text=@"NA";
    }
    else {
        interestedInLabel.text=[[userProfileDataArray objectAtIndex:0]userInterestedIn];
    }
    interestsArray =[[[userProfileDataArray objectAtIndex:0]userInterests] componentsSeparatedByString:@","];
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
    bottomView.frame=CGRectMake(8, profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutcompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+25, mainContainerView.frame.size.width-16,bottomHeight);
    
    float dynamicHeight=profileBackground.frame.origin.y+profileBackground.frame.size.height+15+mobileNumberHeading.frame.size.height+5+mobileNumberView.frame.size.height+8+aboutcompanyHeading.frame.size.height+5+aboutCompanyView.frame.size.height+8+addressHeadingLabel.frame.size.height+5+companyAddressView.frame.size.height+8+bottomView.frame.size.height+20;
    mainContainerView.frame = CGRectMake(mainContainerView.frame.origin.x, mainContainerView.frame.origin.y, mainContainerView.frame.size.width, dynamicHeight);
    myProfileScrollView.contentSize = CGSizeMake(0,mainContainerView.frame.size.height+64);
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *interestCell = [collectionView1
                                          dequeueReusableCellWithReuseIdentifier:@"interestCell"
                                          forIndexPath:indexPath];
    UILabel *interestLabel=(UILabel *)[interestCell viewWithTag:1];
    UILabel *noInterestLabel=(UILabel *)[interestCell viewWithTag:3];
    UIImageView *tickImage=(UIImageView *)[interestCell viewWithTag:2];
    if ([[interestsArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
        noInterestLabel.hidden=NO;
        noInterestLabel.text=@"NA";
        tickImage.hidden=YES;
        interestLabel.hidden=YES;
    }
    else {
        interestLabel.hidden=NO;
        interestLabel.text=[interestsArray objectAtIndex:indexPath.row];
        tickImage.hidden=NO;
        noInterestLabel.hidden=YES;
    }
    return interestCell;
}
#pragma mark - end

#pragma mark - MFMailcomposeviewcontroller delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
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
