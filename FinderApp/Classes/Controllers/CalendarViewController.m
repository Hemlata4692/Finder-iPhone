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
#import "CalendarDataModel.h"
#import "EventDataModel.h"
#import "MyButton.h"
#import "MeetingDescriptionViewController.h"
#import "MyProfileViewController.h"

@interface CalendarViewController ()
{
    NSMutableArray *sectionArray;
    NSMutableArray *contactArray;
}

@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@end

@implementation CalendarViewController
@synthesize calendarTableView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Calendar";
    sectionArray=[[NSMutableArray alloc]init];
    contactArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCalendarDetails) withObject:nil afterDelay:.1];
    
}
#pragma mark - end

#pragma mark - Webservice
-(void)getCalendarDetails {
    
    [[ConferenceService sharedManager] getCalendarDetails:[UserDefaultManager getValue:@"conferenceId"] success:^(id dataArray) {
        [self contactDetails];
        sectionArray=[dataArray mutableCopy];
        for (int i=0; i<sectionArray.count; i++) {
            for (int j=0; j<[[sectionArray objectAtIndex:i]eventArray].count; j++) {
               EventDataModel *data=[[[sectionArray objectAtIndex:i]eventArray] objectAtIndex:j];
                NSArray *dateStrings = [data.eventTime componentsSeparatedByString:@"-"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *startDate = [dateFormatter dateFromString:[dateStrings objectAtIndex:0]];
               // NSDate *endDate = [dateFormatter dateFromString:[dateStrings objectAtIndex:1]];
                NSTimeInterval notiInterval =[startDate timeIntervalSinceDate:[NSDate date]] -15*60;
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:notiInterval];
                notification.alertBody = [NSString stringWithFormat:@"%@ %@ %@ %@",@"You have calender event for",data.eventName,@"at",startDate];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber = 0;
                NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@ %@ %@",@"You have calender event for",data.eventName,@"at",startDate] forKey:@"Calender"];
                notification.userInfo = infoDict;
                NSMutableArray *notifications = [[NSMutableArray alloc] init];
                [notifications addObject:notification];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
         [calendarTableView reloadData];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
}
-(void)contactDetails {
    [[ConferenceService sharedManager] getContactDetails:^(id dataArray) {
        [myDelegate stopIndicator];
        contactArray=[dataArray mutableCopy];
    }
                                                  failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return sectionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    NSArray *dateStrings = [[[sectionArray objectAtIndex:section]conferenceDate] componentsSeparatedByString:@" "];
    NSMutableString *string = [[NSMutableString alloc]init];
    NSString *result;
    for (int i=0; i<dateStrings.count-1; i++) {
        result = [dateStrings objectAtIndex:i];
        [string appendString:[NSString stringWithFormat:@"%@ ",result]];
    }
    NSLog(@"response %@",string);
    dateLabel.text=string;
    float width =  [dateLabel.text boundingRectWithSize:dateLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:dateLabel.font } context:nil]
    .size.width;
    dateLabel.frame = CGRectMake(12, 0, width,40.0);
    dateLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
    [headerView addSubview:dateLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return 5;
    return [[sectionArray objectAtIndex:section]eventArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *simpleTableIdentifier = @"calendarCell";
    CalendarTableViewCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (calendarCell == nil)
    {
        calendarCell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [calendarCell.containerView addShadow:calendarCell.containerView color:[UIColor lightGrayColor]];
    calendarCell.viewAgendaButton.Tag=(int)indexPath.row;
    calendarCell.viewAgendaButton.sectionTag=(int)indexPath.section;
    [calendarCell.viewAgendaButton addTarget:self action:@selector(viewAgendaButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [calendarCell.userImageClickAction addTarget:self action:@selector(userProfileAction:) forControlEvents:UIControlEventTouchUpInside];
    EventDataModel *data=[[[sectionArray objectAtIndex:indexPath.section]eventArray] objectAtIndex:indexPath.row];
    [calendarCell displayData:data indexPath:(int)indexPath.row];
    return calendarCell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)userProfileAction:(MyButton *)sender {
//    int btnTag=[sender Tag];
//    int sectionTag= [sender sectionTag];
//    EventDataModel *data=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
//    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
//    profileView.otherUserID=@"";
//     [self.navigationController pushViewController:profileView animated:YES];
}

- (IBAction)viewAgendaButonAction:(MyButton *)sender {
    int btnTag=[sender Tag];
    int sectionTag= [sender sectionTag];
    EventDataModel *data=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingDescriptionViewController *descreptionView =[storyboard instantiateViewControllerWithIdentifier:@"MeetingDescriptionViewController"];
    descreptionView.meetingDescription=data.eventDescription;
    descreptionView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    [descreptionView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:descreptionView animated: NO completion:nil];
}

- (IBAction)addButtonAction:(id)sender{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.screenName=@"Calendar";
    scheduleMeeting.contactDetailArray=[contactArray mutableCopy];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
}
#pragma mark - end
@end
