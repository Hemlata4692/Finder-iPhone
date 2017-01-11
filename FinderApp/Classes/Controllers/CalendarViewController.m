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

@property (weak, nonatomic) IBOutlet UILabel *noResultFoundLabel;
@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@end

@implementation CalendarViewController
@synthesize calendarTableView;
@synthesize noResultFoundLabel;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Calendar";
    sectionArray=[[NSMutableArray alloc]init];
    contactArray=[[NSMutableArray alloc]init];
    noResultFoundLabel.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarDetails) name:@"CalendarDetails" object:nil];
}
//Get calendar details
- (void)calendarDetails {
    [myDelegate showIndicator];
    [self performSelector:@selector(getCalendarDetails) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    myDelegate.currentNavigationController=self.navigationController;
    myDelegate.myView=@"CalendarViewController";
    [myDelegate showIndicator];
    [self performSelector:@selector(getCalendarDetails) withObject:nil afterDelay:.1];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    myDelegate.myView=@"other";
}
#pragma mark - end

#pragma mark - Webservice
- (void)getCalendarDetails {
    
    [[ConferenceService sharedManager] getCalendarDetails:[UserDefaultManager getValue:@"conferenceId"] success:^(id dataArray) {
        [self contactDetails];
        sectionArray=[dataArray mutableCopy];
        if (sectionArray==nil) {
            noResultFoundLabel.hidden=NO;
            noResultFoundLabel.text=@"No calender added.";
            calendarTableView.hidden=YES;
        }
        else {
            calendarTableView.hidden=NO;
            noResultFoundLabel.hidden=YES;
            for (int i=0; i<sectionArray.count; i++) {
                for (int j=0; j<[[sectionArray objectAtIndex:i]eventArray].count; j++) {
                    NSString *conferenceDate =@"";
                    if ([[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] containsString:@"st"]) {
                        conferenceDate = [NSString stringWithFormat:@"%@ %@ %@ %@",[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:0],[[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] stringByReplacingOccurrencesOfString: @"st" withString:@""],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:2],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:3]];
                    }
                    else if ([[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] containsString:@"nd"]){
                        conferenceDate = [NSString stringWithFormat:@"%@ %@ %@ %@",[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:0],[[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] stringByReplacingOccurrencesOfString: @"nd" withString:@""],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:2],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:3]];
                    }
                    else if ([[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "]  objectAtIndex:1] containsString:@"rd"]){
                        conferenceDate = [NSString stringWithFormat:@"%@ %@ %@ %@",[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:0],[[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] stringByReplacingOccurrencesOfString: @"rd" withString:@""],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:2],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:3]];
                    }
                    else if ([[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "]  objectAtIndex:1] containsString:@"th"]){
                        conferenceDate = [NSString stringWithFormat:@"%@ %@ %@ %@",[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:0],[[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:1] stringByReplacingOccurrencesOfString: @"th" withString:@""],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:2],[[[[sectionArray objectAtIndex:i]conferenceDate] componentsSeparatedByString:@" "] objectAtIndex:3]];
                    }
                    EventDataModel *data=[[[sectionArray objectAtIndex:i]eventArray] objectAtIndex:j];
                    NSArray *dateStrings = [data.eventTime componentsSeparatedByString:@"-"];
                    conferenceDate=[NSString stringWithFormat:@"%@ %@",conferenceDate,[dateStrings objectAtIndex:0]];
                    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
                    NSLocale *locale = [[NSLocale alloc]
                                        initWithLocaleIdentifier:@"en_US"];
                    [dateFormat setLocale:locale];
                    [dateFormat setDateFormat:@"EEEE d MMMM yyyy HH:mm"];
                    NSDate *date =[dateFormat dateFromString:conferenceDate];
                    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
                    NSString *fireDate=[dateFormat stringFromDate:date];
                    NSDate *startDate = [dateFormat dateFromString:fireDate];
                    NSComparisonResult result;
                    result = [[NSDate date] compare:startDate]; // comparing two dates
                    if(result==NSOrderedAscending){
                        NSLog(@"date1 is less than date2");
                        NSTimeInterval notiInterval =[startDate timeIntervalSinceDate:[NSDate date]] -15*60;
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:notiInterval];
                        notification.alertBody = [NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",fireDate];
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = 0;
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",startDate] forKey:@"Calender"];
                        notification.userInfo = infoDict;
                        //check if notification is already set or not
                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
                        for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
                            if ([localNotification.userInfo isEqualToDictionary:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",startDate] forKey:@"Calender"]]) {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                        }
                        //if notification exists cancel and set
                        NSMutableArray *notifications = [[NSMutableArray alloc] init];
                        [notifications addObject:notification];
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    }
                    else if(result==NSOrderedDescending) {
                        NSLog(@"date1 is greater than date2");
                    }
                    else {
                        //  equal
                        NSTimeInterval notiInterval =[startDate timeIntervalSinceDate:[NSDate date]] -15*60;
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:notiInterval];
                        notification.alertBody = [NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",fireDate];
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = 0;
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",startDate] forKey:@"Calender"];
                        notification.userInfo = infoDict;
                        //check if notification is already set or not
                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
                        for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
                            if ([localNotification.userInfo isEqualToDictionary:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@ %@ %@",@"You have a",data.eventName,@"at",startDate] forKey:@"Calender"]]) {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                        }
                        //if notification exists cancel and set
                        NSMutableArray *notifications = [[NSMutableArray alloc] init];
                        [notifications addObject:notification];
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    }
                }
            }
        }
        [calendarTableView reloadData];
    }
                                                  failure:^(NSError *error)
     {
         noResultFoundLabel.hidden=NO;
         noResultFoundLabel.text=@"No calender added.";
         calendarTableView.hidden=YES;
     }] ;
}
- (void)contactDetails {
    [[ConferenceService sharedManager] getContactDetails:^(id dataArray) {
        [myDelegate stopIndicator];
        contactArray=[dataArray mutableCopy];
    }
                                                 failure:^(NSError *error)
     {
     }] ;
}

- (void)deleteScheduledMeeting:(NSString *)appointmentId {
    [[ConferenceService sharedManager] deleteScheduledMeeting:appointmentId success:^(id responseObject) {
        [self getCalendarDetails];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    NSArray *dateStrings = [[[sectionArray objectAtIndex:section]conferenceDate] componentsSeparatedByString:@" "];
    NSMutableString *string = [[NSMutableString alloc]init];
    NSString *result;
    for (int i=0; i<dateStrings.count-1; i++) {
        result = [dateStrings objectAtIndex:i];
        [string appendString:[NSString stringWithFormat:@"%@ ",result]];
    }
    dateLabel.text=string;
    float width =  [dateLabel.text boundingRectWithSize:dateLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:dateLabel.font } context:nil]
    .size.width;
    dateLabel.frame = CGRectMake(12, 0, width,40.0);
    dateLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
    [headerView addSubview:dateLabel];
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return 5;
    return [[sectionArray objectAtIndex:section]eventArray].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"calendarCell";
    CalendarTableViewCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (calendarCell == nil) {
        calendarCell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [calendarCell.containerView addShadow:calendarCell.containerView color:[UIColor lightGrayColor]];
    calendarCell.viewAgendaButton.Tag=(int)indexPath.row;
    calendarCell.viewAgendaButton.sectionTag=(int)indexPath.section;
    calendarCell.editButton.Tag=(int)indexPath.row;
    calendarCell.editButton.sectionTag=(int)indexPath.section;
    calendarCell.deleteButton.Tag=(int)indexPath.row;
    calendarCell.deleteButton.sectionTag=(int)indexPath.section;
    
    [calendarCell.viewAgendaButton addTarget:self action:@selector(viewAgendaButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [calendarCell.userImageClickAction addTarget:self action:@selector(userProfileAction:) forControlEvents:UIControlEventTouchUpInside];
    [calendarCell.editButton addTarget:self action:@selector(editMeetingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [calendarCell.deleteButton addTarget:self action:@selector(deleteMeetingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    calendarCell.userImageClickAction.Tag=(int)indexPath.row;
    calendarCell.userImageClickAction.sectionTag=(int)indexPath.section;
    EventDataModel *data=[[[sectionArray objectAtIndex:indexPath.section]eventArray] objectAtIndex:indexPath.row];
    [calendarCell displayData:data indexPath:(int)indexPath.row];
    return calendarCell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)userProfileAction:(MyButton *)sender {
    int btnTag=[sender Tag];
    int sectionTag= [sender sectionTag];
    EventDataModel *data=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    profileView.otherUserID=data.userId;
    [self.navigationController pushViewController:profileView animated:YES];
}

- (IBAction)viewAgendaButonAction:(MyButton *)sender {
    int btnTag=[sender Tag];
    int sectionTag= [sender sectionTag];
    EventDataModel *data=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingDescriptionViewController *descreptionView =[storyboard instantiateViewControllerWithIdentifier:@"MeetingDescriptionViewController"];
    descreptionView.meetingDescription=data.eventDescription;
    descreptionView.meetingLocation=data.eventVenue;
    descreptionView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    [descreptionView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:descreptionView animated: NO completion:nil];
}

- (IBAction)editMeetingButtonAction:(MyButton *)sender {
    int btnTag=[sender Tag];
    int sectionTag= [sender sectionTag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.screenName=@"Edit Meeting";
    scheduleMeeting.calenderObj=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
    scheduleMeeting.contactDetailArray=[contactArray mutableCopy];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
}

- (IBAction)deleteMeetingButtonAction:(MyButton *)sender {
    int btnTag=[sender Tag];
    int sectionTag= [sender sectionTag];
    EventDataModel *data=[[[sectionArray objectAtIndex:sectionTag]eventArray] objectAtIndex:btnTag];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
         [myDelegate showIndicator];
        [self deleteScheduledMeeting:data.eventId];
    }];
    [alert showWarning:nil title:nil subTitle:@"Are you sure, you want to delete this appointment?" closeButtonTitle:@"No" duration:0.0f];
}

- (IBAction)addButtonAction:(id)sender {
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
