//
//  PendingAppointmnetViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PendingAppointmentViewController.h"
#import "PendingAppointmentCell.h"
#import "MyButton.h"
#import "ConferenceService.h"
#import "MeetingDescriptionViewController.h"
#import "MyProfileViewController.h"
#import "UIPlaceHolderTextView.h"

@interface PendingAppointmentViewController ()<UIGestureRecognizerDelegate,BSKeyboardControlsDelegate>
{
    int btnTag;
    NSMutableArray *appointmentDataArray;
    NSString *cancelMessageString;
    NSArray *textFieldArray;
}
@property (weak, nonatomic) IBOutlet UITableView *pendingAppointmentTable;
@property (weak, nonatomic) IBOutlet UILabel *noResulFoundLabel;
@property (nonatomic,strong) NSString *appointmentId;
@property (nonatomic,strong) NSString *meetingId;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *appointmentType;
@property (strong, nonatomic) IBOutlet UIView *messageForCancelView;
@property (strong, nonatomic) IBOutlet UIView *cancelMessageContainerView;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *cancelMessageTextView;
@property (nonatomic,strong) NSString *appointmentDate;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation PendingAppointmentViewController
@synthesize pendingAppointmentTable;
@synthesize screenName;
@synthesize appointmentType;
@synthesize status;
@synthesize appointmentId;
@synthesize meetingId;
@synthesize appointmentDate;
@synthesize noResulFoundLabel;
@synthesize messageForCancelView;
@synthesize cancelMessageTextView;
@synthesize cancelMessageContainerView;
@synthesize keyboardControls;
#pragma mark - View life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    textFieldArray = @[cancelMessageTextView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meetingDescriptionContainerView:)];
    tapGesture.delegate=self;
    [cancelMessageContainerView addGestureRecognizer:tapGesture];

    
    appointmentDataArray=[[NSMutableArray alloc]init];
    noResulFoundLabel.hidden=YES;
    if ([screenName isEqualToString:@"Pending Appointments"]) {
        self.navigationItem.title=screenName;
        noResulFoundLabel.text=@"No pending appointment(s).";
        [myDelegate showIndicator];
        [self performSelector:@selector(getPendingAppointmentList) withObject:nil afterDelay:.1];
    }
    else {
        self.navigationItem.title=screenName;
        noResulFoundLabel.text=@"No requested appointement(s).";
        [myDelegate showIndicator];
        [self performSelector:@selector(getRequestedAppointmentList) withObject:nil afterDelay:.1];
    }
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pendingDetails) name:@"Pending" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestedDetails) name:@"Requested" object:nil];
    [cancelMessageTextView setPlaceholder:@"  Cancel Message"];
    
}
-(void)pendingDetails{
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getPendingAppointmentList) withObject:nil afterDelay:0.1];
}
-(void)requestedDetails{
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getRequestedAppointmentList) withObject:nil afterDelay:0.1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([screenName isEqualToString:@"Pending Appointments"]) {
        
        myDelegate.myView=@"PendingViewController";
        [UserDefaultManager setValue:@"0" key:@"PendingMessage"];
        [myDelegate removeBadgeIconOnMoreTab];
    }
    else {
        myDelegate.myView=@"NoPendingViewController";
    }
}
#pragma mark - end

#pragma mark - Webservices
-(void)getRequestedAppointmentList {
    [[ConferenceService sharedManager] requestedAppointment:^(id dataArray) {
        [myDelegate stopIndicator];
        appointmentDataArray=[dataArray mutableCopy];
        if (appointmentDataArray==nil) {
            noResulFoundLabel.hidden=NO;
            noResulFoundLabel.text=@"No requested appointement(s).";
            pendingAppointmentTable.hidden=YES;
        }
        else {
            pendingAppointmentTable.hidden=NO;
            noResulFoundLabel.hidden=YES;
            [pendingAppointmentTable reloadData];
        }
        
        
    }
                                                    failure:^(NSError *error)
     {
         noResulFoundLabel.hidden=NO;
         noResulFoundLabel.text=@"No requested appointement(s).";
         pendingAppointmentTable.hidden=YES;
     }] ;
    
}

