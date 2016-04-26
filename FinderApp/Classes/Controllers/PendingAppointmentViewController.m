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

@interface PendingAppointmentViewController ()
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

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"PENDING APPOINTMENT";
    // Do any additional setup after loading the view.
    meetingDetailContainerView.hidden=YES;
}

-(void)setMeedingDetailViewFrame
{
    mettingDetailView.translatesAutoresizingMaskIntoConstraints = YES;
    meetingAgendaLabel.translatesAutoresizingMaskIntoConstraints = YES;
    meetingDetailLabel.translatesAutoresizingMaskIntoConstraints = YES;
    mettingDetailView.frame = CGRectMake(0, 0, mettingDetailView.frame.size.width, 180);
    meetingAgendaLabel.frame = CGRectMake(0, 0, mettingDetailView.frame.size.width, 45);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"pendingCell";
        PendingAppointmentCell *pendingCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (pendingCell == nil)
        {
            pendingCell = [[PendingAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    [pendingCell.pendingViewContainer addShadow:pendingCell.pendingViewContainer color:[UIColor lightGrayColor]];
    
    [pendingCell.meetingTitle addTarget:self action:@selector(meetingDetail:) forControlEvents:UIControlEventTouchUpInside];
    pendingCell.meetingTitle.Tag=(int)indexPath.row;
    return pendingCell;
}
#pragma mark - end

#pragma mark - IBActions

- (IBAction)meetingDetail:(MyButton *)sender
{
    btnTag=[sender Tag];
}
#pragma mark - end

#pragma mark <ARSPopoverDelegate>

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    // delegate for you to use.
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
    return YES;
}
#pragma mark - end
@end
