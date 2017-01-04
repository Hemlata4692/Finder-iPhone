//
//  EditProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileService.h"
#import "CYCustomMultiSelectPickerView.h"
#import "ProfileDataModel.h"
#import "MyProfileViewController.h"

@interface EditProfileViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,CYCustomMultiSelectPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *textFieldArray;
    CYCustomMultiSelectPickerView *multiPickerView;
    NSMutableArray *interestedAreaArray;
    NSMutableArray *interestedInArray;
    NSMutableArray *professionArray;
    NSArray *selectedPickerArray, *interestedInSelectcedArray;
    NSString* pickerType;
    NSMutableDictionary *interestedAreaDic, *lookingToFindDic;
    BOOL isInterestedInOtherSelected, isInterestedAreaOtherSelected;
    
}
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
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
@property (weak, nonatomic) IBOutlet UIView *interestedInOtherView;
@property (weak, nonatomic) IBOutlet UIView *interestedAreaOtherView;
@property (weak, nonatomic) IBOutlet UITextField *interestedAreaTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *userPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@property (weak, nonatomic) IBOutlet UIButton *professionButton;
@property (weak, nonatomic) IBOutlet UIButton *interestesInButton;
@property (weak, nonatomic) IBOutlet UIButton *interestAreaButton;
@property (weak, nonatomic) IBOutlet UITextField *interestedInOtherTextField;
@property (weak, nonatomic) IBOutlet UITextField *interestedAreaOtherTextField;
@property (weak, nonatomic) IBOutlet UILabel *interestedAreaSeparator;
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
@synthesize userPickerView;
@synthesize pickerToolBar;
@synthesize profileArray;
@synthesize professionButton;
@synthesize interestesInButton;
@synthesize interestAreaButton;
@synthesize lastNameTextField;
@synthesize lastNameView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Edit Profile";
    //Adding textfield to array
    textFieldArray = @[userNameTextField,lastNameTextField,userEmailTextfield,mobileNumberTextField,companyNameTextField,designationTextField,linkedInTextField,aboutCompanyTextView,companyAddressTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [self addShadow];
//    userEmailTextfield.userInteractionEnabled=NO;
//    userEmailTextfield.textColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    interestedAreaArray=[[NSMutableArray alloc]init];
    interestedInArray=[[NSMutableArray alloc]init];
    professionArray=[[NSMutableArray alloc]init];
    selectedPickerArray=[[NSArray alloc]init];
    interestedInSelectcedArray=[[NSArray alloc]init];
    interestedAreaDic=[[NSMutableDictionary alloc]init];
    lookingToFindDic=[[NSMutableDictionary alloc]init];
    userPickerView.translatesAutoresizingMaskIntoConstraints = YES;
    pickerToolBar.translatesAutoresizingMaskIntoConstraints = YES;
    self.interestedInOtherView.translatesAutoresizingMaskIntoConstraints=YES;
    self.interestedAreaOtherView.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomView.translatesAutoresizingMaskIntoConstraints=YES;
    
    isInterestedInOtherSelected=NO;
    isInterestedAreaOtherSelected=NO;
    [self viewCustomization:NO isSecondOtherShow:NO];
    [self displayData];
    [myDelegate showIndicator];
    [self performSelector:@selector(getInterestListing) withObject:nil afterDelay:.1];
}

