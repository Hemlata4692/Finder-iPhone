//
//  CalendarViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarTableViewCell.h"
#import "ScheduleMeetingViewController.h"

@interface CalendarViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UITextViewDelegate>
{
    int selectedPicker;
    BOOL isDatePicker;
    NSArray *textFieldArray;
}
@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

//Schedule meeting view
@property (weak, nonatomic) IBOutlet UIView *scheduleMtgCtnrView;
@property (weak, nonatomic) IBOutlet UIView *scheduleMeetingView;
@property (weak, nonatomic) IBOutlet UITextField *contactNameText;
@property (weak, nonatomic) IBOutlet UITextField *venueText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet UITextView *meetingAgendaText;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation CalendarViewController
@synthesize pickerView,pickerToolbar,datePicker,contactNameText,venueText,dateText,timeText,meetingAgendaText,keyboardControls,scheduleMtgCtnrView,scheduleMeetingView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"CALENDAR";
    textFieldArray = @[venueText,meetingAgendaText];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    dateLabel.text=@"THURSDAY 25th FEBRUARY";
    float width =  [dateLabel.text boundingRectWithSize:dateLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:dateLabel.font } context:nil]
    .size.width;
    dateLabel.frame = CGRectMake(15, 0, width,40.0);
    dateLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
    [headerView addSubview:dateLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    else if (section==1)
    {
        return 3;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"calendarCell";
    CalendarTableViewCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (calendarCell == nil)
    {
        calendarCell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [calendarCell.containerView addShadow:calendarCell.containerView color:[UIColor lightGrayColor]];
    return calendarCell;
}
#pragma mark - end

#pragma mark - IBActions

- (IBAction)addButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
}
- (IBAction)saveButtonAction:(id)sender
{
    
}
- (IBAction)cancelButtonAction:(id)sender
{
    scheduleMtgCtnrView.hidden=YES;
}
//Load picker
- (IBAction)contactNameButtonAction:(id)sender
{
    [keyboardControls.activeField resignFirstResponder];
    [self hidePickerWithAnimation];
    selectedPicker=0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView reloadAllComponents];
    [pickerView setNeedsLayout];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.frame.size.height-pickerView.frame.size.height, self.view.bounds.size.width, pickerView.frame.size.height);
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
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-70, self.view.frame.size.width, self.view.frame.size.height);
        datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-datePicker.frame.size.height+70, self.view.frame.size.width, datePicker.frame.size.height);
    }
    else
    {
    datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-datePicker.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height);
    }
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
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-70, self.view.frame.size.width, self.view.frame.size.height);
        datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-datePicker.frame.size.height+70, self.view.frame.size.width, datePicker.frame.size.height);
    }
    else
    {
    datePicker.frame = CGRectMake(datePicker.frame.origin.x, self.view.frame.size.height-datePicker.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height);
    }
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
        timeText.text=[tf stringFromDate:datePicker.date];
    }
    else
    {
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"M-d-yyyy"]; // from here u can change format..
        dateText.text=[df stringFromDate:datePicker.date];
    }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
     [UIView commitAnimations];
}
- (IBAction)toolbarCancelAction:(id)sender
{
    [self hidePickerWithAnimation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
        self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
     [UIView commitAnimations];
}
//Hide picker
-(void)hidePickerWithAnimation
{
    if (selectedPicker==1)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
        pickerToolbar.frame = CGRectMake(pickerToolbar.frame.origin.x, 1000, self.view.frame.size.width, 44);
        datePicker.frame = CGRectMake(datePicker.frame.origin.x, 1000, self.view.frame.size.width, datePicker.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
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
}

#pragma mark - end
#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        if (textField==venueText)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        if (textField==venueText)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
     [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
    return YES;
}
#pragma mark - end
#pragma mark - Textview delegates
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textView];
    if (textView==meetingAgendaText)
    {
        if([[UIScreen mainScreen] bounds].size.height<568)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-170, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-140, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        else if([[UIScreen mainScreen] bounds].size.height<1136)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-100, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==meetingAgendaText)
    {
        if([[UIScreen mainScreen] bounds].size.height<568)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+170, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+140, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        else if([[UIScreen mainScreen] bounds].size.height<1136)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+100, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

#pragma mark - end

@end
