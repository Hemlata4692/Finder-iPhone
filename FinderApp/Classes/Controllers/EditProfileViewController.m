//
//  EditProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileService.h"

@interface EditProfileViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFieldArray;
}
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
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
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
    //Adding textfield to array
    textFieldArray = @[userNameTextField,userEmailTextfield,mobileNumberTextField,companyNameTextField,designationTextField,linkedInTextField,aboutCompanyTextView,companyAddressTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [self addShadow];
    [myDelegate showIndicator];
    [self performSelector:@selector(getInterestListing) withObject:nil afterDelay:.1];
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
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction{
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls{
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField==mobileNumberTextField) {
        if([[UIScreen mainScreen] bounds].size.height<568)  {
            [editProfileScrollView setContentOffset:CGPointMake(0, 45) animated:YES];
        }
    }
    else if (textField==companyNameTextField) {
        if([[UIScreen mainScreen] bounds].size.height<=568){
            [editProfileScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        }
    }
    else if (textField==companyNameTextField) {
        if([[UIScreen mainScreen] bounds].size.height<=568){
            [editProfileScrollView setContentOffset:CGPointMake(0, 135) animated:YES];
        }
    }
    else if (textField==designationTextField) {
        if([[UIScreen mainScreen] bounds].size.height<=568){
            [editProfileScrollView setContentOffset:CGPointMake(0, 180) animated:YES];
        }
    }
    else if (textField==linkedInTextField) {
       if([[UIScreen mainScreen] bounds].size.height<=568){
            [editProfileScrollView setContentOffset:CGPointMake(0, 225) animated:YES];
       }
       else{
           [editProfileScrollView setContentOffset:CGPointMake(0, 45) animated:YES];
       }
    }
    else if (textField==companyAddressTextField) {
        if([[UIScreen mainScreen] bounds].size.height<=568){
            [editProfileScrollView setContentOffset:CGPointMake(0, 370) animated:YES];
      }
        else {
            [editProfileScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end
#pragma mark - Textview delegates
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
    if (textView==aboutCompanyTextView) {
        if([[UIScreen mainScreen] bounds].size.height<=568){
             [editProfileScrollView setContentOffset:CGPointMake(0, 315) animated:YES];
        }
        else {
            [editProfileScrollView setContentOffset:CGPointMake(0, 135) animated:YES];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end

#pragma mark - Webservice
-(void)getInterestListing{
    [[ProfileService sharedManager] getInterestList:^(id responseObject) {
        [myDelegate stopIndicator];
        
    }
                                            failure:^(NSError *error)
     {
         
     }] ;
    
}

@end
