//
//  ScheduleMeetingViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ScheduleMeetingViewController.h"
#import "UIPlaceHolderTextView.h"

@interface ScheduleMeetingViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UITextViewDelegate>
{
    NSArray *textFieldArray;
    int selectedPicker;
    BOOL isDatePicker;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIScrollView *scheduleMeetingScrollView;
@property (weak, nonatomic) IBOutlet UIView *scheduleMeetingView;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *venueTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *meetingAgendaTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@end

@implementation ScheduleMeetingViewController
@synthesize pickerView,pickerToolbar,datePicker,contactNameTextField,venueTextField,dateTextField,timeTextField,meetingAgendaTextField,keyboardControls,scheduleMeetingScrollView,scheduleMeetingView;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    textFieldArray = @[venueTextField,meetingAgendaTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [self addborder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    pickerToolbar.translatesAutoresizingMaskIntoConstraints=YES;
    datePicker.translatesAutoresizingMaskIntoConstraints=YES;
    pickerView.backgroundColor=[UIColor redColor];
    datePicker.backgroundColor=[UIColor blueColor];
    selectedPicker=0;
}
-(void)addborder
{
    [contactNameTextField setTextBorder:contactNameTextField color:[UIColor lightGrayColor]];
    [venueTextField setTextBorder:venueTextField color:[UIColor lightGrayColor]];
    [dateTextField setTextBorder:dateTextField color:[UIColor lightGrayColor]];
    [timeTextField setTextBorder:timeTextField color:[UIColor lightGrayColor]];
    [meetingAgendaTextField setTextViewBorder:meetingAgendaTextField color:[UIColor lightGrayColor]];
    [contactNameTextField addTextFieldPaddingWithoutImages:contactNameTextField];
    [venueTextField addTextFieldPaddingWithoutImages:venueTextField];
    [timeTextField addTextFieldPaddingWithoutImages:timeTextField];
    [dateTextField addTextFieldPaddingWithoutImages:dateTextField];
    [contactNameTextField setCornerRadius:2.0f];
    [dateTextField setCornerRadius:2.0f];
    [venueTextField setCornerRadius:2.0f];
    [timeTextField setCornerRadius:2.0f];
    [meetingAgendaTextField setCornerRadius:2.0f];
    [meetingAgendaTextField setPlaceholder:@"  Meeting Agenda"];
    [meetingAgendaTextField setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender
{
    [keyboardControls.activeField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)cancelButtonAction:(id)sender
{
    [keyboardControls.activeField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
//Load picker
- (IBAction)contactNameButtonAction:(id)sender
{
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
//Load date picker
- (IBAction)dateTimePickerButtonAction:(id)sender
{
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    selectedPicker=1;
    isDatePicker=true;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
         [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+50) animated:YES];
    }
     datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-(datePicker.frame.size.height+44), self.view.frame.size.width, datePicker.frame.size.height);
    pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, datePicker.frame.origin.y-44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}
//Load time picker
- (IBAction)timePickerButtonAction:(id)sender
{
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    isDatePicker=false;
    selectedPicker=1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+50) animated:YES];
    }
     datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-(datePicker.frame.size.height+44), self.view.frame.size.width, datePicker.frame.size.height);
    pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, datePicker.frame.origin.y-44, self.view.frame.size.width, 44);
    datePicker.datePickerMode = UIDatePickerModeTime;
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Toobar button actions
- (IBAction)toolbarDoneAction:(id)sender
{
    [self hidePickerWithAnimation];
    if (selectedPicker==0) {
        
    }
    else
    {
        if (isDatePicker==false)
        {
            NSDateFormatter * tf = [[NSDateFormatter alloc] init];
            [tf setDateFormat:@"hh:mm a"]; // from here u can change format..
            timeTextField.text=[tf stringFromDate:datePicker.date];
        }
        else
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"M-d-yyyy"]; // from here u can change format..
            dateTextField.text=[df stringFromDate:datePicker.date];
        }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
- (IBAction)toolbarCancelAction:(id)sender
{
    [self hidePickerWithAnimation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
//Hide picker
-(void)hidePickerWithAnimation
{
    if (selectedPicker==1)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, 1000, self.view.frame.size.width, 44);
        datePicker.frame = CGRectMake(datePicker.frame.origin.x, 1000, self.view.frame.size.width, datePicker.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
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
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    pickerLabel.text=@"monika";
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    str=@"monika";
    return str;
}
#pragma mark - end

#pragma mark - Keyboard controls delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboard
{
    [keyboard.activeField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end
#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        if (textField==venueTextField)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+30) animated:YES];
            }];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        if (textField==venueTextField)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }];
        }
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark - end
#pragma mark - Textview delegates
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textView];
    if (textView==meetingAgendaTextField)
    {
        if([[UIScreen mainScreen] bounds].size.height<568)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+(meetingAgendaTextField.frame.origin.y-30)) animated:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [scheduleMeetingScrollView setContentOffset:CGPointMake(0, scheduleMeetingScrollView.frame.origin.y+50) animated:YES];
            }];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
     [scheduleMeetingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end

@end
