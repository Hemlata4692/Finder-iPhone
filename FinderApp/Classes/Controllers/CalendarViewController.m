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
#import "ConferenceService.h"
#import "CalendarDataModel.h"

@interface CalendarViewController ()
{
    NSMutableArray *calendarDetailsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@end

@implementation CalendarViewController
@synthesize calendarTableView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Calendar";
    calendarDetailsArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCalendarDetails) withObject:nil afterDelay:.1];
    
}
#pragma mark - end

#pragma mark - Webservice
-(void)getCalendarDetails
{
    [[ConferenceService sharedManager] getCalendarDetails:[UserDefaultManager getValue:@"conferenceId"] success:^(id calendarDataArray) {
        [myDelegate stopIndicator];
        calendarDetailsArray=[calendarDataArray mutableCopy];
//        [self displayConferenceDetail];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
}

#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    dateLabel.text=@"Thursday 25th Feburary";
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

@end
