//
//  ProximityAlertsViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProximityAlertsViewController.h"
#import "ProximityAlertViewCell.h"
#import "ScheduleMeetingViewController.h"
#import "ConferenceService.h"
#import "ContactDataModel.h"
#import "MyButton.h"
#import "PersonalMessageViewController.h"

@interface ProximityAlertsViewController ()
{
    NSMutableArray *proximityDataArray;
    int btnTag;
}
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *proximityAlertTableView;
@end

@implementation ProximityAlertsViewController
@synthesize proximityAlertTableView;
@synthesize noResultLabel;
@synthesize doneButton;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Proximity Alerts";
    myDelegate.currentNavigationController=self.navigationController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityAlerts) name:@"ProximityAlerts" object:nil];
}
- (void)proximityAlerts {
    [myDelegate removeBadgeIconLastTab];
    [myDelegate showIndicator];
    [self performSelector:@selector(getProximityAlerts) withObject:nil afterDelay:0.1];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    myDelegate.myView=@"ProximityAlertsViewController";
    [myDelegate showIndicator];
    [self performSelector:@selector(getProximityAlerts) withObject:nil afterDelay:.1];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    myDelegate.myView=@"other";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        return proximityDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 125;
    }
    else {
        return 70;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NSString *simpleTableIdentifier = @"proximityRadiusCell";
        ProximityAlertViewCell *proximityCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (proximityCell == nil) {
            proximityCell = [[ProximityAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [proximityCell.delegateRangeView addShadow:proximityCell.delegateRangeView color:[UIColor lightGrayColor]];
        proximityCell.sliderView.minimumValue=25;
        proximityCell.sliderView.maximumValue=200;
        [proximityCell.sliderView setValue:[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue]];
        [proximityCell.sliderView setMaxFractionDigitsDisplayed:0];
        proximityCell.sliderView.popUpViewColor = [UIColor colorWithRed:47.0/255.0 green:81.0/255.0 blue:116.0/255.0 alpha:1.0];
        proximityCell.sliderView.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        proximityCell.sliderView.textColor = [UIColor whiteColor];
        proximityCell.sliderView.popUpViewWidthPaddingFactor = 1.7;
        [proximityCell.sliderView showPopUpViewAnimated:YES];
        [proximityCell.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        return proximityCell;
    }
    else {
        NSString *simpleTableIdentifier = @"proximityListCell";
        ProximityAlertViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (listCell == nil) {
            listCell = [[ProximityAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [listCell.proximityListContainerView addShadow:listCell.proximityListContainerView color:[UIColor lightGrayColor]];
        [listCell.scheduleMeetingBtn addTarget:self action:@selector(scheduleMeeting:) forControlEvents:UIControlEventTouchUpInside];
        [listCell.sendMessageBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        listCell.scheduleMeetingBtn.Tag=(int)indexPath.row;
        listCell.sendMessageBtn.Tag=(int)indexPath.row;
        ContactDataModel *data=[proximityDataArray objectAtIndex:indexPath.row];
        [listCell displayData:data indexPath:(int)indexPath.row];
        return listCell;
    }
}
#pragma mark - end

#pragma mark - IBActions
//slider value
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)slider {
    [slider setValue:((int)((slider.value + 2.5) / 25) * 25)];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}
- (IBAction)scheduleMeeting:(MyButton *)sender {
    btnTag=[sender Tag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.screenName=@"Proximity";
    scheduleMeeting.ContactName=[[proximityDataArray objectAtIndex:btnTag]contactName];
    scheduleMeeting.contactUserID=[[proximityDataArray objectAtIndex:btnTag]contactUserId];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
}
- (IBAction)sendMessage:(MyButton *)sender {
    btnTag=[sender Tag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalMessageViewController *messageView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
    messageView.otherUserName=[[proximityDataArray objectAtIndex:btnTag]contactName];
    messageView.otherUserId=[[proximityDataArray objectAtIndex:btnTag]contactUserId];
    [self.navigationController pushViewController:messageView animated:YES];
}
- (IBAction)doneButtonAction:(id)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(getProximityAlerts) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getProximityAlerts {
    
    [[ConferenceService sharedManager] getProximityAlerts:[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"]  success:^(id dataArray) {
        [myDelegate stopIndicator];
        proximityDataArray=[dataArray mutableCopy];
        if (proximityDataArray==nil) {
            noResultLabel.hidden=NO;
            noResultLabel.text=@"No result found.";
            proximityAlertTableView.hidden=YES;
            doneButton.hidden=YES;
        }
        else {
            proximityAlertTableView.hidden=NO;
            doneButton.hidden=NO;
            noResultLabel.hidden=YES;
            [proximityAlertTableView reloadData];
        }
        
    }
                                                  failure:^(NSError *error)
     {
     }] ;
}
#pragma mark - end

@end
