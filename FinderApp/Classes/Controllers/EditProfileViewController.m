//
//  EditProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *editProfileScrollView;
@property (weak, nonatomic) IBOutlet UIView *editProfileContainerview;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextfield;
@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UIView *companyNameView;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UIView *designationView;
@property (weak, nonatomic) IBOutlet UITextField *designationTextField;
@property (weak, nonatomic) IBOutlet UIView *linkedInView;
@property (weak, nonatomic) IBOutlet UITextField *linkedInTextField;
@property (weak, nonatomic) IBOutlet UIView *aboutCompanyView;
@property (weak, nonatomic) IBOutlet UITextView *aboutCompanyTextView;
@property (weak, nonatomic) IBOutlet UIView *companyAddressView;
@property (weak, nonatomic) IBOutlet UITextField *companyAddressTextField;
@property (weak, nonatomic) IBOutlet UILabel *conferenceNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *professionView;
@property (weak, nonatomic) IBOutlet UITextField *professionTextField;
@property (weak, nonatomic) IBOutlet UIView *interestedInView;
@property (weak, nonatomic) IBOutlet UITextField *interestedInTextField;
@property (weak, nonatomic) IBOutlet UIView *interestedAreaView;
@property (weak, nonatomic) IBOutlet UITextField *interestedAreaTextField;

@end

@implementation EditProfileViewController
@synthesize editProfileScrollView;
@synthesize editProfileContainerview;
@synthesize userInfoView;
@synthesize userImageView;
@synthesize userNameView;
@synthesize emailView;
@synthesize userNameTextField;
@synthesize userEmailTextfield;
@synthesize mobileNumberView;
@synthesize mobileNumberTextField;
@synthesize companyNameView;
@synthesize companyNameTextField;
@synthesize designationView;
@synthesize designationTextField;
@synthesize linkedInView;
@synthesize linkedInTextField;
@synthesize aboutCompanyView;
@synthesize aboutCompanyTextView;
@synthesize companyAddressView;
@synthesize companyAddressTextField;
@synthesize conferenceNameLabel;
@synthesize bottomView;
@synthesize professionView;
@synthesize professionTextField;
@synthesize interestedInView;
@synthesize interestedInTextField;
@synthesize interestedAreaView;
@synthesize interestedAreaTextField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Edit Profile";
    [self addShadow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addShadow
{
    [userImageView setViewBorder:userImageView color:[UIColor whiteColor]];
    [userImageView addShadowWithCornerRadius:userImageView color:[UIColor redColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [professionView addShadow:professionView color:[UIColor lightGrayColor]];
    [interestedInView addShadow:interestedInView color:[UIColor lightGrayColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [designationView addShadow:designationView color:[UIColor lightGrayColor]];
    [companyNameView addShadow:companyNameView color:[UIColor lightGrayColor]];
    [linkedInView addShadow:linkedInView color:[UIColor lightGrayColor]];
    [interestedAreaView addShadow:interestedAreaView color:[UIColor lightGrayColor]];
    [userInfoView addShadow:userInfoView color:[UIColor lightGrayColor]];
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)professionPickerAction:(id)sender {
}
- (IBAction)interestedInPickerAction:(id)sender {
}
- (IBAction)interestedAreaPickerAction:(id)sender {
}
#pragma mark - end
#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //    [self.keyboardControls setActiveField:textField];
    //    if (textField==emailField) {
    //        if([[UIScreen mainScreen] bounds].size.height<568)  {
    //            [loginScrollView setContentOffset:CGPointMake(0, 45) animated:YES];
    //        }
    //    }
    //    else if (textField==passwordField) {
    //        if([[UIScreen mainScreen] bounds].size.height<568){
    //            [loginScrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    //        }
    //        else  if([[UIScreen mainScreen] bounds].size.height==568){
    //            [loginScrollView setContentOffset:CGPointMake(0, 75) animated:YES];
    //        }
    //    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //  [loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end
@end