-(void)getPendingAppointmentList {
    [[ConferenceService sharedManager] pendingAppointment:^(id dataArray) {
        [myDelegate stopIndicator];
        appointmentDataArray=[dataArray mutableCopy];
        if (appointmentDataArray==nil) {
            noResulFoundLabel.hidden=NO;
            noResulFoundLabel.text=@"No pending appointement(s).";
            pendingAppointmentTable.hidden=YES;
        }
        else {
            pendingAppointmentTable.hidden=NO;
            noResulFoundLabel.hidden=YES;
            [pendingAppointmentTable reloadData];
        }
        
    }
                                                  failure:^(NSError *error)
     {
         noResulFoundLabel.hidden=NO;
         noResulFoundLabel.text=@"No pending appointement(s).";
         pendingAppointmentTable.hidden=YES;
     }] ;
    
}
-(void)acceptMeetingRequest {
    [[ConferenceService sharedManager] acceptCancelMeeting:appointmentId meetingUserId:meetingId flag:status  type:appointmentType reasonForCancel:@"" success:^(id dataArray) {
        [self getPendingAppointmentList];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
    
}
-(void)cancelMeetingRequest {
    [[ConferenceService sharedManager] acceptCancelMeeting:appointmentId meetingUserId:meetingId flag:status type:appointmentType reasonForCancel:cancelMessageString success:^(id dataArray) {
        if ([appointmentType isEqualToString:@"requested"]) {
            [self getPendingAppointmentList];
            cancelMessageContainerView.hidden = YES;
        }
        else {
            [self getRequestedAppointmentList];
        }
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end
#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView * headerView;
//    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
//    headerView.backgroundColor = [UIColor clearColor];
//    UILabel * notificationLabel = [[UILabel alloc] init];
//    notificationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
//    notificationLabel.text=@"Date";
//    float width =  [notificationLabel.text boundingRectWithSize:notificationLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:notificationLabel.font } context:nil]
//    .size.width;
//    notificationLabel.frame = CGRectMake(15, 0, width,40.0);
//    notificationLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
//    [headerView addSubview:notificationLabel];
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appointmentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"pendingCell";
    PendingAppointmentCell *pendingCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (pendingCell == nil) {
        pendingCell = [[PendingAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if ([screenName isEqualToString:@"Pending Appointments"]) {
        pendingCell.userName.hidden=YES;
        pendingCell.pendingUserName.hidden=NO;
    }
    else {
        pendingCell.userName.hidden=NO;
        pendingCell.acceptButton.hidden=YES;
        pendingCell.pendingUserName.hidden=YES;
    }
    [pendingCell.pendingViewContainer addShadow:pendingCell.pendingViewContainer color:[UIColor lightGrayColor]];
    [pendingCell.meetingTitle addTarget:self action:@selector(meetingDetail:) forControlEvents:UIControlEventTouchUpInside];
    pendingCell.meetingTitle.Tag=(int)indexPath.row;
    pendingCell.acceptButton.Tag=(int)indexPath.row;
    pendingCell.cancelButton.Tag=(int)indexPath.row;
    PendingAppointmentDataModel *data=[appointmentDataArray objectAtIndex:indexPath.row];
    [pendingCell displayData:data indexPath:(int)indexPath.row rectSize:pendingCell.frame.size];
    [pendingCell.acceptButton addTarget:self action:@selector(acceptMeetingButtionAction:) forControlEvents:UIControlEventTouchUpInside];
    [pendingCell.cancelButton addTarget:self action:@selector(cancelMeetingButtionAction:) forControlEvents:UIControlEventTouchUpInside];
    return pendingCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    profileView.viewName=@"User Profile";
    profileView.otherUserID=[[appointmentDataArray objectAtIndex:indexPath.row]meetingUserId];
    [self.navigationController pushViewController:profileView animated:YES];
    
}
#pragma mark - end

#pragma mark - IBActions

- (IBAction)meetingDetail:(MyButton *)sender {
    btnTag=[sender Tag];
    PendingAppointmentDataModel *data=[appointmentDataArray objectAtIndex:btnTag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingDescriptionViewController *descreptionView =[storyboard instantiateViewControllerWithIdentifier:@"MeetingDescriptionViewController"];
    descreptionView.meetingDescription=data.meetingDescription;
    descreptionView.meetingLocation=data.meetingVenue;
    descreptionView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    [descreptionView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:descreptionView animated: NO completion:nil];
}

- (IBAction)acceptMeetingButtionAction:(MyButton *)sender {
    btnTag=[sender Tag];
    appointmentId=[[appointmentDataArray objectAtIndex:btnTag]appointmentId];
    meetingId=[[appointmentDataArray objectAtIndex:btnTag]meetingUserId];
    appointmentDate=[[appointmentDataArray objectAtIndex:btnTag]appointmentDate];
    status=@"accept";
    appointmentType=@"requested";
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptMeetingRequest) withObject:nil afterDelay:.1];
}

- (IBAction)cancelMeetingButtionAction:(MyButton *)sender {
    btnTag=[sender Tag];
    appointmentId=[[appointmentDataArray objectAtIndex:btnTag]appointmentId];
    meetingId=[[appointmentDataArray objectAtIndex:btnTag]meetingUserId];
    appointmentDate=[[appointmentDataArray objectAtIndex:btnTag]appointmentDate];
    status=@"cancel";
    if ([screenName isEqualToString:@"Pending Appointments"]) {
        appointmentType=@"requested";
        cancelMessageContainerView.hidden = NO;
        
    }
    else {
        appointmentType=@"assigned";
        cancelMessageString = @"";
        [myDelegate showIndicator];
        [self performSelector:@selector(cancelMeetingRequest) withObject:nil afterDelay:.1];
        
    }
    
}
- (IBAction)confirmCancelButtonAction:(id)sender {
    
    [keyboardControls.activeField resignFirstResponder];

    if ([cancelMessageTextView.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter message for cancel." closeButtonTitle:@"Done" duration:0.0f];
    }
    else
    {
        cancelMessageString = cancelMessageTextView.text;
        [myDelegate showIndicator];
        [self performSelector:@selector(cancelMeetingRequest) withObject:nil afterDelay:.1];
        
    }
}

#pragma mark - end
#pragma mark - Tap gesture delegate
-(void) meetingDescriptionContainerView:(UITapGestureRecognizer *)sender {
    cancelMessageContainerView.hidden = YES;
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction{
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls{
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end
#pragma mark - Textview delegates
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
}
#pragma mark - end

@end
