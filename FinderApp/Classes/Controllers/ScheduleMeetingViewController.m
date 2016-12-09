//
//  ScheduleMeetingViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ScheduleMeetingViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ContactDataModel.h"
#import "ConferenceService.h"

@interface ScheduleMeetingViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UITextViewDelegate>
{
    NSArray *textFieldArray;
    int selectedPicker;
    BOOL isDatePicker;
    int timeRange;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIScrollView *scheduleMeetingScrollView;
@property (weak, nonatomic) IBOutlet UIView *scheduleMeetingView;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *venueTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTimeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *meetingAgendaTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@end

@implementation ScheduleMeetingViewController
@synthesize pickerView,pickerToolbar,datePicker,contactNameTextField,venueTextField,dateTextField,toTimeTextField,meetingAgendaTextField,keyboardControls,scheduleMeetingScrollView,scheduleMeetingView,fromTimeTextField,contactDetailArray;
@synthesize screenName;
@synthesize contactButton;
@synthesize userImage;
@synthesize dropDownImage;
@synthesize contactUserID;
@synthesize ContactName;
@synthesize calenderObj;
@synthesize timePicker;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![screenName isEqualToString:@"Calendar"]) {
        contactButton.hidden=YES;
        dropDownImage.hidden=YES;
        userImage.hidden=NO;
        contactNameTextField.text=ContactName;
        textFieldArray = @[contactNameTextField,venueTextField,meetingAgendaTextField];
    }
    else {
        contactButton.hidden=NO;
        dropDownImage.hidden=NO;
        userImage.hidden=YES;
        textFieldArray = @[venueTextField,meetingAgendaTextField];
    }
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [self addBorderCornerRadius];
    if([[UIScreen mainScreen] bounds].size.height>=568) {
        scheduleMeetingScrollView.scrollEnabled=NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    pickerToolbar.translatesAutoresizingMaskIntoConstraints=YES;
    datePicker.translatesAutoresizingMaskIntoConstraints=YES;
    timePicker.translatesAutoresizingMaskIntoConstraints=YES;
    pickerView.backgroundColor=[UIColor whiteColor];
    datePicker.backgroundColor=[UIColor whiteColor];
    timePicker.backgroundColor=[UIColor whiteColor];
    selectedPicker=0;
}
//add padding, corner radius and border on text fields
- (void)addBorderCornerRadius{
    [meetingAgendaTextField setTextViewBorder:meetingAgendaTextField color:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [meetingAgendaTextField setCornerRadius:2.0f];
    [meetingAgendaTextField setPlaceholder:@"  Meeting Agenda"];
    [meetingAgendaTextField setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender {
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(scheduleMeeting) withObject:nil afterDelay:.1];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
//Load picker
- (IBAction)contactNameButtonAction:(id)sender {
    if (contactDetailArray.count==0) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"You don’t have any contact yet." closeButtonTitle:@"Done" duration:0.0f];
    }
    else {
        [keyboardControls.activeField resignFirstResponder];
        [self hidePickerWithAnimation];
        selectedPicker=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [pickerView setNeedsLayout];
        [pickerView reloadAllComponents];
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.frame.size.height-(pickerView.frame.size.height+44), self.view.frame.size.width, pickerView.frame.size.height);
        pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, pickerView.frame.origin.y-44, self.view.frame.size.width, 44);
        [UIView commitAnimations];
    }
}
//Load date picker
- (IBAction)dateTimePickerButtonAction:(id)sender {
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    selectedPicker=1;
    isDatePicker=true;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate=[UserDefaultManager getValue:@"conferenceStartDate"];
    NSDate *today = [NSDate date]; // it will give you current date
    NSComparisonResult result;
    result = [today compare:datePicker.minimumDate]; // comparing two dates
    if(result==NSOrderedAscending){
        datePicker.minimumDate=[UserDefaultManager getValue:@"conferenceStartDate"];
    }
    else if(result==NSOrderedDescending){
        datePicker.minimumDate=[NSDate date];
    }
    else {
        datePicker.minimumDate=[NSDate date];
    }
    datePicker.maximumDate=[UserDefaultManager getValue:@"conferenceEndDate"];
    if([[UIScreen mainScreen] bounds].size.height<568){
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+50) animated:YES];
    }
    datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-(datePicker.frame.size.height+44), self.view.frame.size.width, datePicker.frame.size.height);
    pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, datePicker.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}
