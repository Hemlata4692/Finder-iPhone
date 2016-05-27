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

@interface PendingAppointmentViewController ()<UIGestureRecognizerDelegate>
{
    int btnTag;
}
@property (weak, nonatomic) IBOutlet UITableView *pendingAppointmentTable;
@property (weak, nonatomic) IBOutlet UIView *meetingDetailContainerView;
@property (weak, nonatomic) IBOutlet UIView *mettingDetailView;
@property (weak, nonatomic) IBOutlet UILabel *meetingAgendaLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingDetailLabel;
@end

@implementation PendingAppointmentViewController
@synthesize pendingAppointmentTable,meetingDetailContainerView,mettingDetailView,meetingAgendaLabel,meetingDetailLabel;
@synthesize screenName;

#pragma mark - View life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    meetingDetailContainerView.hidden=YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meetingDetailContainerViewTapped:)];
    tapGesture.delegate=self;
    [meetingDetailContainerView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([screenName isEqualToString:@"Pending Appointments"]) {
        self.navigationItem.title=screenName;
    }
    else {
        self.navigationItem.title=screenName;
    }
}

#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * notificationLabel = [[UILabel alloc] init];
    notificationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    notificationLabel.text=@"Date";
    float width =  [notificationLabel.text boundingRectWithSize:notificationLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:notificationLabel.font } context:nil]
    .size.width;
    notificationLabel.frame = CGRectMake(15, 0, width,40.0);
    notificationLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
    [headerView addSubview:notificationLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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
    return pendingCell;
}
#pragma mark - end

#pragma mark - IBActions

- (IBAction)meetingDetail:(MyButton *)sender {
    btnTag=[sender Tag];
    [self setMeetingDetail:btnTag];
    meetingDetailContainerView.hidden=NO;
}
#pragma mark - end

#pragma mark - Show popover
-(void)setMeetingDetail:(int)btnTag {
    NSString *messageText=@"Support for custom background views WYPopoverController is for the presentation of content in popover on iPhone / iPad devices. Very customizable.";
    [mettingDetailView addShadow:mettingDetailView color:[UIColor lightGrayColor]];
    [mettingDetailView setCornerRadius:2.0f];
    mettingDetailView.translatesAutoresizingMaskIntoConstraints = YES;
    meetingAgendaLabel.translatesAutoresizingMaskIntoConstraints = YES;
    meetingDetailLabel.translatesAutoresizingMaskIntoConstraints = YES;
    mettingDetailView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width/2-mettingDetailView.frame.size.width/2, self.view.frame.size.height/2-mettingDetailView.frame.size.height/2, mettingDetailView.frame.size.width, 180);
    meetingAgendaLabel.frame = CGRectMake(0, 0, mettingDetailView.frame.size.width, 45);
    
    if ([messageText isEqualToString:@""]) {
        meetingDetailLabel.frame = CGRectMake(1, meetingAgendaLabel.frame.origin.y + meetingAgendaLabel.frame.size.height + 5, mettingDetailView.frame.size.width, 0);
        meetingDetailLabel.text = messageText;
        meetingDetailLabel.hidden = YES;
    }
    else {
        CGSize size = CGSizeMake(meetingAgendaLabel.frame.size.width,180);
        CGRect textRect = [messageText
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
                           context:nil];
        meetingDetailLabel.numberOfLines = 0;
        
        if (textRect.size.height < 26) {
            textRect.size.height = 25;
        }
        meetingDetailLabel.frame = CGRectMake(1, meetingAgendaLabel.frame.origin.y + meetingAgendaLabel.frame.size.height + 5, mettingDetailView.frame.size.width, textRect.size.height);
        meetingDetailLabel.text = messageText;
        meetingDetailLabel.hidden = NO;
    }
    float alertViewHeight = meetingDetailLabel.frame.origin.y + meetingDetailLabel.frame.size.height + 10;
    mettingDetailView.frame = CGRectMake((self.view.frame.origin.x+self.view.frame.size.width/2-mettingDetailView.frame.size.width/2), (self.view.frame.size.height/2-mettingDetailView.frame.size.height/2), mettingDetailView.frame.size.width, alertViewHeight);
}
-(void) meetingDetailContainerViewTapped:(UITapGestureRecognizer *)sender {
    meetingDetailContainerView.hidden=YES;
}
#pragma mark - end
@end
