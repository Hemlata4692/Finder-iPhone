//
//  EditProfileViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileService.h"
#import "ALPickerView.h"
#import "CYCustomMultiSelectPickerView.h"

@interface EditProfileViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,CYCustomMultiSelectPickerViewDelegate,UIToolbarDelegate,UIPickerViewDelegate>
{
    NSArray *textFieldArray;
    CYCustomMultiSelectPickerView *multiPickerView;
    NSMutableArray *interestedAreaArray;
     NSMutableArray *interestedInArray;
    NSMutableArray *professionArray;
    NSMutableArray *selectedInterestedArray;
    NSString* pickerType;

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
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
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
@synthesize pickerView;
@synthesize pickerToolBar;

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
    interestedAreaArray=[[NSMutableArray alloc]init];
    interestedInArray=[[NSMutableArray alloc]init];
    professionArray=[[NSMutableArray alloc]init];
    selectedInterestedArray=[[NSMutableArray alloc]init];
    pickerView.translatesAutoresizingMaskIntoConstraints = YES;
    pickerToolBar.translatesAutoresizingMaskIntoConstraints = YES;
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
    [multiPickerView removeFromSuperview];
    [_keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    pickerType=@"1";
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
    [pickerView reloadAllComponents];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.frame.size.height-(pickerView.frame.size.height+44), self.view.frame.size.width, pickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}
- (IBAction)interestedInPickerAction:(id)sender {
    [multiPickerView removeFromSuperview];
    [_keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    pickerType=@"2";
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
    [pickerView reloadAllComponents];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.frame.size.height-(pickerView.frame.size.height+44), self.view.frame.size.width, pickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];

}
- (IBAction)interestedAreaPickerAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    [editProfileScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height-150) animated:YES];
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-182, self.view.frame.size.width, 182)];
    multiPickerView.entriesArray = interestedAreaArray;
    multiPickerView.entriesSelectedArray = selectedInterestedArray;
    multiPickerView.multiPickerDelegate = self;
    
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];

}
- (IBAction)selectImageButtonAction:(id)sender {
}
- (IBAction)saveButtonAction:(id)sender {
}
#pragma mark - end
#pragma mark - Toolbar actions
- (IBAction)toolBarDoneAction:(id)sender {
    [self hidePickerWithAnimation];
    if ([pickerType isEqualToString:@"1"]) {
        NSInteger index = [pickerView selectedRowInComponent:0];
         professionTextField.text=[professionArray objectAtIndex:index];
    }
    else {
        NSInteger index = [pickerView selectedRowInComponent:0];
        interestedInTextField.text=[interestedInArray objectAtIndex:index];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
-(void)hidePickerWithAnimation{
  
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 1000, self.view.frame.size.width, pickerView.frame.size.height);
        pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, 1000, self.view.frame.size.width, 44);
        [UIView commitAnimations];
   
}

#pragma mark - end
#pragma mark - Picker view delegate methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,320,20)];
        pickerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    if ([pickerType isEqualToString:@"1"]) {
         pickerLabel.text=[professionArray objectAtIndex:row];
    }
    else {
        pickerLabel.text=[interestedInArray objectAtIndex:row];
    }
    //interestedInArray
   
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerType isEqualToString:@"1"]) {
    return professionArray.count;
    }
    else {
      return [interestedInArray count];
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if ([pickerType isEqualToString:@"1"]) {
        str=[professionArray objectAtIndex:row];
    }
    else {
        str=[interestedInArray objectAtIndex:row];
    }
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     if ([pickerType isEqualToString:@"1"]) {
          professionTextField.text = [professionArray objectAtIndex:row];
    }
    else {
        interestedAreaTextField.text=[interestedInArray objectAtIndex:row];
    }
}
#pragma mark - end


#pragma mark - ALPicker Delegate
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr
{
    editProfileScrollView.scrollEnabled = YES;
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@","];
    selectedInterestedArray = selectedEntriesArr;
    interestedAreaTextField.text = dataStr;
    
}
-(void)hidePicker
{
    [editProfileScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
  //  _scrollView.scrollEnabled = YES;
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
        [self getInterestedInList];
        interestedAreaArray=[responseObject objectForKey:@"interestsList"];
        
    }
                                            failure:^(NSError *error)
     {
         
     }] ;
    
}
-(void)getInterestedInList
{
    [[ProfileService sharedManager] getInterestedInList:^(id responseObject) {
        [self getProfessionList];
        interestedInArray=[responseObject objectForKey:@"interestedInList"];
        
    }
                                            failure:^(NSError *error)
     {
         
     }] ;

}
-(void)getProfessionList
{
    [[ProfileService sharedManager] getProfessionList:^(id responseObject) {
        [myDelegate stopIndicator];
        professionArray=[responseObject objectForKey:@"professionList"];
        
    }
                                                failure:^(NSError *error)
     {
         
     }] ;
    
}
@end