- (void)viewCustomization:(BOOL)isFirstOtherShow isSecondOtherShow:(BOOL)isSecondOtherShow {
    
    if (!isFirstOtherShow && !isSecondOtherShow) {
        self.interestedInOtherView.frame=CGRectMake(0, 114, [[UIScreen mainScreen] bounds].size.width-10, 0);
        self.interestedInOtherView.hidden=YES;
        _interestedInOtherTextField.hidden=YES;
        _interestedAreaOtherTextField.hidden=YES;
        self.interestedAreaOtherView.frame=CGRectMake(0, 114+55, [[UIScreen mainScreen] bounds].size.width-10, 0);
        self.interestedAreaOtherView.hidden=YES;
        self.bottomView.frame=CGRectMake(5, 590+55, [[UIScreen mainScreen] bounds].size.width-10, (55*3));
        self.interestedAreaSeparator.hidden=YES;
    }
    else if (!isFirstOtherShow && isSecondOtherShow) {
        self.interestedInOtherView.frame=CGRectMake(0, 114, [[UIScreen mainScreen] bounds].size.width-10, 0);
        self.interestedInOtherView.hidden=YES;
        _interestedInOtherTextField.hidden=YES;
        _interestedAreaOtherTextField.hidden=NO;
        self.interestedAreaOtherView.frame=CGRectMake(0, 114+55+5, [[UIScreen mainScreen] bounds].size.width-10, 55);
        self.interestedAreaOtherView.hidden=NO;
        self.bottomView.frame=CGRectMake(5, 590+55, [[UIScreen mainScreen] bounds].size.width-10, (55*4));
        self.interestedAreaSeparator.hidden=NO;
    }
    else if (isFirstOtherShow && !isSecondOtherShow) {
        self.interestedInOtherView.frame=CGRectMake(0, 114, [[UIScreen mainScreen] bounds].size.width-10, 55);
        self.interestedInOtherView.hidden=NO;
        _interestedInOtherTextField.hidden=NO;
        _interestedAreaOtherTextField.hidden=YES;
        self.interestedAreaOtherView.frame=CGRectMake(0, 114+(55*2), [[UIScreen mainScreen] bounds].size.width-10, 0);
        self.interestedAreaOtherView.hidden=YES;
        self.bottomView.frame=CGRectMake(5, 590+55, [[UIScreen mainScreen] bounds].size.width-10, (55*4));
        self.interestedAreaSeparator.hidden=YES;
    }
    else {
        self.interestedInOtherView.frame=CGRectMake(0, 114, [[UIScreen mainScreen] bounds].size.width-10, 55);
        self.interestedInOtherView.hidden=NO;
        _interestedInOtherTextField.hidden=NO;
        _interestedAreaOtherTextField.hidden=NO;
        self.interestedAreaOtherView.frame=CGRectMake(0, 114+(55*2)+5, [[UIScreen mainScreen] bounds].size.width-10,55);
        self.interestedAreaOtherView.hidden=NO;
        self.bottomView.frame=CGRectMake(5, 590+55, [[UIScreen mainScreen] bounds].size.width-10, (55*5));
        self.interestedAreaSeparator.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addShadow {
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.clipsToBounds=YES;
    [userImageView setViewBorder:userImageView color:[UIColor whiteColor]];
    [userImageView addShadowWithCornerRadius:userImageView color:[UIColor clearColor]];
    [aboutCompanyView addShadow:aboutCompanyView color:[UIColor lightGrayColor]];
    [companyAddressView addShadow:companyAddressView color:[UIColor lightGrayColor]];
    [bottomView addShadow:bottomView color:[UIColor lightGrayColor]];
    [mobileNumberView addShadow:mobileNumberView color:[UIColor lightGrayColor]];
    [designationView addShadow:designationView color:[UIColor lightGrayColor]];
    [companyNameView addShadow:companyNameView color:[UIColor lightGrayColor]];
    [linkedInView addShadow:linkedInView color:[UIColor lightGrayColor]];
    [userInfoView addShadow:userInfoView color:[UIColor lightGrayColor]];
    [emailView addShadow:emailView color:[UIColor lightGrayColor]];
}

- (void)displayData {
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[profileArray objectAtIndex:0]userImage]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    userNameTextField.text=[[profileArray objectAtIndex:0]userName];
    lastNameTextField.text=[[profileArray objectAtIndex:0]userSurname];
    userEmailTextfield.text=[[profileArray objectAtIndex:0]userEmail];
    mobileNumberTextField.text=[[profileArray objectAtIndex:0]userMobileNumber];
    companyNameTextField.text=[[profileArray objectAtIndex:0]userCompanyName];
    aboutCompanyTextView.text=[[profileArray objectAtIndex:0]aboutUserCompany];
    companyAddressTextField.text=[[profileArray objectAtIndex:0]userComapnyAddress];
    professionTextField.text=[[profileArray objectAtIndex:0]userProfession];
    interestedInTextField.text=[[profileArray objectAtIndex:0]userInterestedIn];
    interestedAreaTextField.text=[[profileArray objectAtIndex:0]userInterests];
    selectedPickerArray=[[[profileArray objectAtIndex:0]userInterests] componentsSeparatedByString:@","];
    interestedInSelectcedArray=[[[profileArray objectAtIndex:0]userInterestedIn] componentsSeparatedByString:@","];
    designationTextField.text=[[profileArray objectAtIndex:0]userDesignation];
    linkedInTextField.text=[[profileArray objectAtIndex:0]userLinkedInLink];
    conferenceNameLabel.text=[[profileArray objectAtIndex:0]conferenceName];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)professionPickerAction:(id)sender {
    [multiPickerView removeFromSuperview];
    [self.view endEditing:YES];
    [_keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    pickerType=@"1";
    if([[UIScreen mainScreen] bounds].size.height<568){
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+190) animated:YES];
    }
    else if([[UIScreen mainScreen] bounds].size.height==568){
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+70) animated:YES];
    }
    else{
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-100) animated:YES];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [userPickerView setNeedsLayout];
    [userPickerView reloadAllComponents];
    userPickerView.frame = CGRectMake(userPickerView.frame.origin.x, self.view.frame.size.height-(userPickerView.frame.size.height+44), self.view.frame.size.width, userPickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, userPickerView.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}

