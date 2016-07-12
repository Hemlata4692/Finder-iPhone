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

@interface ProximityAlertsViewController ()
{
    NSMutableArray *proximityDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *proximityAlertTableView;
@end

@implementation ProximityAlertsViewController
@synthesize proximityAlertTableView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Proximity Alerts";
    myDelegate.currentNavigationController=self.navigationController;
    NSLog(@"slider value %@",[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"]);
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getProximityAlerts) withObject:nil afterDelay:.1];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else {
        return proximityDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 125;
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString *simpleTableIdentifier = @"proximityRadiusCell";
        ProximityAlertViewCell *proximityCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (proximityCell == nil)  {
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
        if (listCell == nil)
        {
            listCell = [[ProximityAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [listCell.proximityListContainerView addShadow:listCell.proximityListContainerView color:[UIColor lightGrayColor]];
        [listCell.scheduleMeetingBtn addTarget:self action:@selector(scheduleMeeting:) forControlEvents:UIControlEventTouchUpInside];
        //  [settingsCell.switchBtn addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        ContactDataModel *data=[proximityDataArray objectAtIndex:indexPath.row];
        [listCell displayData:data indexPath:(int)indexPath.row];
        return listCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 4)
    //    {
    //        changePwdContainerView.hidden = NO;
    //    }
}
#pragma mark - end

#pragma mark - IBActions
//slider value
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)slider{
    [slider setValue:((int)((slider.value + 2.5) / 25) * 25)];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}

- (IBAction)scheduleMeeting:(UIButton *)sender{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.screenName=@"Proximity";
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
    
}
- (IBAction)doneButtonAction:(id)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(getProximityAlerts) withObject:nil afterDelay:.1];
}
#pragma mark - end
#pragma mark - Webservice
-(void)getProximityAlerts{
    
    [[ConferenceService sharedManager] getproximityalerts:[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"]  success:^(id responseObject) {
        [myDelegate stopIndicator];
        proximityDataArray=[responseObject mutableCopy];
        [proximityAlertTableView reloadData];
    }
                                                  failure:^(NSError *error)
     {
         
     }] ;
}

@end