//Load time picker
- (IBAction)timePickerButtonAction:(id)sender {
    if ([sender tag]==20) {
        timeRange=1;
    }
    else {
        timeRange=21;
    }
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    isDatePicker=false;
    selectedPicker=1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    timePicker.datePickerMode = UIDatePickerModeTime;
    if([[UIScreen mainScreen] bounds].size.height<568) {
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+80) animated:YES];
    }
    else  if([[UIScreen mainScreen] bounds].size.height==568) {
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+30) animated:YES];
    }
    timePicker.frame = CGRectMake(timePicker.frame.origin.x, self.view.frame.size.height-(timePicker.frame.size.height+44), self.view.frame.size.width, timePicker.frame.size.height);
    pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, timePicker.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Toobar button actions
- (IBAction)toolbarDoneAction:(id)sender {
    [self hidePickerWithAnimation];
    if (selectedPicker==0) {
        if (contactDetailArray.count==0) {
            contactNameTextField.text=@"";
        }
        else {
            NSInteger index = [pickerView selectedRowInComponent:0];
            contactNameTextField.text=[[contactDetailArray objectAtIndex:index]contactName];
            contactUserID=[[contactDetailArray objectAtIndex:index]contactUserId];
        }
    }
    else {
        if (isDatePicker==false) {
            NSDateFormatter * timePickerValue = [[NSDateFormatter alloc] init];
            [timePickerValue setDateFormat:@"HH:mm"]; // from here u can change format..
            if (timeRange==1) {
                fromTimeTextField.text=[timePickerValue stringFromDate:timePicker.date];
            }
            else {
                toTimeTextField.text=[timePickerValue stringFromDate:timePicker.date];
            }
            
        }
        else {
            NSDateFormatter * datePickerValue = [[NSDateFormatter alloc] init];
            [datePickerValue setDateFormat:@"YYYY-MM-dd"]; // from here u can change format..
            dateTextField.text=[datePickerValue stringFromDate:datePicker.date];
        }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
//Cancel toolbar action
- (IBAction)toolbarCancelAction:(id)sender {
    [self hidePickerWithAnimation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
//Hide picker
- (void)hidePickerWithAnimation {
    if (selectedPicker==1) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, 1000, self.view.frame.size.width, 44);
        datePicker.frame = CGRectMake(datePicker.frame.origin.x, 1000, self.view.frame.size.width, datePicker.frame.size.height);
        timePicker.frame = CGRectMake(timePicker.frame.origin.x, 1000, self.view.frame.size.width, timePicker.frame.size.height);
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 1000, self.view.frame.size.width, pickerView.frame.size.height);
        pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, 1000, self.view.frame.size.width, 44);
        [UIView commitAnimations];
    }
}
#pragma mark - end

#pragma mark - Picker view delegate methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    pickerLabel.text=[[contactDetailArray objectAtIndex:row]contactName];
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return contactDetailArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str=@"";
    if (contactDetailArray.count>1) {
        str=[[contactDetailArray objectAtIndex:row]contactName];
    }
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView1 == pickerView) {
        if (contactDetailArray.count==0) {
            contactNameTextField.text=@"";
        }
        else {
            contactNameTextField.text = [[contactDetailArray objectAtIndex:row]contactName];
        }
    }
}
#pragma mark - end

#pragma mark - Keyboard controls delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboard {
    [keyboard.activeField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<568) {
        if (textField==venueTextField) {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+30) animated:YES];
            }];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([[UIScreen mainScreen] bounds].size.height<568) {
        if (textField==venueTextField) {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }];
        }
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark - end

#pragma mark - Textview delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textView];
    if (textView==meetingAgendaTextField) {
        if([[UIScreen mainScreen] bounds].size.height<568) {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+(meetingAgendaTextField.frame.origin.y-30)) animated:YES];
            }];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+50) animated:YES];
            }];
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Webservice
-(BOOL)performValidations {
    if ([contactNameTextField isEmpty] || [venueTextField isEmpty] || [dateTextField isEmpty] || [fromTimeTextField isEmpty] || [toTimeTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"All the fields are mandatory." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        NSDate *date1= [formatter dateFromString:fromTimeTextField.text];
        NSDate *date2 = [formatter dateFromString:toTimeTextField.text];
        
        NSComparisonResult result = [date1 compare:date2];
        if(result == NSOrderedDescending) {
            NSLog(@"date1 is later than date2");
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid time" closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        else if(result == NSOrderedAscending) {
            NSLog(@"date2 is later than date1");
            return YES;
        }
        else {
            NSLog(@"date1 is equal to date2");
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid time" closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
    }
}
- (void)scheduleMeeting {
    [[ConferenceService sharedManager] scheduleMeeting:contactUserID venue:venueTextField.text meetingAgenda:meetingAgendaTextField.text date:dateTextField.text timeFrom:fromTimeTextField.text timeTo:toTimeTextField.text success:^(id responseObject) {
        [myDelegate stopIndicator];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
                                               failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
@end