- (IBAction)interestedInPickerAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    professionButton.hidden=NO;
    [self.view endEditing:YES];
    [self hidePickerWithAnimation];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    if([[UIScreen mainScreen] bounds].size.height<568) {
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+305) animated:YES];
    }
    else if([[UIScreen mainScreen] bounds].size.height==568){
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+110) animated:YES];
    }
    else {
        [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-80) animated:YES];
    }
    pickerType=@"2";
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-265, self.view.frame.size.width, 182)];
    multiPickerView.entriesArray = interestedInArray;
    multiPickerView.entriesSelectedArray =interestedInSelectcedArray;
    for (int k =0; k<interestedInArray.count; k++)
    {
        [lookingToFindDic setObject:[NSNumber numberWithBool:NO] forKey:[[interestedInArray objectAtIndex:k]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    for (int k =0; k<interestedInSelectcedArray.count; k++)
    {
        [lookingToFindDic setObject:[NSNumber numberWithBool:YES] forKey:[[interestedInSelectcedArray objectAtIndex:k]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    myDelegate.multiplePickerDic=[lookingToFindDic mutableCopy];
    multiPickerView.multiPickerDelegate = self;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
}

- (IBAction)interestedAreaPickerAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    [self.view endEditing:YES];
    professionButton.hidden=NO;
    [self hidePickerWithAnimation];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    if (_interestedInOtherView.hidden==NO) {
        if([[UIScreen mainScreen] bounds].size.height<568) {
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+405) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+235) animated:YES];
        }
        else {
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+50) animated:YES];
        }
    }
    else {
        if([[UIScreen mainScreen] bounds].size.height<568) {
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+355) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+175) animated:YES];
        }
        else {
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-10) animated:YES];
        }
    }
    pickerType=@"3";
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-265, self.view.frame.size.width, 182)];
    multiPickerView.entriesArray = interestedAreaArray;
    multiPickerView.entriesSelectedArray =selectedPickerArray;
    for (int k =0; k<interestedAreaArray.count; k++)
    {
        [interestedAreaDic setObject:[NSNumber numberWithBool:NO] forKey:[[interestedAreaArray objectAtIndex:k]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    for (int k =0; k<selectedPickerArray.count; k++)
    {
        [interestedAreaDic setObject:[NSNumber numberWithBool:YES] forKey:[[selectedPickerArray objectAtIndex:k]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    myDelegate.multiplePickerDic=[interestedAreaDic mutableCopy];
    multiPickerView.multiPickerDelegate = self;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
}

- (IBAction)selectImageButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)saveButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [self.view endEditing:YES];
    [self hidePickerWithAnimation];
    [self hidePicker];
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(editUserProfile) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Validation
- (BOOL)performValidations {
    if ([userNameTextField isEmpty] || [mobileNumberTextField isEmpty] || [lastNameTextField isEmpty] || [userEmailTextfield isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all mandatory fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else if ((_interestedAreaOtherTextField.hidden==NO && [_interestedAreaOtherTextField isEmpty]) || (_interestedInOtherTextField.hidden==NO && [_interestedInOtherTextField isEmpty]) || (professionButton.hidden==YES)){
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter other value." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Toolbar actions
- (IBAction)toolBarDoneAction:(id)sender {
    [self hidePickerWithAnimation];
    if ([pickerType isEqualToString:@"1"]) {
        NSInteger index = [userPickerView selectedRowInComponent:0];
        if(professionArray.count==0) {
            professionTextField.text=@"";
        }
        else {
            if (![[professionArray objectAtIndex:index] isEqualToString:@"Other"]) {
                professionButton.hidden=NO;
                professionTextField.text=[professionArray objectAtIndex:index];
            }
            else {
                professionButton.hidden=YES;
                [professionTextField becomeFirstResponder];
            }
        }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
}
- (IBAction)cancelToolBarAction:(id)sender {
    [self hidePickerWithAnimation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
//Hide picker
- (void)hidePickerWithAnimation {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    userPickerView.frame = CGRectMake(userPickerView.frame.origin.x, 1000, self.view.frame.size.width, userPickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, 1000, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Picker view delegate methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,320,20)];
        pickerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    if ([pickerType isEqualToString:@"1"]) {
        pickerLabel.text=[professionArray objectAtIndex:row];
    }
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return professionArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str=@"";
    if ([pickerType isEqualToString:@"1"]) {
        if (professionArray.count>1) {
            str=[professionArray objectAtIndex:row];
        }
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerType isEqualToString:@"1"]) {
        if (professionArray.count>1) {
            if (![[professionArray objectAtIndex:row] isEqualToString:@"Other"]) {
                professionTextField.text = [professionArray objectAtIndex:row];
            }
            else {
                professionTextField.text=@"";
            }
        }
        else {
            professionTextField.text=@"";
        }
    }
}
#pragma mark - end

#pragma mark - ALPicker Delegate
- (void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr {
    
    if ([pickerType isEqualToString:@"2"]) {
        interestedInSelectcedArray=[selectedEntriesArr copy];
        if ([selectedEntriesArr containsObject:@"Other"]) {
            [selectedEntriesArr removeObject:@"Other"];
            isInterestedInOtherSelected=YES;
            [_interestedInOtherTextField becomeFirstResponder];
        }
        else {
            isInterestedInOtherSelected=NO;
        }
        [self viewCustomization:isInterestedInOtherSelected isSecondOtherShow:isInterestedAreaOtherSelected];
        NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@", "];
        interestedInTextField.text=dataStr;
    }
    else if ([pickerType isEqualToString:@"3"]){
         selectedPickerArray = [selectedEntriesArr copy];
        if ([selectedEntriesArr containsObject:@"Other"]) {
            [selectedEntriesArr removeObject:@"Other"];
            isInterestedAreaOtherSelected=YES;
            [_interestedAreaOtherTextField becomeFirstResponder];
        }
        else {
            isInterestedAreaOtherSelected=NO;
        }
        [self viewCustomization:isInterestedInOtherSelected isSecondOtherShow:isInterestedAreaOtherSelected];
        NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@", "];
        interestedAreaTextField.text = dataStr;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}

- (void)hidePicker {
    pickerType=@"4";
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
#pragma mark - end

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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
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
    else if (textField==professionTextField)
    {
        if([[UIScreen mainScreen] bounds].size.height<568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+180) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+50) animated:YES];
        }
        else{
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-180) animated:YES];
        }
    }
    else if (textField==_interestedInOtherTextField) {
        if([[UIScreen mainScreen] bounds].size.height<568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+220) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+100) animated:YES];
        }
        else{
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-100) animated:YES];
        }
        
    }
    else if (textField==_interestedAreaOtherTextField) {
        if([[UIScreen mainScreen] bounds].size.height<568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+325) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height+210) animated:YES];
        }
        else{
            [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height) animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Textview delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
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

- (void)textViewDidEndEditing:(UITextView *)textView{
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getInterestListing {
    [[ProfileService sharedManager] getInterestList:^(id responseObject) {
        [myDelegate stopIndicator];
        NSDictionary *tempDict=[responseObject objectForKey:@"details"];
        if ([[tempDict objectForKey:@"interestsList"] isEqualToString:@""]) {
            [interestedAreaArray addObject:@"Other"];
        }
        else {
            interestedAreaArray = [[[tempDict objectForKey:@"interestsList"] componentsSeparatedByString:@","] mutableCopy];
            [interestedAreaArray addObject:@"Other"];
        }
        if ([[tempDict objectForKey:@"profession"] isEqualToString:@""]) {
            [professionArray addObject:@"Other"];
        }
        else {
            professionArray=[[[tempDict objectForKey:@"profession"] componentsSeparatedByString:@","] mutableCopy];
            [professionArray addObject:@"Other"];
        }
        if ([[tempDict objectForKey:@"interestedInList"] isEqualToString:@""]) {
            [interestedInArray addObject:@"Other"];
        }
        else {
            interestedInArray=[[[tempDict objectForKey:@"interestedInList"] componentsSeparatedByString:@","] mutableCopy];
            [interestedInArray addObject:@"Other"];
        }
    }
                                            failure:^(NSError *error)
     {
         
     }] ;
    
}
- (void)editUserProfile {
    if ([interestedInTextField.text isEqualToString:@"NA"]) {
        interestedInTextField.text=@"";
    }
    if ([professionTextField.text isEqualToString:@"NA"]) {
        professionTextField.text=@"";
    }
    if ([interestedAreaTextField.text isEqualToString:@"NA"]) {
        interestedAreaTextField.text=@"";
    }
    [[ProfileService sharedManager] editUserProfile:userNameTextField.text userSurname:lastNameTextField.text userEmail:userEmailTextfield.text mobileNumber:mobileNumberTextField.text companyName:companyNameTextField.text companyAddress:companyAddressTextField.text designation:designationTextField.text aboutCompany:aboutCompanyTextView.text linkedIn:linkedInTextField.text interests:interestedAreaTextField.text interestedIn:interestedInTextField.text profession:professionTextField.text otherInterests:_interestedAreaOtherTextField.text otherInterestedIn:_interestedInOtherTextField.text otherProfession:professionTextField.text image:userImageView.image success:^(id responseObject) {
        [myDelegate stopIndicator];
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[MyProfileViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }
                                            failure:^(NSError *error)
     {
     }] ;
}
#pragma mark - end
#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            [myAlertView show];
        }
        else
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    if ([buttonTitle isEqualToString:@"Choose from Gallery"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.clipsToBounds=YES;
    //  userImageView.image = image;
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
    controller.delegate = self;
    controller.blurredBackground = YES;
    // set the cropped area
    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:NO];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    image1 = croppedImage;
    if (image1==nil) {
        userImageView.image=[UIImage imageNamed:@"user_thumbnail.png"];
    }
    else{
        userImageView.image = croppedImage;
    }
    //    CGRect cropArea = controller.cropArea;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller {
    if (image1==nil) {
        userImageView.image=[UIImage imageNamed:@"user_thumbnail.png"];
    }
    else{
        userImageView.image = image1;
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
#pragma mark - end

@end
