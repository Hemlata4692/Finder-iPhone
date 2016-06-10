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


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addShadow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addShadow
{
    [self.userImageView setCornerRadius:self.userImageView.frame.size.width/2];
    [self.userImageView setViewBorder:self.userImageView color:[UIColor whiteColor]];
    [self.aboutCompanyView addShadow:self.aboutCompanyView color:[UIColor lightGrayColor]];
    [self.companyAddressView addShadow:self.companyAddressView color:[UIColor lightGrayColor]];
    [self.bottomView addShadow:self.bottomView color:[UIColor lightGrayColor]];
    [self.professionView addShadow:self.professionView color:[UIColor lightGrayColor]];
    [self.interestedInView addShadow:self.interestedInView color:[UIColor lightGrayColor]];
    [self.mobileNumberView addShadow:self.mobileNumberView color:[UIColor lightGrayColor]];
    [self.designationView addShadow:self.designationView color:[UIColor lightGrayColor]];
    [self.companyNameView addShadow:self.companyNameView color:[UIColor lightGrayColor]];
    [self.linkedInView addShadow:self.linkedInView color:[UIColor lightGrayColor]];
    [self.interestedAreaView addShadow:self.interestedAreaView color:[UIColor lightGrayColor]];
    [self.userInfoView addShadow:self.userInfoView color:[UIColor lightGrayColor]];
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
